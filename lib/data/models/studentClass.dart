class StudentClass {
  late final int? id;
  late final String? name;
  late final int? mediumId;
  late final Medium medium;

  StudentClass({this.id, this.name, this.mediumId, required this.medium});
  StudentClass.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    mediumId = json["medium_id"];
    medium = Medium.fromJson(json['medium'] ?? {});
  }
}

class Medium {
  late final int? id;
  late final String? name;

  Medium({this.id, this.name});
  Medium.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
