class AnnouncementModel {
  String id;
  String batch_id;
  String classis_id;
  String title;
  String message;
  String image;
  String recipients;
  String created_at;
  String modified_at;
  String draft;
  String batches;

  AnnouncementModel({
    this.id,
    this.batch_id,
    this.classis_id,
    this.title,
    this.message,
    this.image,
    this.recipients,
    this.created_at,
    this.modified_at,
    this.draft,
    this.batches,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      batch_id: json['batch_id'] as String,
      classis_id: json['classis_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      image: json['image'] as String,
      recipients: json['recipients'] as String,
      created_at: json['created_at'] as String,
      modified_at: json['modified_at'] as String,
      draft: json['draft'] as String,
      batches: json['batches'] as String,
    );
  }
}
