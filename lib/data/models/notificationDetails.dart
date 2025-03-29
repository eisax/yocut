class NotificationDetails {
  final String title;
  final String body;
  final DateTime createdAt;
  final String attachmentUrl;
  final int userId;

  NotificationDetails(
      {required this.attachmentUrl,
      required this.body,
      required this.userId,
      required this.createdAt,
      required this.title});

  static NotificationDetails fromJson(Map<String, dynamic> json) {
    return NotificationDetails(
        attachmentUrl: json['attachmentUrl'] ?? "",
        userId: json['userId'] ?? 0,
        body: json['body'] ?? "",
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.timestamp().toIso8601String()),
        title: json['title'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "attachmentUrl": attachmentUrl,
      "body": body,
      "userId": userId,
      "createdAt": createdAt.toIso8601String(),
      "title": title
    };
  }
}
