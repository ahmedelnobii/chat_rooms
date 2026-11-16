import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/view/room_invite_screen.dart';
import 'package:chat_rooms/features/home/data/repo/home_repo.dart';
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('joins a public room from its invite link', (tester) async {
    _registerRoom(isPrivate: false);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Joined room-123'), findsOneWidget);
  });

  testWidgets('asks for a password before joining a private room', (
    tester,
  ) async {
    _registerRoom(isPrivate: true);
    getIt.registerFactory<RoomPasswordCubit>(
      () => RoomPasswordCubit(_FakeHomeRepo()),
    );

    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Private room'), findsOneWidget);
    expect(find.text('Joined room-123'), findsNothing);

    await tester.enterText(find.byType(TextField), 'password');
    await tester.tap(find.text('Join room'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Joined room-123'), findsOneWidget);
  });
}

void _registerRoom({required bool isPrivate}) {
  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(
      _FakeChatRepo(
        RoomModel(
          creatorId: 'creator',
          creatorName: 'Creator',
          roomID: 'room-123',
          roomName: 'Room',
          description: 'Room description',
          isPrivate: isPrivate,
        ),
      ),
    ),
  );
}

Widget _app() {
  final router = GoRouter(
    initialLocation: '/room/room-123',
    routes: [
      GoRoute(
        path: '/room/:id',
        builder: (context, state) =>
            RoomInviteScreen(roomID: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chatScreen/:id',
        builder: (context, state) =>
            Scaffold(body: Text('Joined ${state.pathParameters['id']}')),
      ),
    ],
  );

  return MaterialApp.router(routerConfig: router);
}

class _FakeChatRepo implements ChatRepo {
  final RoomModel room;

  const _FakeChatRepo(this.room);

  @override
  Future<Either<Failer, RoomModel>> getRoom(String roomID) async => Right(room);

  @override
  Stream<List<MessageModel>> getMessages(String roomID) => const Stream.empty();

  @override
  Future<Either<Failer, void>> sendMessage(MessageModel message) async =>
      const Right(null);

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async =>
      const Right(null);
}

class _FakeHomeRepo implements HomeRepo {
  @override
  Stream<List<RoomModel>> getAllRooms() => const Stream.empty();

  @override
  Stream<List<RoomModel>> getMyRooms() => const Stream.empty();

  @override
  Future<bool> verifyRoomPassword(String roomID, String password) async => true;

  @override
  Future<void> deleteRoom(String roomID) async {}
}
