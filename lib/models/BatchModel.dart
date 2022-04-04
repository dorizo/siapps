class BatchModel {
  String batch_id;
  String classis_id;
  String teacher_id;
  String batch_name;
  String subject_name;
  String subject_id;
  String start_time;
  String end_time;
  String days;
  String aca_year;
  String teacher_fullname;
  String attend_status;

  BatchModel(
      {this.batch_id,
      this.classis_id,
      this.teacher_id,
      this.batch_name,
      this.subject_name,
      this.subject_id,
      this.start_time,
      this.end_time,
      this.days,
      this.aca_year,
      this.teacher_fullname,
      this.attend_status});

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      batch_id: json['batch_id'] as String,
      classis_id: json['classis_id'] as String,
      teacher_id: json['teacher_id'] as String,
      batch_name: json['batch_name'] as String,
      subject_name: json['subject_name'] as String,
      subject_id: json['subject_id'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
      days: json['days'] as String,
      aca_year: json['aca_year'] as String,
      teacher_fullname: json['teacher_fullname'] as String,
      attend_status: json['attend_status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batch_id': batch_id,
      'classis_id': classis_id,
      'teacher_id': teacher_id,
      'batch_name': batch_name,
      'subject_name': subject_name,
      'subject_id': subject_id,
      'start_time': start_time,
      'end_time': end_time,
      'days': days,
      'aca_year': aca_year,
      'teacher_fullname': teacher_fullname,
      'attend_status': attend_status,
    };
  }
}
