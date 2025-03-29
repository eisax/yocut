class AnswerOption {
  final int? id;
  final String? option;
  final int? isAnswer;

  AnswerOption({
    this.id,
    this.option,
    this.isAnswer,
  });

  AnswerOption copyWith({
    int? id,
    String? option,
    int? isAnswer,
  }) {
    return AnswerOption(
      id: id ?? this.id,
      option: option ?? this.option,
      isAnswer: isAnswer ?? this.isAnswer,
    );
  }

  bool isOptionCorrectAnswer() {
    return isAnswer == 1;
  }

  AnswerOption.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        option = json['option'] as String?,
        isAnswer = json['is_answer'] as int?;

  Map<String, dynamic> toJson() =>
      {'id': id, 'option': option, 'is_answer': isAnswer};
}
