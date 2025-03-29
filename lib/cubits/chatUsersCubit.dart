import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/data/models/chatUsersResponse.dart';
import 'package:yocut/data/repositories/chatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChatUsersFetchStatus { initial, loading, success, failure }

class ChatUsersState {
  final ChatUsersFetchStatus status;
  final String? errorMessage;
  final ChatUsersResponse? chatUsersResponse;
  final bool loadMore;
  final bool hasUsers;

  ChatUsersState({
    this.status = ChatUsersFetchStatus.initial,
    this.errorMessage,
    this.chatUsersResponse,
    this.loadMore = false,
  }) : hasUsers =
            chatUsersResponse != null && chatUsersResponse.chatUsers.isNotEmpty;

  ChatUsersState copyWith({
    ChatUsersFetchStatus? status,
    String? errorMessage,
    ChatUsersResponse? chatUsersResponse,
    bool? loadMore,
  }) {
    return ChatUsersState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      chatUsersResponse: chatUsersResponse ?? this.chatUsersResponse,
      loadMore: loadMore ?? this.loadMore,
    );
  }
}

class ChatUsersCubit extends Cubit<ChatUsersState> {
  ChatUsersCubit() : super(ChatUsersState());

  ChatRepository _chatRepository = ChatRepository();

  void fetchChatUsers({
    required ChatUserRole role,
    required String? childId,
    int page = 1,
  }) async {
    emit(state.copyWith(status: ChatUsersFetchStatus.loading));

    _chatRepository
        .getUsers(
      role: role,
      childId: childId,
      page: page,
    )
        .then((chatUsersResponse) {
      emit(state.copyWith(
        status: ChatUsersFetchStatus.success,
        chatUsersResponse: chatUsersResponse,
      ));
    }).catchError((e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: ChatUsersFetchStatus.failure,
        errorMessage: e.toString(),
      ));
    });
  }

  bool get hasMore {
    if (state.status == ChatUsersFetchStatus.success) {
      return state.chatUsersResponse!.currentPage <
          state.chatUsersResponse!.lastPage;
    }
    return false;
  }

  Future<void> fetchMoreChatUsers({
    required ChatUserRole role,
    required String? studentId,
  }) async {
    if (state.status == ChatUsersFetchStatus.success && !state.loadMore) {
      emit(state.copyWith(loadMore: true));

      final old = state.chatUsersResponse!;

      await _chatRepository
          .getUsers(
        role: role,
        childId: studentId,
        page: old.currentPage + 1,
      )
          .then((chatUsersResponse) {
        final chatUsers = old.chatUsers..addAll(chatUsersResponse.chatUsers);

        emit(
          state.copyWith(
            status: ChatUsersFetchStatus.success,
            chatUsersResponse: chatUsersResponse.copyWith(chatUsers: chatUsers),
            loadMore: false,
          ),
        );
      }).catchError((e) {
        if (isClosed) return;
        emit(state.copyWith(
          status: ChatUsersFetchStatus.failure,
          errorMessage: e.toString(),
        ));
      });
    }
  }
}
