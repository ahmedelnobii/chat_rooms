import 'dart:async';

import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/auth/data/model/user_model.dart';
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart';
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_rooms/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart';
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets(
    'shows initialRoom title and description before live room loads, then updates with live data',
    (tester) async {
      final roomStream = StreamController<RoomModel>.broadcast();
      final chatCubit = ChatCubit(_FakeChatRepo(roomStream.stream))
        ..watchRoom('room-1');
      final likedCubit = LikedCubit(_FakeLikedRepo());
      final authCubit = AuthCubit(_FakeAuthRepo())
        ..cuurentUser = UserModel(
          name: 'Ahmed',
          email: 'ahmed@example.com',
          userID: 'user-1',
        );

      final initialRoom = RoomModel(
        creatorId: 'creator-1',
        creatorName: 'Creator',
        roomID: 'room-1',
        roomName: 'Initial Name',
        description: 'Initial Description',
        members: const [RoomMemberModel(userID: 'old', name: 'Stale User')],
      );

      await tester.pumpWidget(
        _wrapApp(
          chatCubit: chatCubit,
          likedCubit: likedCubit,
          authCubit: authCubit,
          child: ChatAppBar(roomID: 'room-1', initialRoom: initialRoom),
        ),
      );
      await tester.pump();

      // Shows initialRoom name & description immediately, without showing stale member count
      expect(find.text('Initial Name'), findsOneWidget);
      expect(find.text('Initial Description'), findsOneWidget);
      expect(find.text('1 member'), findsNothing);
      expect(find.byType(Shimmer), findsOneWidget);

      // Live room arrives from Firestore
      roomStream.add(
        RoomModel(
          creatorId: 'creator-1',
          creatorName: 'Creator',
          roomID: 'room-1',
          roomName: 'Live Name',
          description: 'Live Description',
          members: const [
            RoomMemberModel(userID: 'u1', name: 'Ahmed'),
            RoomMemberModel(userID: 'u2', name: 'Sara'),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Live Name'), findsOneWidget);
      expect(find.text('Live Description'), findsOneWidget);
      expect(find.text('2 members'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);

      await chatCubit.close();
      await likedCubit.close();
      await authCubit.close();
      await roomStream.close();
    },
  );

  testWidgets('shows shimmer when neither live room nor initialRoom is present', (
    tester,
  ) async {
    final roomStream = StreamController<RoomModel>.broadcast();
    final chatCubit = ChatCubit(_FakeChatRepo(roomStream.stream));
    final likedCubit = LikedCubit(_FakeLikedRepo());
    final authCubit = AuthCubit(_FakeAuthRepo())
      ..cuurentUser = UserModel(
        name: 'Ahmed',
        email: 'ahmed@example.com',
        userID: 'user-1',
      );

    await tester.pumpWidget(
      _wrapApp(
        chatCubit: chatCubit,
        likedCubit: likedCubit,
        authCubit: authCubit,
        child: const ChatAppBar(roomID: 'room-1'),
      ),
    );
    await tester.pump();

    expect(find.byType(Shimmer), findsOneWidget);

    await chatCubit.close();
    await likedCubit.close();
    await authCubit.close();
    await roomStream.close();
  });
}

Widget _wrapApp({
  required ChatCubit chatCubit,
  required LikedCubit likedCubit,
  required AuthCubit authCubit,
  required PreferredSizeWidget child,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: chatCubit),
        BlocProvider.value(value: likedCubit),
        BlocProvider.value(value: authCubit),
      ],
      child: MaterialApp(
        home: Scaffold(appBar: child, body: const SizedBox.shrink()),
      ),
    ),
  );
}

class _FakeChatRepo implements ChatRepo {
  final Stream<RoomModel> _roomStream;

  _FakeChatRepo(this._roomStream);

  @override
  Future<Either<Failer, RoomModel>> getRoom(String roomID) async =>
      Left(Failer('not used'));

  @override
  Stream<RoomModel> watchRoom(String roomID) => _roomStream;

  @override
  Future<Either<Failer, void>> joinRoomPresence({
    required String roomID,
    required String userID,
    required String userName,
  }) async => const Right(null);

  @override
  Future<Either<Failer, void>> leaveRoomPresence({
    required String roomID,
    required String userID,
  }) async => const Right(null);

  @override
  Stream<List<MessageModel>> getMessages(String roomID) => const Stream.empty();

  @override
  Future<Either<Failer, void>> sendMessage(MessageModel message) async =>
      const Right(null);

  @override
  Future<Either<Failer, void>> deleteRoom(String roomID) async =>
      const Right(null);
}

class _FakeLikedRepo implements LikedRepo {
  @override
  Future<Either<Failer, void>> addLikedRoom(RoomModel room) async =>
      const Right(null);

  @override
  Stream<List<RoomModel>> getLikedRooms() => const Stream.empty();

  @override
  Future<Either<Failer, void>> removeLikedRoom(String roomID) async =>
      const Right(null);
}

class _FakeAuthRepo implements AuthRepo {
  @override
  Future<Either<Failer, UserModel>> continueWithGoogle() async =>
      Left(Failer('not used'));

  @override
  Future<Either<Failer, UserModel?>> getCurrentUser() async =>
      const Right(null);

  @override
  Future<Either<Failer, UserModel>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async => Left(Failer('not used'));

  @override
  Future<Either<Failer, void>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async => const Right(null);
}
