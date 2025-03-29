class Holiday {
  Holiday({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final DateTime date;
  late final String title;
  late final String description;
  late final String createdAt;
  late final String updatedAt;

  Holiday.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    date = json['date'] == null
        ? DateTime.now()
        : DateTime.parse(json['date'].toString());
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }
}
