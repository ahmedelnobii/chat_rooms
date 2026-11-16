import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class ChatRemoteDataSource {
  Future<RoomModel> getRoom(String roomID);
  Stream<List<MessageModel>> getMessages(String roomID);
  Future<void> sendMessage(MessageModel msg);
  Future<void> deleteRoom(String roomID);
}
