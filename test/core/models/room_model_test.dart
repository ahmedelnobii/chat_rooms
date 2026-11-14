import 'package:chat_rooms/core/models/room_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RoomModel createRoom({bool isPrivate = false, String? password}) => RoomModel(
    creatorId: 'user-id',
    creatorName: 'Creator',
    roomID: 'room-id',
    roomName: 'Room',
    description: 'Room description',
    isPrivate: isPrivate,
    password: password,
  );

  test(
    'rooms default to public and serialized room data never includes password',
    () {
      final room = createRoom(password: 'not-for-listings');

      expect(room.isPrivate, isFalse);
      expect(room.toJson(), isNot(contains('password')));
    },
  );

  test('private status is serialized without the password', () {
    final room = createRoom(isPrivate: true, password: 'secret');
    final json = room.toJson();

    expect(json['isPrivate'], isTrue);
    expect(json, isNot(contains('password')));
    expect(RoomModel.fromJson(json).isPrivate, isTrue);
    expect(RoomModel.fromJson(json).password, isNull);
  });
}
