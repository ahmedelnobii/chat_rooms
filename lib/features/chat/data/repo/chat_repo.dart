import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class ChatRepo {
  Future<Either<Failer, RoomModel>> getRoom(String roomID);
  Stream<List<MessageModel>> getMessages(String roomID);
  Future<Either<Failer, void>> sendMessage(MessageModel message);
  Future<Either<Failer, void>> deleteRoom(String roomID);
}
