class ClassRoomModel {
  String classroom_id;
  String classis_id;
  String aca_year_id;
  String teacher_id;
  String link;
  String password;
  String type;
  String meeting_time;
  String meeting_duration;
  String meeting_date;
  String batch_id;
  String description;
  String batches;

  ClassRoomModel(
      {this.classroom_id,
      this.classis_id,
      this.aca_year_id,
      this.teacher_id,
      this.link,
      this.password,
      this.type,
      this.meeting_time,
      this.meeting_duration,
      this.meeting_date,
      this.batch_id,
      this.description,
      this.batches});

  factory ClassRoomModel.fromJson(Map<String, dynamic> json) {
    return ClassRoomModel(
      classroom_id: json['classroom_id'] as String,
      classis_id: json['classis_id'] as String,
      aca_year_id: json['aca_year_id'] as String,
      teacher_id: json['teacher_id'] as String,
      link: json['link'] as String,
      password: json['password'] as String,
      type: json['type'] as String,
      meeting_time: json['meeting_time'] as String,
      meeting_duration: json['meeting_duration'] as String,
      meeting_date: json['meeting_date'] as String,
      batch_id: json['batch_id'] as String,
      description: json['description'] as String,
      batches: json['batches'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroom_id': classroom_id,
      'classis_id': classis_id,
      'aca_year_id': aca_year_id,
      'teacher_id': teacher_id,
      'link': link,
      'password': password,
      'type': type,
      'meeting_time': meeting_time,
      'meeting_duration': meeting_duration,
      'meeting_date': meeting_date,
      'batch_id': batch_id,
      'description': description,
      'batches': batches,
    };
  }
}
