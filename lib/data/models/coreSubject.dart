import 'package:yocut/data/models/subject.dart';

class CoreSubject extends Subject {
  late final int classId;

  CoreSubject.fromJson({required Map<String, dynamic> json})
      : super.fromJson(Map.from(json)) {
    classId = json['pivot']['class_id'] ?? 0;
  }
}
