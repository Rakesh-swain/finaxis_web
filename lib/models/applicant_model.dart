class ApplicantModel {
  final String cif;
  final String name;
  final int creditScore;
  final double riskScore;
  final String ragStatus;
  final String bankName;
  final String email;
  final String mobile;
  final DateTime lastUpdated;

  ApplicantModel({
    required this.cif,
    required this.name,
    required this.creditScore,
    required this.riskScore,
    required this.ragStatus,
    required this.bankName,
    required this.email,
    required this.mobile,
    required this.lastUpdated,
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    return ApplicantModel(
      cif: json['cif'],
      name: json['name'],
      creditScore: json['creditScore'],
      riskScore: json['riskScore'].toDouble(),
      ragStatus: json['ragStatus'],
      bankName: json['bankName'],
      email: json['email'],
      mobile: json['mobile'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cif': cif,
      'name': name,
      'creditScore': creditScore,
      'riskScore': riskScore,
      'ragStatus': ragStatus,
      'bankName': bankName,
      'email': email,
      'mobile': mobile,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class ApplicantDetailModel {
  final ApplicantModel applicant;
  final AffordabilityData affordability;
  final List<BalanceTrendData> balanceTrends;
  final List<SpendData> spendData;
  final List<KeyFeature> keyFeatures;
  final List<LoanData> otherLoans;
  final List<CreditCardData> creditCards;
  final List<InquiryData> inquiries;
  final List<AccessRequest> accessRequests;

  ApplicantDetailModel({
    required this.applicant,
    required this.affordability,
    required this.balanceTrends,
    required this.spendData,
    required this.keyFeatures,
    required this.otherLoans,
    required this.creditCards,
    required this.inquiries,
    required this.accessRequests,
  });

  factory ApplicantDetailModel.fromJson(Map<String, dynamic> json) {
    return ApplicantDetailModel(
      applicant: ApplicantModel.fromJson(json['applicant']),
      affordability: AffordabilityData.fromJson(json['affordability']),
      balanceTrends: (json['balanceTrends'] as List)
          .map((e) => BalanceTrendData.fromJson(e))
          .toList(),
      spendData: (json['spendData'] as List)
          .map((e) => SpendData.fromJson(e))
          .toList(),
      keyFeatures: (json['keyFeatures'] as List)
          .map((e) => KeyFeature.fromJson(e))
          .toList(),
      otherLoans: (json['otherLoans'] as List)
          .map((e) => LoanData.fromJson(e))
          .toList(),
      creditCards: (json['creditCards'] as List)
          .map((e) => CreditCardData.fromJson(e))
          .toList(),
      inquiries: (json['inquiries'] as List)
          .map((e) => InquiryData.fromJson(e))
          .toList(),
      accessRequests: (json['accessRequests'] as List)
          .map((e) => AccessRequest.fromJson(e))
          .toList(),
    );
  }
}

class AffordabilityData {
  final double affordabilityRatio;
  final double creditUtilizationRatio;

  AffordabilityData({
    required this.affordabilityRatio,
    required this.creditUtilizationRatio,
  });

  factory AffordabilityData.fromJson(Map<String, dynamic> json) {
    return AffordabilityData(
      affordabilityRatio: json['affordabilityRatio'].toDouble(),
      creditUtilizationRatio: json['creditUtilizationRatio'].toDouble(),
    );
  }
}

class BalanceTrendData {
  final DateTime date;
  final double balance;
  final String? marker;

  BalanceTrendData({
    required this.date,
    required this.balance,
    this.marker,
  });

  factory BalanceTrendData.fromJson(Map<String, dynamic> json) {
    return BalanceTrendData(
      date: DateTime.parse(json['date']),
      balance: json['balance'].toDouble(),
      marker: json['marker'],
    );
  }
}

class SpendData {
  final String category;
  final double amount;
  final String channel;

  SpendData({
    required this.category,
    required this.amount,
    required this.channel,
  });

  factory SpendData.fromJson(Map<String, dynamic> json) {
    return SpendData(
      category: json['category'],
      amount: json['amount'].toDouble(),
      channel: json['channel'],
    );
  }
}

class KeyFeature {
  final String name;
  final double value;
  final String trend;
  final String ragStatus;

  KeyFeature({
    required this.name,
    required this.value,
    required this.trend,
    required this.ragStatus,
  });

  factory KeyFeature.fromJson(Map<String, dynamic> json) {
    return KeyFeature(
      name: json['name'],
      value: json['value'].toDouble(),
      trend: json['trend'],
      ragStatus: json['ragStatus'],
    );
  }
}

class LoanData {
  final String loanType;
  final String lender;
  final double sanctionedAmount;
  final double outstandingAmount;
  final int tenure;
  final String status;
  final DateTime startDate;

  LoanData({
    required this.loanType,
    required this.lender,
    required this.sanctionedAmount,
    required this.outstandingAmount,
    required this.tenure,
    required this.status,
    required this.startDate,
  });

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      loanType: json['loanType'],
      lender: json['lender'],
      sanctionedAmount: json['sanctionedAmount'].toDouble(),
      outstandingAmount: json['outstandingAmount'].toDouble(),
      tenure: json['tenure'],
      status: json['status'],
      startDate: DateTime.parse(json['startDate']),
    );
  }
}

class CreditCardData {
  final String cardProvider;
  final double creditLimit;
  final double outstandingAmount;
  final double utilizationRate;
  final String status;

  CreditCardData({
    required this.cardProvider,
    required this.creditLimit,
    required this.outstandingAmount,
    required this.utilizationRate,
    required this.status,
  });

  factory CreditCardData.fromJson(Map<String, dynamic> json) {
    return CreditCardData(
      cardProvider: json['cardProvider'],
      creditLimit: json['creditLimit'].toDouble(),
      outstandingAmount: json['outstandingAmount'].toDouble(),
      utilizationRate: json['utilizationRate'].toDouble(),
      status: json['status'],
    );
  }
}

class InquiryData {
  final String inquiryType;
  final String lender;
  final DateTime date;
  final String purpose;

  InquiryData({
    required this.inquiryType,
    required this.lender,
    required this.date,
    required this.purpose,
  });

  factory InquiryData.fromJson(Map<String, dynamic> json) {
    return InquiryData(
      inquiryType: json['inquiryType'],
      lender: json['lender'],
      date: DateTime.parse(json['date']),
      purpose: json['purpose'],
    );
  }
}

class AccessRequest {
  final String accessId;
  final String consentId;
  final String loanNumber;
  final String status;
  final DateTime requestedAt;
  final String? balanceUrl;

  AccessRequest({
    required this.accessId,
    required this.consentId,
    required this.loanNumber,
    required this.status,
    required this.requestedAt,
    this.balanceUrl,
  });

  factory AccessRequest.fromJson(Map<String, dynamic> json) {
    return AccessRequest(
      accessId: json['accessId'],
      consentId: json['consentId'],
      loanNumber: json['loanNumber'],
      status: json['status'],
      requestedAt: DateTime.parse(json['requestedAt']),
      balanceUrl: json['balanceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessId': accessId,
      'consentId': consentId,
      'loanNumber': loanNumber,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
      'balanceUrl': balanceUrl,
    };
  }
}
