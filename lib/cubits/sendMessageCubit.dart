import 'package:yocut/data/models/chatMessage.dart';
import 'package:yocut/data/repositories/chatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

enum SendMessageStatus { initial, sending, success, failure }

class SendMessageState {
  final SendMessageStatus status;
  final String? errorMessage;
  final ChatMessage? message;

  const SendMessageState({
    this.status = SendMessageStatus.initial,
    this.errorMessage,
    this.message,
  });

  SendMessageState copyWith({
    SendMessageStatus? status,
    String? errorMessage,
    ChatMessage? message,
  }) {
    return SendMessageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageState());

  final ChatRepository _chatRepository = ChatRepository();

  void sendMessage({
    required int receiverId,
    required String message,
    List<XFile>? files,
  }) async {
    emit(state.copyWith(status: SendMessageStatus.sending));
    await _chatRepository
        .sendMessage(
          receiverId: receiverId,
          message: message,
          files: files,
        )
        .then(
          (message) => emit(state.copyWith(
            status: SendMessageStatus.success,
            message: message,
          )),
        )
        .catchError(
          (e) => emit(state.copyWith(
            status: SendMessageStatus.failure,
            errorMessage: e.toString(),
          )),
        );
  }
}
