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
  final int activeCustomers;          // Active in last 30 days
  final int activeConsents;           // Total active consents
  final int expiringConsents;         // Expiring in next 30 days
  final int totalTransactions;
  final int totalAmount;       
  final double failedTxnPercent;      // Failed transaction rate
  final int openAlerts;               // Compliance / risk alerts

  KpiData({
    required this.activeCustomers,
    required this.activeConsents,
    required this.expiringConsents,
    required this.totalTransactions,
    required this.totalAmount,
    required this.failedTxnPercent,
    required this.openAlerts,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      activeCustomers: json['activeCustomers'] ?? 0,
      activeConsents: json['activeConsents'] ?? 0,
      expiringConsents: json['expiringConsents'] ?? 0,
      totalTransactions: json['totalTransactions'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      failedTxnPercent:
          (json['failedTxnPercent'] ?? 0).toDouble(),
      openAlerts: json['openAlerts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeCustomers': activeCustomers,
      'activeConsents': activeConsents,
      'expiringConsents': expiringConsents,
      'totalTransactions': totalTransactions,
      'totalAmount': totalAmount,
      'failedTxnPercent': failedTxnPercent,
      'openAlerts': openAlerts,
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
