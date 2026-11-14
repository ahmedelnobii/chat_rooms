const assert = require('node:assert/strict');
const test = require('node:test');
const { hashRoomPassword, verifyRoomPassword } = require('../room_password');

test('room password hashes are salted and verify only the matching password', async () => {
  const password = 'correct horse battery staple';
  const first = await hashRoomPassword(password);
  const second = await hashRoomPassword(password);

  assert.notEqual(first.hash, password);
  assert.notEqual(first.salt, second.salt);
  assert.equal(await verifyRoomPassword(password, first.salt, first.hash), true);
  assert.equal(await verifyRoomPassword('incorrect', first.salt, first.hash), false);
});
