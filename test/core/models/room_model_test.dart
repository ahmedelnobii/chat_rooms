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
    'rooms default to public and public rooms do not serialize password',
    () {
      final room = createRoom(password: 'not-for-public-rooms');

      expect(room.isPrivate, isFalse);
      expect(room.toJson(), isNot(contains('password')));
    },
  );

  test('private rooms serialize and deserialize password via model', () {
    final room = createRoom(isPrivate: true, password: 'secret');
    final json = room.toJson();

    expect(json['isPrivate'], isTrue);
    expect(json['password'], 'secret');
    final parsed = RoomModel.fromJson(json);
    expect(parsed.isPrivate, isTrue);
    expect(parsed.password, 'secret');
  });

  test('parses active members map from json', () {
    final room = RoomModel.fromJson({
      'roomCreatorID': 'creator-1',
      'roomCreatorName': 'Creator',
      'roomID': 'room-1',
      'roomName': 'Flutter Room',
      'roomDescription': 'Desc',
      'isPrivate': false,
      'members': {'u1': 'Ahmed', 'u2': 'Sara'},
    });

    expect(room.members, [
      const RoomMemberModel(userID: 'u1', name: 'Ahmed'),
      const RoomMemberModel(userID: 'u2', name: 'Sara'),
    ]);
  });
}
