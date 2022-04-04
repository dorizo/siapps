class BankModel {
  String bank_acc_id;
  String classis_id;
  String acc_holder_name;
  String acc_no;
  String acc_ifsc;
  String acc_type;
  String bank_name;
  String payment_note;
  String created_at;

  BankModel(
      {this.bank_acc_id,
      this.classis_id,
      this.acc_holder_name,
      this.acc_no,
      this.acc_ifsc,
      this.acc_type,
      this.bank_name,
      this.payment_note,
      this.created_at});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      bank_acc_id: json['bank_acc_id'] as String,
      classis_id: json['classis_id'] as String,
      acc_holder_name: json['acc_holder_name'] as String,
      acc_no: json['acc_no'] as String,
      acc_ifsc: json['acc_ifsc'] as String,
      acc_type: json['acc_type'] as String,
      bank_name: json['bank_name'] as String,
      payment_note: json['payment_note'] as String,
      created_at: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank_acc_id': bank_acc_id,
      'classis_id': classis_id,
      'acc_holder_name': acc_holder_name,
      'acc_no': acc_no,
      'acc_ifsc': acc_ifsc,
      'acc_type': acc_type,
      'bank_name': bank_name,
      'payment_note': payment_note,
      'created_at': created_at,
    };
  }
}
