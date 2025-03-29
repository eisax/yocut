import 'package:yocut/data/models/chatUser.dart';

class ChatContact {
  const ChatContact({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
    required this.lastMessage,
    required this.user,
  });

  ChatContact.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        senderId = json['sender_id'] as int,
        receiverId = json['receiver_id'] as int,
        createdAt = json['created_at'] as String,
        updatedAt = json['updated_at'] as String,
        unreadCount = json['unread_count'] as int,
        lastMessage = json['last_message'] as String?,
        user = ChatUser.fromJson(json['user']);

  final int id;
  final int senderId;
  final int receiverId;
  final String createdAt;
  final String updatedAt;
  final int unreadCount;
  final String? lastMessage;
  final ChatUser user;

  ChatContact copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? createdAt,
    String? updatedAt,
    int? unreadCount,
    String? lastMessage,
    ChatUser? user,
  }) {
    return ChatContact(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      user: user ?? this.user,
    );
  }
}
