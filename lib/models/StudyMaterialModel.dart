class StudyMaterialModel {
  String material_id;
  String classis_id;
  String subject_id;
  String teacher_id;
  String title;
  String description;
  String type;
  String video_type;
  String video_url;
  String created_at;
  String modified_at;
  String draft;
  String attachment_id;
  String type_id;
  String file;
  String file_type;
  String file_size;
  String subject_name;
  String batches;

  StudyMaterialModel(
      {this.material_id,
      this.classis_id,
      this.subject_id,
      this.teacher_id,
      this.title,
      this.description,
      this.type,
      this.video_type,
      this.video_url,
      this.created_at,
      this.modified_at,
      this.draft,
      this.attachment_id,
      this.type_id,
      this.file,
      this.file_type,
      this.file_size,
      this.subject_name,
      this.batches});

  factory StudyMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialModel(
      material_id: json['material_id'] as String,
      classis_id: json['classis_id'] as String,
      subject_id: json['subject_id'] as String,
      teacher_id: json['teacher_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      video_type: json['video_type'] as String,
      video_url: json['video_url'] as String,
      created_at: json['created_at'] as String,
      modified_at: json['modified_at'] as String,
      draft: json['draft'] as String,
      attachment_id: json['attachment_id'] as String,
      type_id: json['type_id'] as String,
      file: json['file'] as String,
      file_type: json['file_type'] as String,
      file_size: json['file_size'] as String,
      subject_name: json['subject_name'] as String,
      batches: json['batches'] as String,
    );
  }
}
