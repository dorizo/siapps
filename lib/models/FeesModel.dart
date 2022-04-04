class FeesModel {
  String batch_id;
  String batch_name;
  String fees_type;
  String amount;
  String fees_paid_id;
  String receipt_no;
  String paid_amount;
  String note;
  String paid_date;

  FeesModel(
      {this.batch_id,
      this.batch_name,
      this.fees_type,
      this.amount,
      this.fees_paid_id,
      this.receipt_no,
      this.paid_amount,
      this.note,
      this.paid_date});

  factory FeesModel.fromJson(Map<String, dynamic> json) {
    return FeesModel(
      batch_id: json['batch_id'] as String,
      batch_name: json['batch_name'] as String,
      fees_type: json['fees_type'] as String,
      amount: json['amount'] as String,
      fees_paid_id: json['fees_paid_id'] as String,
      receipt_no: json['receipt_no'] as String,
      paid_amount: json['paid_amount'] as String,
      note: json['note'] as String,
      paid_date: json['paid_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batch_id': batch_id,
      'batch_name': batch_name,
      'fees_type': fees_type,
      'amount': amount,
      'fees_paid_id': fees_paid_id,
      'receipt_no': receipt_no,
      'paid_amount': paid_amount,
      'note': note,
      'paid_date': paid_date,
    };
  }
}
