class StudentAttendanceTotalModel {
  String student_id;
  String stud_first_name;
  String stud_last_name;
  String stud_middle_name;
  String total_attended;
  String total_absent;
  String total_leave;

  StudentAttendanceTotalModel({
    this.student_id,
    this.stud_first_name,
    this.stud_last_name,
    this.stud_middle_name,
    this.total_attended,
    this.total_absent,
    this.total_leave,
  });

  factory StudentAttendanceTotalModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceTotalModel(
      student_id: json['student_id'] as String,
      stud_first_name: json['stud_first_name'] as String,
      stud_last_name: json['stud_last_name'] as String,
      stud_middle_name: json['stud_middle_name'] as String,
      total_attended: json['total_attended'] as String,
      total_absent: json['total_absent'] as String,
      total_leave: json['total_leave'] as String,
    );
  }
}
