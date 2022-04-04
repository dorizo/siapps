class ParentModel {
  String parent_id;
  String classis_id;
  String parent_fullname;
  String parent_occupation;
  String parent_phone;
  String parent_email;
  String parent_annual_income;
  String parent_office_address;
  String is_gov_employee;
  String parent_type;
  String parent_gender;
  String parent_photo;
  String otp;
  String status;
  String student_id;

  ParentModel(
      {this.parent_id,
      this.classis_id,
      this.parent_fullname,
      this.parent_occupation,
      this.parent_phone,
      this.parent_email,
      this.parent_annual_income,
      this.parent_office_address,
      this.is_gov_employee,
      this.parent_type,
      this.parent_gender,
      this.parent_photo,
      this.otp,
      this.status,
      this.student_id});

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      parent_id: json['parent_id'] as String,
      classis_id: json['classis_id'] as String,
      parent_fullname: json['parent_fullname'] as String,
      parent_occupation: json['parent_occupation'] as String,
      parent_phone: json['parent_phone'] as String,
      parent_email: json['parent_email'] as String,
      parent_annual_income: json['parent_annual_income'] as String,
      parent_office_address: json['parent_office_address'] as String,
      is_gov_employee: json['is_gov_employee'] as String,
      parent_type: json['parent_type'] as String,
      parent_gender: json['parent_gender'] as String,
      parent_photo: json['parent_photo'] as String,
      otp: json['otp'] as String,
      status: json['status'] as String,
      student_id: json['student_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parent_id': parent_id,
      'classis_id': classis_id,
      'parent_fullname': parent_fullname,
      'parent_occupation': parent_occupation,
      'parent_phone': parent_phone,
      'parent_email': parent_email,
      'parent_annual_income': parent_annual_income,
      'parent_office_address': parent_office_address,
      'is_gov_employee': is_gov_employee,
      'parent_type': parent_type,
      'parent_gender': parent_gender,
      'parent_photo': parent_photo,
      'otp': otp,
      'status': status,
      'student_id': student_id,
    };
  }
}
