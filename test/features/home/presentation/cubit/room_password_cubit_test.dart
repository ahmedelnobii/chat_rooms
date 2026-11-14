import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits loading then success for a valid password', () async {
    final cubit = RoomPasswordCubit(_FakeHomeRepo((_, _) async => true));
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<RoomPasswordLoading>(), isA<RoomPasswordSuccess>()]),
    );

    await cubit.verifyRoomPassword('room-id', 'correct');
    await states;
    await cubit.close();
  });

  test('returns to initial with a message for an incorrect password', () async {
    final cubit = RoomPasswordCubit(_FakeHomeRepo((_, _) async => false));

    await cubit.verifyRoomPassword('room-id', 'wrong');

    expect(cubit.state, isA<RoomPasswordInitial>());
    expect(
      (cubit.state as RoomPasswordInitial).message,
      'Incorrect room password.',
    );
    await cubit.close();
  });

  test('rejects empty passwords without calling the repository', () async {
    final repo = _FakeHomeRepo((_, _) async => true);
    final cubit = RoomPasswordCubit(repo);

    await cubit.verifyRoomPassword('room-id', '  ');

    expect(repo.verificationCalls, 0);
    expect(
      (cubit.state as RoomPasswordInitial).message,
      'Please enter the room password.',
    );
    await cubit.close();
  });

  test('surfaces repository errors as an initial message', () async {
    final cubit = RoomPasswordCubit(
      _FakeHomeRepo((_, _) async => throw Exception('Verification failed')),
    );

    await cubit.verifyRoomPassword('room-id', 'password');

    expect((cubit.state as RoomPasswordInitial).message, 'Verification failed');
    await cubit.close();
  });
}

class _FakeHomeRepo implements HomeRepo {
  final Future<bool> Function(String roomID, String password) verify;
  int verificationCalls = 0;

  _FakeHomeRepo(this.verify);

  @override
  Stream<List<RoomModel>> getAllRooms() => const Stream.empty();

  @override
  Stream<List<RoomModel>> getMyRooms() => const Stream.empty();

  @override
  Future<bool> verifyRoomPassword(String roomID, String password) {
    verificationCalls++;
    return verify(roomID, password);
  }
}
