import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class ChatRepo {
  Stream<List<MessageModel>> getMessages(String roomID);
  Future<Either<Failer, void>> sendMessage(MessageModel message);
}
