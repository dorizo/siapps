class AttendanceModel {
  String attend_id;
  String student_id;
  String classis_id;
  String batch_id;
  String date;
  String attended;
  String attend_time;
  String teacher_id;
  String leave_note;
  String is_pre_leave;
  String created_at;
  String modified_at;
  String draft;
  String batch_name;
  String stud_first_name;
  String stud_last_name;
  String stud_middle_name;

  AttendanceModel({
    this.attend_id,
    this.student_id,
    this.classis_id,
    this.batch_id,
    this.date,
    this.attended,
    this.attend_time,
    this.teacher_id,
    this.leave_note,
    this.is_pre_leave,
    this.created_at,
    this.modified_at,
    this.draft,
    this.batch_name,
    this.stud_first_name,
    this.stud_last_name,
    this.stud_middle_name,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attend_id: json['attend_id'] as String,
      student_id: json['student_id'] as String,
      classis_id: json['classis_id'] as String,
      batch_id: json['batch_id'] as String,
      date: json['date'] as String,
      attended: json['attended'] as String,
      attend_time: json['attend_time'] as String,
      teacher_id: json['teacher_id'] as String,
      leave_note: json['leave_note'] as String,
      is_pre_leave: json['is_pre_leave'] as String,
      created_at: json['created_at'] as String,
      modified_at: json['modified_at'] as String,
      draft: json['draft'] as String,
      batch_name: json['batch_name'] as String,
      stud_first_name: json['stud_first_name'] as String,
      stud_last_name: json['stud_last_name'] as String,
      stud_middle_name: json['stud_middle_name'] as String,
    );
  }
}
