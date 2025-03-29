import 'package:yocut/data/models/chatMessage.dart';

class ChatMessagesResponse {
  const ChatMessagesResponse({
    required this.messages,
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
  });

  final List<ChatMessage> messages;
  final int currentPage;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<Map<String, dynamic>> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;

  ChatMessagesResponse.fromJson(Map<String, dynamic> json)
      : messages = (json['data'] as List)
            .cast<Map<String, dynamic>>()
            .map(ChatMessage.fromJson)
            .toList(),
        currentPage = json['current_page'] as int,
        from = json['from'] as int?,
        lastPage = json['last_page'] as int,
        lastPageUrl = json['last_page_url'] as String?,
        links = (json['links'] as List).cast<Map<String, dynamic>>(),
        nextPageUrl = json['next_page_url'] as String?,
        path = json['path'] as String?,
        perPage = json['per_page'] as int,
        prevPageUrl = json['prev_page_url'] as String?;

  ChatMessagesResponse copyWith({
    List<ChatMessage>? messages,
    int? currentPage,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Map<String, dynamic>>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
  }) {
    return ChatMessagesResponse(
      messages: messages ?? this.messages,
      currentPage: currentPage ?? this.currentPage,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
    );
  }
}
