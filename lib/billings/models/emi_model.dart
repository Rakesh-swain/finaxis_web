class EMIApplication {
  final String billId;
  final String customerName;
  final double amount;
  final double emiPerMonth;
  final String status;
  final String consent;
  final String tenure;
  final int paidMonths;
  final int totalMonths;
  final String nextDebit;

  EMIApplication({
    required this.billId,
    required this.customerName,
    required this.amount,
    required this.emiPerMonth,
    required this.status,
    required this.consent,
    required this.tenure,
    required this.paidMonths,
    required this.totalMonths,
    required this.nextDebit,
  });

  static List<EMIApplication> getDummyData() {
    return [
      EMIApplication(
        billId: 'INV-00123',
        customerName: 'Ahmed Al Mansouri',
        amount: 1200,
        emiPerMonth: 100,
        status: 'active',
        consent: 'approved',
        tenure: '12M',
        paidMonths: 3,
        totalMonths: 12,
        nextDebit: 'Dec 05',
      ),
      EMIApplication(
        billId: 'INV-00124',
        customerName: 'Fatima Al Suwaidi',
        amount: 800,
        emiPerMonth: 67,
        status: 'Pending',
        consent: 'pending',
        tenure: '12M',
        paidMonths: 0,
        totalMonths: 12,
        nextDebit: 'Dec 08',
      ),
      EMIApplication(
        billId: 'INV-00125',
        customerName: 'Mohammed Al Mazrouei',
        amount: 2500,
        emiPerMonth: 208,
        status: 'approved',
        consent: 'approved',
        tenure: '12M',
        paidMonths: 1,
        totalMonths: 12,
        nextDebit: 'Dec 10',
      ),
    ];
  }
}