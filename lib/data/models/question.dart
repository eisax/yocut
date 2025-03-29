import 'package:yocut/data/models/answerOption.dart';

class Question {
  final int? id;
  final String? question;
  final List<AnswerOption>? options;
  final int? marks;
  final String? image;
  final String? note;

  int totalCorrectAnswer() {
    
    return (options ?? [])
        .where((oprion) => oprion.isAnswer == 1)
        .toList()
        .length;
  }

  Question({
    this.id,
    this.question,
    this.options,
    this.marks,
    this.image,
    this.note,
  });

  Question copyWith({
    int? id,
    String? question,
    List<AnswerOption>? options,
    int? marks,
    String? image,
    String? note,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      marks: marks ?? this.marks,
      image: image ?? this.image,
      note: note ?? this.note,
    );
  }

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        question = json['question'] as String?,
        options = (json['options'] as List?)
            ?.map(
                (dynamic e) => AnswerOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        marks = json['marks'] as int?,
        image = json['image'] as String?,
        note = json['note'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options?.map((e) => e.toJson()).toList(),
        'marks': marks,
        'image': image,
        'note': note
      };
}
