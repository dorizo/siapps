class StudentModel {
  String parent_id;
  String student_id;
  String stud_gr_no;
  String stud_first_name;
  String stud_last_name;
  String stud_middle_name;
  String stud_photo;
  String stud_address;
  String stud_address_permenant;
  String stud_contact;
  String stud_parent_contact;
  String stud_nationality;
  String stud_cast;
  String stud_bdate;
  String stud_id_card_no;
  String stud_join_date;
  String stud_leave_date;
  String stud_is_leave;
  String stud_leave_description;
  String stud_vehicle_no;
  String stud_extra;
  String stud_gender;
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

  StudentModel({
    this.parent_id,
    this.student_id,
    this.stud_gr_no,
    this.stud_first_name,
    this.stud_last_name,
    this.stud_middle_name,
    this.stud_photo,
    this.stud_address,
    this.stud_address_permenant,
    this.stud_contact,
    this.stud_parent_contact,
    this.stud_nationality,
    this.stud_cast,
    this.stud_bdate,
    this.stud_id_card_no,
    this.stud_join_date,
    this.stud_leave_date,
    this.stud_is_leave,
    this.stud_leave_description,
    this.stud_vehicle_no,
    this.stud_extra,
    this.stud_gender,
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
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      parent_id: json['parent_id'] as String,
      student_id: json['student_id'] as String,
      stud_gr_no: json['stud_gr_no'] as String,
      stud_first_name: json['stud_first_name'] as String,
      stud_last_name: json['stud_last_name'] as String,
      stud_middle_name: json['stud_middle_name'] as String,
      stud_photo: json['stud_photo'] as String,
      stud_address: json['stud_address'] as String,
      stud_address_permenant: json['stud_address_permenant'] as String,
      stud_contact: json['stud_contact'] as String,
      stud_parent_contact: json['stud_parent_contact'] as String,
      stud_nationality: json['stud_nationality'] as String,
      stud_cast: json['stud_cast'] as String,
      stud_bdate: json['stud_bdate'] as String,
      stud_id_card_no: json['stud_id_card_no'] as String,
      stud_join_date: json['stud_join_date'] as String,
      stud_leave_date: json['stud_leave_date'] as String,
      stud_is_leave: json['stud_is_leave'] as String,
      stud_leave_description: json['stud_leave_description'] as String,
      stud_vehicle_no: json['stud_vehicle_no'] as String,
      stud_extra: json['stud_extra'] as String,
      stud_gender: json['stud_gender'] as String,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parent_id': parent_id,
      'student_id': student_id,
      'stud_gr_no': stud_gr_no,
      'stud_first_name': stud_first_name,
      'stud_last_name': stud_last_name,
      'stud_middle_name': stud_middle_name,
      'stud_photo': stud_photo,
      'stud_address': stud_address,
      'stud_address_permenant': stud_address_permenant,
      'stud_contact': stud_contact,
      'stud_parent_contact': stud_parent_contact,
      'stud_nationality': stud_nationality,
      'stud_cast': stud_cast,
      'stud_bdate': stud_bdate,
      'stud_id_card_no': stud_id_card_no,
      'stud_join_date': stud_join_date,
      'stud_leave_date': stud_leave_date,
      'stud_is_leave': stud_is_leave,
      'stud_leave_description': stud_leave_description,
      'stud_vehicle_no': stud_vehicle_no,
      'stud_extra': stud_extra,
      'stud_gender': stud_gender,
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
    };
  }
}
