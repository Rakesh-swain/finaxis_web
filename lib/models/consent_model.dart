class ConsentModel {
  final String consentId;
  final String customerName;
  final String mobile;
  final String bankName;
  final DateTime consentDate;
  final String status;

  ConsentModel({
    required this.consentId,
    required this.customerName,
    required this.mobile,
    required this.bankName,
    required this.consentDate,
    required this.status,
  });

  factory ConsentModel.fromJson(Map<String, dynamic> json) {
    return ConsentModel(
      consentId: json['consentId'],
      customerName: json['customerName'],
      mobile: json['mobile'],
      bankName: json['bankName'],
      consentDate: DateTime.parse(json['consentDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consentId': consentId,
      'customerName': customerName,
      'mobile': mobile,
      'bankName': bankName,
      'consentDate': consentDate.toIso8601String(),
      'status': status,
    };
  }
}
