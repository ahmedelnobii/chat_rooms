import 'package:chat_rooms/features/chat/data/models/message_model.dart';

abstract class ChatState {}

class ChatInit extends ChatState {}

class SendMessageLoading extends ChatState {}

class SendMessageSuccess extends ChatState {}

class SendMessageError extends ChatState {
  final String msg;
  SendMessageError(this.msg);
}

class GetMessageSuccess extends ChatState {
  final List<MessageModel> msgs;
  GetMessageSuccess(this.msgs);
}

class GetMessageLoading extends ChatState {}

class GetMessageError extends ChatState {
  final String msg;
  GetMessageError(this.msg);
}
