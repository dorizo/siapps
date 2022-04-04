class ClassesModel {
  String classis_id;
  String classis_name;
  String classis_logo;
  String classis_phone_no;
  String classis_address;
  String classis_lat;
  String classis_lon;
  String classis_board;
  String classis_reg_no;
  String classis_website;
  String classis_details;
  String classis_email;
  String user_id;
  String user_type_id;
  String user_name;
  String user_email;
  String user_password;
  String status;

  ClassesModel(
      {this.classis_id,
      this.classis_name,
      this.classis_logo,
      this.classis_phone_no,
      this.classis_address,
      this.classis_lat,
      this.classis_lon,
      this.classis_board,
      this.classis_reg_no,
      this.classis_website,
      this.classis_details,
      this.classis_email,
      this.user_id,
      this.user_type_id,
      this.user_name,
      this.user_email,
      this.user_password,
      this.status});

  factory ClassesModel.fromJson(Map<String, dynamic> json) {
    return ClassesModel(
      classis_id: json['classis_id'] as String,
      classis_name: json['classis_name'] as String,
      classis_logo: json['classis_logo'] as String,
      classis_phone_no: json['classis_phone_no'] as String,
      classis_address: json['classis_address'] as String,
      classis_lat: json['classis_lat'] as String,
      classis_lon: json['classis_lon'] as String,
      classis_board: json['classis_board'] as String,
      classis_reg_no: json['classis_reg_no'] as String,
      classis_website: json['classis_website'] as String,
      classis_details: json['classis_details'] as String,
      classis_email: json['classis_email'] as String,
      user_id: json['user_id'] as String,
      user_type_id: json['user_type_id'] as String,
      user_name: json['user_name'] as String,
      user_email: json['user_email'] as String,
      user_password: json['user_password'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classis_id': classis_id,
      'classis_name': classis_name,
      'classis_logo': classis_logo,
      'classis_phone_no': classis_phone_no,
      'classis_address': classis_address,
      'classis_lat': classis_lat,
      'classis_lon': classis_lon,
      'classis_board': classis_board,
      'classis_reg_no': classis_reg_no,
      'classis_website': classis_website,
      'classis_details': classis_details,
      'classis_email': classis_email,
      'user_id': user_id,
      'user_type_id': user_type_id,
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password,
      'status': status,
    };
  }
}
