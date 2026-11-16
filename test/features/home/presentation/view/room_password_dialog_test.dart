import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:chat_rooms/features/home/presentation/view/widgets/room_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('closes with success when the password is valid', (tester) async {
    final cubit = RoomPasswordCubit(_FakeHomeRepo((_, _) async => true));
    bool? accepted;

    await tester.pumpWidget(_app(cubit, (result) => accepted = result));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'correct');
    await tester.tap(find.text('Join room'));
    await tester.pumpAndSettle();

    expect(accepted, isTrue);
    await cubit.close();
  });

  testWidgets('shows an error message and permits cancel after failure', (
    tester,
  ) async {
    final cubit = RoomPasswordCubit(_FakeHomeRepo((_, _) async => false));
    bool? accepted = true;

    await tester.pumpWidget(_app(cubit, (result) => accepted = result));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('Join room'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect room password.'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(accepted, isNull);
    await cubit.close();
  });
}

Widget _app(RoomPasswordCubit cubit, ValueChanged<bool?> onResult) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const RoomPasswordDialog(roomID: 'room-id'),
              ),
            );
            onResult(result);
          },
          child: const Text('Open'),
        ),
      ),
    ),
  );
}

class _FakeHomeRepo implements HomeRepo {
  final Future<bool> Function(String roomID, String password) verify;

  _FakeHomeRepo(this.verify);

  @override
  Stream<List<RoomModel>> getAllRooms() => const Stream.empty();

  @override
  Stream<List<RoomModel>> getMyRooms() => const Stream.empty();

  @override
  Future<bool> verifyRoomPassword(String roomID, String password) {
    return verify(roomID, password);
  }

  @override
  Future<void> deleteRoom(String roomID) async {}
}
