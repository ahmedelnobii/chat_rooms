const admin = require('firebase-admin');
const { HttpsError, onCall } = require('firebase-functions/v2/https');
const { hashRoomPassword, verifyRoomPassword } = require('./room_password');

admin.initializeApp();

const firestore = admin.firestore();

function requireAuthenticatedUser(request) {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'Sign in to continue.');
  }
  return request.auth.uid;
}

function requireText(value, field, maxLength) {
  if (
    typeof value !== 'string' ||
    value.trim().length === 0 ||
    value.length > maxLength
  ) {
    throw new HttpsError('invalid-argument', `Invalid ${field}.`);
  }
  return value.trim();
}

exports.createRoom = onCall(async (request) => {
  const userId = requireAuthenticatedUser(request);
  const data = request.data || {};
  const roomName = requireText(data.roomName, 'room name', 100);
  const roomDescription = requireText(data.roomDescription, 'description', 1000);
  const roomCreatorName = requireText(data.roomCreatorName, 'creator name', 100);
  const isPrivate = data.isPrivate === true;
  const password = data.password;

  if (
    isPrivate &&
    (typeof password !== 'string' ||
      password.trim().length === 0 ||
      password.length > 128)
  ) {
    throw new HttpsError('invalid-argument', 'A valid room password is required.');
  }

  const roomRef = firestore.collection('allRooms').doc();
  const secret = isPrivate ? await hashRoomPassword(password) : null;

  await firestore.runTransaction(async (transaction) => {
    transaction.set(roomRef, {
      roomID: roomRef.id,
      roomName,
      roomDescription,
      roomCreatorName,
      roomCreatorID: userId,
      isPrivate,
    });

    if (secret) {
      transaction.set(firestore.collection('roomSecrets').doc(roomRef.id), {
        salt: secret.salt,
        passwordHash: secret.hash,
      });
      transaction.set(
        firestore
          .collection('roomMembers')
          .doc(roomRef.id)
          .collection('members')
          .doc(userId),
        { role: 'owner' },
      );
    }
  });

  return { roomID: roomRef.id };
});

exports.verifyRoomPassword = onCall(async (request) => {
  const userId = requireAuthenticatedUser(request);
  const data = request.data || {};
  const roomID = requireText(data.roomID, 'room ID', 128);
  const password = data.password;
  if (
    typeof password !== 'string' ||
    password.trim().length === 0 ||
    password.length > 128
  ) {
    throw new HttpsError('invalid-argument', 'A valid room password is required.');
  }

  const roomSnapshot = await firestore.collection('allRooms').doc(roomID).get();
  if (!roomSnapshot.exists || roomSnapshot.data().isPrivate !== true) {
    return { valid: false };
  }

  const secretSnapshot = await firestore.collection('roomSecrets').doc(roomID).get();
  const secret = secretSnapshot.data();
  if (
    !secret ||
    typeof secret.salt !== 'string' ||
    typeof secret.passwordHash !== 'string'
  ) {
    return { valid: false };
  }

  const valid = await verifyRoomPassword(password, secret.salt, secret.passwordHash);
  if (valid) {
    await firestore
      .collection('roomMembers')
      .doc(roomID)
      .collection('members')
      .doc(userId)
      .set({ role: 'member' });
  }

  return { valid };
});
