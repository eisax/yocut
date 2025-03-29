import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/data/models/userChatHistory.dart';
import 'package:yocut/data/repositories/chatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserChatHistoryState {}

class UserChatHistoryInitial extends UserChatHistoryState {}

class UserChatHistoryFetchInProgress extends UserChatHistoryState {}

class UserChatHistoryFetchSuccess extends UserChatHistoryState {
  final UserChatHistory userChatHistory;
  final bool loadMore;

  UserChatHistoryFetchSuccess({
    required this.userChatHistory,
    this.loadMore = false,
  });
}

class UserChatHistoryFetchFailure extends UserChatHistoryState {
  final String errorMessage;

  UserChatHistoryFetchFailure(this.errorMessage);
}

class UserChatHistoryCubit extends Cubit<UserChatHistoryState> {
  UserChatHistoryCubit() : super(UserChatHistoryInitial());

  final ChatRepository _chatRepository = ChatRepository();

  void fetchUserChatHistory({required ChatUserRole role, int page = 1}) async {
    emit(UserChatHistoryFetchInProgress());

    await _chatRepository
        .getUserChatHistory(role: role, page: page)
        .then(
          (userChatHistory) => emit(
            UserChatHistoryFetchSuccess(userChatHistory: userChatHistory),
          ),
        )
        .catchError(
          (Object e) => emit(UserChatHistoryFetchFailure(e.toString())),
        );
  }

  bool get hasMore {
    if (state is UserChatHistoryFetchSuccess) {
      final history = (state as UserChatHistoryFetchSuccess).userChatHistory;

      return history.currentPage < history.lastPage;
    } else {
      return false;
    }
  }

  void fetchMoreUserChatHistory({required ChatUserRole role}) async {
    if (state is UserChatHistoryFetchSuccess &&
        !(state as UserChatHistoryFetchSuccess).loadMore) {
      final oldHistory = (state as UserChatHistoryFetchSuccess).userChatHistory;

      emit(UserChatHistoryFetchSuccess(
        userChatHistory: oldHistory,
        loadMore: true,
      ));

      await _chatRepository
          .getUserChatHistory(
        role: role,
        page: oldHistory.currentPage + 1,
      )
          .then(
        (userChatHistory) {
          final newContacts = oldHistory.chatContacts
            ..addAll(userChatHistory.chatContacts);

          emit(
            UserChatHistoryFetchSuccess(
              userChatHistory:
                  userChatHistory.copyWith(chatContacts: newContacts),
              loadMore: false,
            ),
          );
        },
      ).catchError(
        (Object e) {
          emit(UserChatHistoryFetchFailure(e.toString()));
        },
      );
    }
  }

  void messageReceived({
    required String from,
    required String message,
    required String updatedAt,
    required bool incrementUnreadCount,
  }) async {
    if (state is UserChatHistoryFetchSuccess) {
      final history = (state as UserChatHistoryFetchSuccess).userChatHistory;

      final chatContact = history.chatContacts
          .where((e) => e.user.id.toString() == from)
          .firstOrNull;

      /// message received from chat contact that is not in history
      if (chatContact == null) return;

      final updatedContact = chatContact.copyWith(
        lastMessage: message,
        updatedAt: updatedAt,
        unreadCount: incrementUnreadCount ? chatContact.unreadCount + 1 : null,
      );

      final newContacts = history.chatContacts
          .map((e) => e.receiverId.toString() == from ? e = updatedContact : e)
          .toList();

      emit(
        UserChatHistoryFetchSuccess(
          userChatHistory: history.copyWith(chatContacts: newContacts),
        ),
      );
    }
  }

  void updateUnreadCount(int receiverId, int count) {
    if (state is UserChatHistoryFetchSuccess) {
      final history = (state as UserChatHistoryFetchSuccess).userChatHistory;

      final chatContact = history.chatContacts
          .where((e) => e.user.id == receiverId)
          .firstOrNull;

      /// message received from a chat contact that is not in the history
      if (chatContact == null) return;

      final updatedContact = chatContact.copyWith(
        unreadCount: (chatContact.unreadCount - count < 0
            ? 0
            : chatContact.unreadCount - count),
      );

      final newContacts = history.chatContacts
          .map((e) => e.user.id == receiverId ? e = updatedContact : e)
          .toList();

      emit(
        UserChatHistoryFetchSuccess(
          userChatHistory: history.copyWith(chatContacts: newContacts),
        ),
      );
    }
  }

  void updateLastMessage(
    int receiverId,
    String lastMessage,
    DateTime lastMessageTime,
  ) {
    if (state is UserChatHistoryFetchSuccess) {
      final history = (state as UserChatHistoryFetchSuccess).userChatHistory;

      final chatContact = history.chatContacts
          .where((e) => e.user.id == receiverId)
          .firstOrNull;

      /// message received from a chat contact that is not in the history
      if (chatContact == null) return;

      if (lastMessageTime.isAfter(DateTime.parse(chatContact.updatedAt))) {
        final updatedContact = chatContact.copyWith(
          lastMessage: lastMessage,
          updatedAt: lastMessageTime.toIso8601String(),
        );

        final newContacts = history.chatContacts
            .map((e) => e.user.id == receiverId ? e = updatedContact : e)
            .toList();

        emit(
          UserChatHistoryFetchSuccess(
            userChatHistory: history.copyWith(chatContacts: newContacts),
          ),
        );
      }
    }
  }
}
