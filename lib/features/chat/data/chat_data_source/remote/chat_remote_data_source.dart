import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:injectable/injectable.dart';

@singleton
abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages(String roomID);
  Future<void> sendMessage(MessageModel msg);
}
