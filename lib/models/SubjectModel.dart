class SubjectModel {
  String subject_id;
  String subject_name;

  SubjectModel({
    this.subject_name,
    this.subject_id,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subject_name: json['subject_name'] as String,
      subject_id: json['subject_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_name': subject_name,
      'subject_id': subject_id,
    };
  }
}
