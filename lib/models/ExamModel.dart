import 'package:classes_app/models/ExamQuestionModel.dart';

class ExamModel {
  String exam_id;
  String classis_id;
  String aca_year_id;
  String batch_ids;
  String exam_title;
  String exam_description;
  String exam_total_marks;
  String exam_passing_marks;
  String exam_correct_ans_marks;
  String exam_incorrect_ans_marks;
  String exam_date;
  String exam_total_time;
  String exam_start_time;
  String exam_type;
  String exam_on_schedule;
  String exam_schedule_min;
  String batches_name;
  String attempt_id;
  String total_subjects;
  String total_obtain_marks;
  String total_marks;
  String final_marks;
  String total_correct;
  String total_wrong;
  String total_skip;
  String total_questions;
  List<ExamQuestionModel> questions;

  ExamModel({
    this.exam_id,
    this.classis_id,
    this.aca_year_id,
    this.batch_ids,
    this.exam_title,
    this.exam_description,
    this.exam_total_marks,
    this.exam_passing_marks,
    this.exam_correct_ans_marks,
    this.exam_incorrect_ans_marks,
    this.exam_date,
    this.exam_total_time,
    this.exam_start_time,
    this.exam_type,
    this.exam_on_schedule,
    this.exam_schedule_min,
    this.batches_name,
    this.attempt_id,
    this.total_subjects,
    this.total_obtain_marks,
    this.total_marks,
    this.questions,
    this.final_marks,
    this.total_correct,
    this.total_wrong,
    this.total_skip,
    this.total_questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      exam_id: json['exam_id'] as String,
      classis_id: json['classis_id'] as String,
      aca_year_id: json['aca_year_id'] as String,
      batch_ids: json['batch_ids'] as String,
      exam_title: json['exam_title'] as String,
      exam_description: json['exam_description'] as String,
      exam_total_marks: json['exam_total_marks'] as String,
      exam_passing_marks: json['exam_passing_marks'] as String,
      exam_correct_ans_marks: json['exam_correct_ans_marks'] as String,
      exam_incorrect_ans_marks: json['exam_incorrect_ans_marks'] as String,
      exam_date: json['exam_date'] as String,
      exam_total_time: json['exam_total_time'] as String,
      exam_start_time: json['exam_start_time'] as String,
      exam_type: json['exam_type'] as String,
      exam_on_schedule: json['exam_on_schedule'] as String,
      exam_schedule_min: json['exam_schedule_min'] as String,
      batches_name: json['batches_name'] as String,
      attempt_id: json['attempt_id'] as String,
      total_subjects: (json.containsKey("total_subjects"))
          ? json['total_subjects'] as String
          : null,
      total_obtain_marks: (json.containsKey("total_obtain_marks"))
          ? json['total_obtain_marks'] as String
          : null,
      total_marks: (json.containsKey("total_marks"))
          ? json['total_marks'] as String
          : null,
      final_marks: (json.containsKey("final_marks"))
          ? json['final_marks'] as String
          : null,
      total_correct: (json.containsKey("total_correct"))
          ? json['total_correct'] as String
          : null,
      total_wrong: (json.containsKey("total_wrong"))
          ? json['total_wrong'] as String
          : null,
      total_skip: (json.containsKey("total_skip"))
          ? json['total_skip'] as String
          : null,
      total_questions: (json.containsKey("total_questions"))
          ? json['total_questions'] as String
          : null,
      questions: (json.containsKey("questions"))
          ? (json['questions'] as List)
              .map((i) => ExamQuestionModel.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exam_id': exam_id,
      'classis_id': classis_id,
      'aca_year_id': aca_year_id,
      'batch_ids': batch_ids,
      'exam_title': exam_title,
      'exam_description': exam_description,
      'exam_total_marks': exam_total_marks,
      'exam_passing_marks': exam_passing_marks,
      'exam_correct_ans_marks': exam_correct_ans_marks,
      'exam_incorrect_ans_marks': exam_incorrect_ans_marks,
      'exam_date': exam_date,
      'exam_total_time': exam_total_time,
      'exam_start_time': exam_start_time,
      'exam_type': exam_type,
      'exam_on_schedule': exam_on_schedule,
      'exam_schedule_min': exam_schedule_min,
      'batches_name': batches_name,
      'attempt_id': attempt_id,
      'total_subjects': total_subjects,
      'total_obtain_marks': total_obtain_marks,
      'total_marks': total_marks,
      'final_marks': final_marks,
      'questions': questions,
      'total_correct': total_correct,
      'total_wrong': total_wrong,
      'total_skip': total_skip,
      'questions': questions,
    };
  }
}
