import 'package:dio/dio.dart';
import 'package:yocut/data/models/chatMessage.dart';
import 'package:yocut/data/models/chatMessagesResponse.dart';
import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/data/models/chatUsersResponse.dart';
import 'package:yocut/data/models/userChatHistory.dart';
import 'package:yocut/utils/api.dart';
import 'package:image_picker/image_picker.dart';

class ChatRepository {
  Future<ChatUsersResponse> getUsers({
    required ChatUserRole role,
    required String? childId,
    required int page,
  }) async {
    // assert(
    //   role == ChatUserRole.guardian && classSectionId == null,
    //   "classSectionId is required for guardian role",
    // );

    final body = {
      "role": role.value,
      "page": page,
      "child_id": childId,
    };

    try {
      final result = await Api.get(
        url: Api.getUsers,
        queryParameters: body,
        useAuthToken: true,
      );

      return ChatUsersResponse.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<UserChatHistory> getUserChatHistory({
    required ChatUserRole role,
    required int page,
  }) async {
    try {
      final result = await Api.get(
        queryParameters: {"role": role.value, "page": page},
        url: Api.getUserChatHistory,
        useAuthToken: true,
      );

      return UserChatHistory.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<ChatMessagesResponse> getChatMessages({
    required int receiverId,
    required int page,
  }) async {
    try {
      final result = await Api.get(
        queryParameters: {"receiver_id": receiverId, "page": page},
        url: Api.chatMessages,
        useAuthToken: true,
      );

      return ChatMessagesResponse.fromJson(
        result['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<ChatMessage> sendMessage({
    required int receiverId,
    required String message,
    List<XFile>? files,
  }) async {
    try {
      var body = {
        "to": receiverId,
        "message": message,
        "files": <MultipartFile>[],
      };

      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          (body['files'] as List).add(
            MultipartFile.fromFileSync(
              file.path,
              filename: file.name,
            ),
          );
        }
      } else {
        body.remove("files");
      }

      final result = await Api.post(
        body: body,
        url: Api.chatMessages,
        useAuthToken: true,
      );

      return ChatMessage.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> readMessage({required List<int> messagesIds}) async {
    try {
      await Api.post(
        body: {
          "message_id": messagesIds,
        },
        url: Api.readMessages,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteMessage({required List<int> messagesIds}) async {
    try {
      await Api.post(
        body: {"id": messagesIds},
        url: Api.deleteMessages,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
