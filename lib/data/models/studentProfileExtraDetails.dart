class StudentProfileExtraDetails {
  final int? id;
  final int? studentId;
  final int? formFieldId;
  final String? data;
  final int? schoolId;
  final FormField? formField;

  StudentProfileExtraDetails({
    this.id,
    this.studentId,
    this.formFieldId,
    this.data,
    this.schoolId,
    this.formField,
  });

  StudentProfileExtraDetails copyWith(
      {int? id,
      int? studentId,
      int? formFieldId,
      String? data,
      int? schoolId,
      FormField? formField}) {
    return StudentProfileExtraDetails(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        formFieldId: formFieldId ?? this.formFieldId,
        data: data ?? this.data,
        schoolId: schoolId ?? this.schoolId,
        formField: formField ?? this.formField);
  }

  StudentProfileExtraDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        studentId = json['student_id'] as int?,
        formFieldId = json['form_field_id'] as int?,
        data = json['data'] as String?,
        formField = FormField.fromJson(Map.from(json['form_field'] ?? {})),
        schoolId = json['school_id'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'form_field_id': formFieldId,
        'data': data,
        'school_id': schoolId,
        'form_field': formField?.toJson()
      };
}

//
class FormField {
  final int? id;
  final String? name;

  FormField({
    this.id,
    this.name,
  });

  FormField copyWith({
    int? id,
    String? name,
  }) {
    return FormField(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  FormField.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
