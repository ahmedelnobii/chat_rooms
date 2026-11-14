import 'package:chat_rooms/core/errors/failer.dart';
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_remote_data_source.dart';
import 'package:chat_rooms/features/chat/data/models/message_model.dart';
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ChatRepo)
class ChatRepoImpl implements ChatRepo {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepoImpl(this._chatRemoteDataSource);

  @override
  Stream<List<MessageModel>> getMessages(String roomID) {
    return _chatRemoteDataSource.getMessages(roomID);
  }

  @override
  Future<Either<Failer, void>> sendMessage(MessageModel message) async {
    try {
      await _chatRemoteDataSource.sendMessage(message);
      return const Right(null);
    } catch (e) {
      return Left(Failer(e.toString()));
    }
  }
}
