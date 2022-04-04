class TeacherModel {
  String teacher_id;
  String classis_id;
  String teacher_fullname;
  String teacher_gender;
  String teacher_qualification;
  String teacher_photo;
  String teacher_address;
  String teacher_phone;
  String teacher_email;
  String teacher_bdate;
  String teacher_id_card_no;
  String teacher_join_date;
  String teacher_is_leave;
  String teacher_leave_date;
  String teacher_leave_description;
  String created_at;
  String modified_at;
  String draft;
  String user_id;
  String user_type_id;
  String user_name;
  String user_email;
  String user_password;
  String fcm_code;
  String apn_token;
  String request_token;
  String onesignal_player_id;
  String status;

  TeacherModel({
    this.teacher_id,
    this.classis_id,
    this.teacher_fullname,
    this.teacher_gender,
    this.teacher_qualification,
    this.teacher_photo,
    this.teacher_address,
    this.teacher_phone,
    this.teacher_email,
    this.teacher_bdate,
    this.teacher_id_card_no,
    this.teacher_join_date,
    this.teacher_is_leave,
    this.teacher_leave_date,
    this.teacher_leave_description,
    this.created_at,
    this.modified_at,
    this.draft,
    this.user_id,
    this.user_type_id,
    this.user_name,
    this.user_email,
    this.user_password,
    this.fcm_code,
    this.apn_token,
    this.request_token,
    this.onesignal_player_id,
    this.status,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacher_id: json['teacher_id'] as String,
      classis_id: json['classis_id'] as String,
      teacher_fullname: json['teacher_fullname'] as String,
      teacher_gender: json['teacher_gender'] as String,
      teacher_qualification: json['teacher_qualification'] as String,
      teacher_photo: json['teacher_photo'] as String,
      teacher_address: json['teacher_address'] as String,
      teacher_phone: json['teacher_phone'] as String,
      teacher_email: json['teacher_email'] as String,
      teacher_bdate: json['teacher_bdate'] as String,
      teacher_id_card_no: json['teacher_id_card_no'] as String,
      teacher_join_date: json['teacher_join_date'] as String,
      teacher_is_leave: json['teacher_is_leave'] as String,
      teacher_leave_date: json['teacher_leave_date'] as String,
      teacher_leave_description: json['teacher_leave_description'] as String,
      created_at: json['created_at'] as String,
      modified_at: json['modified_at'] as String,
      draft: json['draft'] as String,
      user_id: json['user_id'] as String,
      user_type_id: json['user_type_id'] as String,
      user_name: json['user_name'] as String,
      user_email: json['user_email'] as String,
      user_password: json['user_password'] as String,
      fcm_code: json['fcm_code'] as String,
      apn_token: json['apn_token'] as String,
      request_token: json['request_token'] as String,
      onesignal_player_id: json['onesignal_player_id'] as String,
      status: json['status'] as String,
    );
  }
}
