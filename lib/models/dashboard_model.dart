class DashboardModel {
  final KpiData kpis;
  final RagSummary ragSummary;
  final List<FunnelStage> funnelStages;

  DashboardModel({
    required this.kpis,
    required this.ragSummary,
    required this.funnelStages,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      kpis: KpiData.fromJson(json['kpis']),
      ragSummary: RagSummary.fromJson(json['ragSummary']),
      funnelStages: (json['funnelStages'] as List)
          .map((e) => FunnelStage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpis': kpis.toJson(),
      'ragSummary': ragSummary.toJson(),
      'funnelStages': funnelStages.map((e) => e.toJson()).toList(),
    };
  }
}

class KpiData {
  final int totalApplicants;
  final double totalApplicantsMoM;
  final int activeConsents;
  final double activeConsentsMoM;
  final double avgCreditScore;
  final double avgCreditScoreMoM;
  final double totalDisbursed;
  final double totalDisbursedMoM;

  KpiData({
    required this.totalApplicants,
    required this.totalApplicantsMoM,
    required this.activeConsents,
    required this.activeConsentsMoM,
    required this.avgCreditScore,
    required this.avgCreditScoreMoM,
    required this.totalDisbursed,
    required this.totalDisbursedMoM,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      totalApplicants: json['totalApplicants'],
      totalApplicantsMoM: json['totalApplicantsMoM'].toDouble(),
      activeConsents: json['activeConsents'],
      activeConsentsMoM: json['activeConsentsMoM'].toDouble(),
      avgCreditScore: json['avgCreditScore'].toDouble(),
      avgCreditScoreMoM: json['avgCreditScoreMoM'].toDouble(),
      totalDisbursed: json['totalDisbursed'].toDouble(),
      totalDisbursedMoM: json['totalDisbursedMoM'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalApplicants': totalApplicants,
      'totalApplicantsMoM': totalApplicantsMoM,
      'activeConsents': activeConsents,
      'activeConsentsMoM': activeConsentsMoM,
      'avgCreditScore': avgCreditScore,
      'avgCreditScoreMoM': avgCreditScoreMoM,
      'totalDisbursed': totalDisbursed,
      'totalDisbursedMoM': totalDisbursedMoM,
    };
  }
}

class RagSummary {
  final int red;
  final int amber;
  final int green;

  RagSummary({
    required this.red,
    required this.amber,
    required this.green,
  });

  factory RagSummary.fromJson(Map<String, dynamic> json) {
    return RagSummary(
      red: json['red'],
      amber: json['amber'],
      green: json['green'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'red': red,
      'amber': amber,
      'green': green,
    };
  }

  int get total => red + amber + green;
}

class FunnelStage {
  final String stage;
  final int count;

  FunnelStage({
    required this.stage,
    required this.count,
  });

  factory FunnelStage.fromJson(Map<String, dynamic> json) {
    return FunnelStage(
      stage: json['stage'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'count': count,
    };
  }
}
