import 'package:yocut/data/models/chatUser.dart';

class ChatUsersResponse {
  final int currentPage;
  final List<ChatUser> chatUsers;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<Map<String, dynamic>> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const ChatUsersResponse({
    required this.currentPage,
    required this.chatUsers,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  ChatUsersResponse.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] as int,
        chatUsers = (json['data'] as List)
            .cast<Map<String, dynamic>>()
            .map(ChatUser.fromJson)
            .toList(),
        firstPageUrl = json['first_page_url'] as String,
        from = json['from'] as int?,
        lastPage = json['last_page'] as int,
        lastPageUrl = json['last_page_url'] as String,
        links = (json['links'] as List).cast<Map<String, dynamic>>(),
        nextPageUrl = json['next_page_url'] as String?,
        path = json['path'] as String,
        perPage = json['per_page'] as int,
        prevPageUrl = json['prev_page_url'] as String?,
        to = json['to'] as int?,
        total = json['total'] as int;

  ChatUsersResponse copyWith({
    int? currentPage,
    List<ChatUser>? chatUsers,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Map<String, dynamic>>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return ChatUsersResponse(
      currentPage: currentPage ?? this.currentPage,
      chatUsers: chatUsers ?? this.chatUsers,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }
}
