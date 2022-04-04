class AssignmentModel {
  String assign_id;
  String batch_id;
  String classis_id;
  String assign_title;
  String assign_description;
  String assign_end_of_submission_date;
  String teacher_id;
  String created_at;
  String modified_at;
  String draft;
  String attachment_id;
  String type;
  String type_id;
  String file;
  String file_type;
  String file_size;
  String subject_id;
  String batch_name;
  String start_time;
  String end_time;
  String aca_year_id;
  String days;
  String submission_id;
  String student_id;
  String submitted_date;
  String grade;
  String note;
  String assignment_file;
  String assignment_file_type;
  String assignment_file_size;
  String assignment_stud_file;
  String assignment_stud_file_type;
  String assignment_stud_file_size;

  AssignmentModel({
    this.assign_id,
    this.batch_id,
    this.classis_id,
    this.assign_title,
    this.assign_description,
    this.assign_end_of_submission_date,
    this.teacher_id,
    this.created_at,
    this.modified_at,
    this.draft,
    this.attachment_id,
    this.type,
    this.type_id,
    this.file,
    this.file_type,
    this.file_size,
    this.subject_id,
    this.batch_name,
    this.start_time,
    this.end_time,
    this.aca_year_id,
    this.days,
    this.submission_id,
    this.student_id,
    this.submitted_date,
    this.grade,
    this.note,
    this.assignment_file,
    this.assignment_file_type,
    this.assignment_file_size,
    this.assignment_stud_file,
    this.assignment_stud_file_type,
    this.assignment_stud_file_size,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      assign_id: json['assign_id'] as String,
      batch_id: json['batch_id'] as String,
      classis_id: json['classis_id'] as String,
      assign_title: json['assign_title'] as String,
      assign_description: json['assign_description'] as String,
      assign_end_of_submission_date:
          json['assign_end_of_submission_date'] as String,
      teacher_id: json['teacher_id'] as String,
      created_at: json['created_at'] as String,
      modified_at: json['modified_at'] as String,
      draft: json['draft'] as String,
      attachment_id: json['attachment_id'] as String,
      type: json['type'] as String,
      type_id: json['type_id'] as String,
      file: json['file'] as String,
      file_type: json['file_type'] as String,
      file_size: json['file_size'] as String,
      subject_id: json['subject_id'] as String,
      batch_name: json['batch_name'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
      aca_year_id: json['aca_year_id'] as String,
      days: json['days'] as String,
      submission_id: json['submission_id'] as String,
      student_id: json['student_id'] as String,
      submitted_date: json['submitted_date'] as String,
      grade: json['grade'] as String,
      note: json['note'] as String,
      assignment_file: json['assignment_file'] as String,
      assignment_file_type: json['assignment_file_type'] as String,
      assignment_file_size: json['assignment_file_size'] as String,
      assignment_stud_file: json['assignment_stud_file'] as String,
      assignment_stud_file_type: json['assignment_stud_file_type'] as String,
      assignment_stud_file_size: json['assignment_stud_file_size'] as String,
    );
  }
}
