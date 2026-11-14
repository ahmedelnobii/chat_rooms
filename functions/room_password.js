const { promisify } = require('node:util');
const { randomBytes, scrypt, timingSafeEqual } = require('node:crypto');

const scryptAsync = promisify(scrypt);
const keyLength = 64;
const scryptOptions = {
  N: 1 << 14,
  r: 8,
  p: 1,
  maxmem: 64 * 1024 * 1024,
};

async function hashRoomPassword(password) {
  const salt = randomBytes(16);
  const hash = await scryptAsync(password, salt, keyLength, scryptOptions);
  return {
    salt: salt.toString('base64'),
    hash: hash.toString('base64'),
  };
}

async function verifyRoomPassword(password, salt, expectedHash) {
  const expected = Buffer.from(expectedHash, 'base64');
  if (expected.length !== keyLength) return false;

  const actual = await scryptAsync(
    password,
    Buffer.from(salt, 'base64'),
    keyLength,
    scryptOptions,
  );
  return timingSafeEqual(actual, expected);
}

module.exports = { hashRoomPassword, verifyRoomPassword };
