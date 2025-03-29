import 'package:yocut/data/repositories/chatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChatDeleteMessageStatus { initial, loading, success, failure }

class ChatDeleteMessageCubit extends Cubit<ChatDeleteMessageStatus> {
  ChatDeleteMessageCubit() : super(ChatDeleteMessageStatus.initial);

  ChatRepository _chatRepository = ChatRepository();

  void deleteMessage({required List<int> messagesIds}) async {
    emit(ChatDeleteMessageStatus.loading);

    try {
      await _chatRepository.deleteMessage(messagesIds: messagesIds);
      if (!isClosed) emit(ChatDeleteMessageStatus.success);
    } catch (e) {
      if (!isClosed) emit(ChatDeleteMessageStatus.failure);
    }
  }
}
