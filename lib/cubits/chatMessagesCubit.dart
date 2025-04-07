import 'package:yocut/data/models/chatMessage.dart';
import 'package:yocut/data/models/chatMessagesResponse.dart';
import 'package:yocut/data/repositories/chatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ChatMessagesState {}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesFetchInProgress extends ChatMessagesState {}

class ChatMessagesFetchFailure extends ChatMessagesState {
  final String message;

  ChatMessagesFetchFailure(this.message);
}

class ChatMessagesFetchSuccess extends ChatMessagesState {
  final ChatMessagesResponse response;
  final bool loadMore;

  ChatMessagesFetchSuccess(this.response, {this.loadMore = false});
}

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  ChatMessagesCubit() : super(ChatMessagesInitial());

  final ChatRepository _chatRepository = ChatRepository();

  void fetchChatMessages({required int receiverId, int page = 1}) async {
    emit(ChatMessagesFetchInProgress());

    await _chatRepository
        .getChatMessages(receiverId: receiverId, page: page)
        .then(
          (response) => emit(ChatMessagesFetchSuccess(response)),
        )
        .catchError(
      (e) {
        if (!isClosed) emit(ChatMessagesFetchFailure(e.toString()));
      },
    );
  }

  bool get hasMore {
    if (state is ChatMessagesFetchSuccess) {
      return (state as ChatMessagesFetchSuccess).response.currentPage <
          (state as ChatMessagesFetchSuccess).response.lastPage;
    }
    return false;
  }

  void fetchMoreChatMessages({required int receiverId}) {
    if (state is ChatMessagesFetchSuccess &&
        !(state as ChatMessagesFetchSuccess).loadMore) {
      final old = (state as ChatMessagesFetchSuccess).response;

      emit(ChatMessagesFetchSuccess(old, loadMore: true));

      _chatRepository
          .getChatMessages(receiverId: receiverId, page: old.currentPage + 1)
          .then(
        (response) {
          final messages = old.messages..addAll(response.messages);

          emit(
            ChatMessagesFetchSuccess(
              response.copyWith(messages: messages),
              loadMore: false,
            ),
          );
        },
      ).catchError(
        (e) {
          if (!isClosed) emit(ChatMessagesFetchFailure(e.toString()));
        },
      );
    }
  }

  void messageSent(ChatMessage message) {
    if (state is ChatMessagesFetchSuccess) {
      final response = (state as ChatMessagesFetchSuccess).response;
      final messages = response.messages..insert(0, message);

      emit(ChatMessagesFetchSuccess(response.copyWith(messages: messages)));
    }
  }

  void deleteMessages(List<int> messagesIds) {
    if (state is ChatMessagesFetchSuccess) {
      final response = (state as ChatMessagesFetchSuccess).response;
      final messages = response.messages
        ..removeWhere((e) => messagesIds.contains(e.id));

      emit(ChatMessagesFetchSuccess(response.copyWith(messages: messages)));
    }
  }

  void messageReceived({
    required String from,
    required ChatMessage message,
  }) {
    if (state is ChatMessagesFetchSuccess) {
      final response = (state as ChatMessagesFetchSuccess).response;

      if (!response.messages.contains(message)) {
        final messages = response.messages..insert(0, message);

        emit(ChatMessagesFetchSuccess(response.copyWith(messages: messages)));
      }
    }
  }

  void readMessages(List<ChatMessage> messages) {
    if (state is ChatMessagesFetchSuccess) {
      final response = (state as ChatMessagesFetchSuccess).response;

      final updatedMessages = response.messages
          .map(
            (e) => messages.contains(e)
                ? e = e.copyWith(readAt: DateTime.now())
                : e,
          )
          .toList();

      emit(ChatMessagesFetchSuccess(
        response.copyWith(messages: updatedMessages),
      ));
    }
  }
}
