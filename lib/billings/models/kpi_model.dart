class KPIData {
  final int activeEMIs;
  final String monthlyCollected;
  final int successfulDebits;
  final int failedDebits;
  final int pendingConsents;

  KPIData({
    required this.activeEMIs,
    required this.monthlyCollected,
    required this.successfulDebits,
    required this.failedDebits,
    required this.pendingConsents,
  });

  static KPIData getDummyData() {
    return KPIData(
      activeEMIs: 24,
      monthlyCollected: 'AED 4.2K',
      successfulDebits: 18,
      failedDebits: 2,
      pendingConsents: 7,
    );
  }
}