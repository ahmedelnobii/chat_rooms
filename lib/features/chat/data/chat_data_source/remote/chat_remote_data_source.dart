import 'package:chat_rooms/core/models/room_model.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class ChatRemoteDataSource {
  Future<RoomModel> getRoom(String roomID);
  Stream<RoomModel> watchRoom(String roomID);
  Future<void> joinRoomPresence({
    required String roomID,
    required String userID,
    required String userName,
  });
  Future<void> leaveRoomPresence({
    required String roomID,
    required String userID,
  });
  Stream<List<MessageModel>> getMessages(String roomID);
  Future<void> sendMessage(MessageModel msg);
  Future<void> deleteRoom(String roomID);
}
