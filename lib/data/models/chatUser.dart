import 'package:yocut/data/models/chatUserRole.dart';
import 'package:yocut/data/models/classSection.dart';
import 'package:yocut/data/models/subjectTeacher.dart';

class ChatUser {
  const ChatUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.fullName,
    required this.schoolNames,
    required this.role,
    required this.classTeachers,
    required this.subjectTeachers,
  });

  ChatUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstName = json['first_name'] as String,
        lastName = json['last_name'] as String,
        image = json['image'] as String,
        fullName = json['full_name'] as String,
        schoolNames = json['school_names'] as String,
        role = ChatUserRole.fromString(json['role'] as String),
        classTeachers = (json['class_teacher'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(ClassTeacher.fromJson)
            .toList(),
        subjectTeachers = (json['subject_teachers'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(SubjectTeacher.fromJson)
            .toList();

  final int id;
  final String firstName;
  final String lastName;
  final String image;
  final String fullName;
  final String schoolNames;
  final ChatUserRole role;
  final List<ClassTeacher> classTeachers;
  final List<SubjectTeacher> subjectTeachers;

  @override
  String toString() {
    return 'ChatUser(id: $id, firstName: $firstName, lastName: $lastName, image: $image, fullName: $fullName, schoolNames: $schoolNames, role: $role)';
  }
}

class ClassTeacher {
  const ClassTeacher({
    required this.id,
    required this.classSectionId,
    required this.teacherId,
    required this.schoolId,
    required this.classId,
    required this.classSection,
  });

  final int id;
  final int classSectionId;
  final int teacherId;
  final int schoolId;
  final int classId;
  final ClassSection classSection;

  ClassTeacher.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        classSectionId = json['class_section_id'] as int,
        teacherId = json['teacher_id'] as int,
        schoolId = json['school_id'] as int,
        classId = json['class_id'] as int,
        classSection = ClassSection.fromJson(
            json['class_section'] as Map<String, dynamic>);
}
