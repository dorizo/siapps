class ExamQuestionOptionModel {
  String opt_id;
  String classis_id;
  String exam_id;
  String que_id;
  String opt_description;
  String opt_is_correct;

  ExamQuestionOptionModel(
      {this.opt_id,
      this.classis_id,
      this.exam_id,
      this.que_id,
      this.opt_description,
      this.opt_is_correct});

  factory ExamQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return ExamQuestionOptionModel(
      opt_id: json['opt_id'] as String,
      classis_id: json['classis_id'] as String,
      exam_id: json['exam_id'] as String,
      que_id: json['que_id'] as String,
      opt_description: json['opt_description'] as String,
      opt_is_correct: json['opt_is_correct'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opt_id': opt_id,
      'classis_id': classis_id,
      'exam_id': exam_id,
      'que_id': que_id,
      'opt_description': opt_description,
      'opt_is_correct': opt_is_correct,
    };
  }
}
