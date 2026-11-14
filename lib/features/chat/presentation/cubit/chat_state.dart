import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/core/models/room_model.dart';

abstract class ChatState {}

class ChatInit extends ChatState {}

class GetRoomLoading extends ChatState {}

class GetRoomSuccess extends ChatState {
  final RoomModel room;

  GetRoomSuccess(this.room);
}

class GetRoomError extends ChatState {
  final String msg;

  GetRoomError(this.msg);
}

class SendMessageLoading extends ChatState {
  final List<MessageModel>? msgs;

  SendMessageLoading({this.msgs});
}

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
