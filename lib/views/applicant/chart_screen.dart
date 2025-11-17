import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1000,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('Balance Analysis', 0),
                  _buildTab('Transaction Analysis', 1),
                  _buildTab('Expense', 2),
                  _buildTab('Alarming Transactions', 3),
                  _buildTab('FOIR Distribution', 4),
                  _buildTab('Cashflow', 5),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? Colors.grey.shade200 : Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (selectedTab) {
      case 0:
        return const BalanceAnalysisTab();
      case 1:
        return const TransactionAnalysisTab();
      case 2:
        return const ExpenseTab();
      case 3:
        return const AlarmingTransactionsTab();
      case 4:
        return const FOIRDistributionTab();
      case 5:
        return const CashflowTab();
      default:
        return const BalanceAnalysisTab();
    }
  }
}

// BALANCE ANALYSIS TAB
class BalanceAnalysisTab extends StatefulWidget {
  const BalanceAnalysisTab({Key? key}) : super(key: key);

  @override
  State<BalanceAnalysisTab> createState() => _BalanceAnalysisTabState();
}

class _BalanceAnalysisTabState extends State<BalanceAnalysisTab> {
  String selectedSubTab = 'Balance Analysis';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'Customer credit profile',
        //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        // ),
        SizedBox(height: 20),
        Row(
          children: [
            _buildSubTab('Balance Analysis'),
            _buildSubTab('Volume Analysis'),
            _buildSubTab('Value Analysis'),
          ],
        ),
        SizedBox(height: 20),
        if (selectedSubTab == 'Balance Analysis')
          const AverageEODBalanceChart(),
        if (selectedSubTab == 'Volume Analysis') const VolumeAnalysisChart(),
        if (selectedSubTab == 'Value Analysis') const ValueAnalysisChart(),
      ],
    );
  }

  Widget _buildSubTab(String title) {
    final isSelected = selectedSubTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedSubTab = title),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BCD4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00BCD4), width: 2),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF00BCD4),
          ),
        ),
      ),
    );
  }
}

// AVERAGE EOD BALANCE CHART
class AverageEODBalanceChart extends StatelessWidget {
  const AverageEODBalanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildChart()),
                  SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildMetrics()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildChart(),
                  SizedBox(height: 24),
                  _buildMetrics(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Average EOD balance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 350,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 200000,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    const months = [
                      'September',
                      'October',
                      'November',
                      'December',
                      'January',
                      'February',
                      'March',
                      'April',
                    ];
                    return BarTooltipItem(
                      '${months[groupIndex]}\nAED${rod.toY.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Month',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const months = [
                        'September',
                        'October',
                        'November',
                        'December',
                        'January',
                        'February',
                        'March',
                        'April',
                      ];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'AED${(value / 1000).toInt()}K',
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50000,
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(0, 71350.71),
                _buildBarGroup(1, 28879.52),
                _buildBarGroup(2, 28827.45),
                _buildBarGroup(3, 64899.42),
                _buildBarGroup(4, 91598.75),
                _buildBarGroup(5, 83388.13),
                _buildBarGroup(6, 92934.51),
                _buildBarGroup(7, 29354.12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildMetricCard('Balance on 10th', 'AED10,85,193.21'),
        _buildMetricCard('Min EOD Balance', 'AED62,399.80'),
        _buildMetricCard('Balance on 20th', 'AED18,02,008.80'),
        _buildMetricCard('Max EOD Balance', 'AED35,34,892.74'),
        _buildMetricCard('Balance on last day of month', 'AED4,50,591.00'),
        _buildMetricCard('Average EOD Balance', 'AED5,86,960.00'),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: const Color(0xFF80CBC4),
          width: 32,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// VOLUME ANALYSIS CHART
class VolumeAnalysisChart extends StatelessWidget {
  const VolumeAnalysisChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildMetricCard(
                  'Total No. of Credit Transactions',
                  'AED233.00',
                ),
                _buildMetricCard(
                  'Total No. of Inward Cheque Bounces',
                  'AED5.00',
                ),
                _buildMetricCard(
                  'Total No. of Debit Transactions',
                  'AED581.00',
                ),
                _buildMetricCard(
                  'Total No. of Outward Cheque Bounces',
                  'AED5.00',
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'No. of times 100% CC/OD Utilization breached',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'AED0.00',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// VALUE ANALYSIS CHART
class ValueAnalysisChart extends StatelessWidget {
  const ValueAnalysisChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildMetricCard(
                  'Total Amount of Credit Transactions',
                  'AED1,38,04,612.80',
                ),
                _buildMetricCard('Average OD/CC Utilization', '27.20%'),
                _buildMetricCard(
                  'Total Amount of Debit Transactions',
                  'AED1,00,85,337.21',
                ),
                _buildMetricCard('Max OD/CC Utilization', '38.50%'),
                _buildMetricCard('Sanction Limit', 'AED12,00,000.00'),
                _buildMetricCard(
                  'Ratio of Cash Deposits vs. Total Credit',
                  '68.30%',
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OD/CC Interest',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'AED1,03,278.00',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// TRANSACTION ANALYSIS TAB
class TransactionAnalysisTab extends StatefulWidget {
  const TransactionAnalysisTab({Key? key}) : super(key: key);

  @override
  State<TransactionAnalysisTab> createState() => _TransactionAnalysisTabState();
}

class _TransactionAnalysisTabState extends State<TransactionAnalysisTab> {
  String selectedSubTab = 'Credit Analysis';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaction Analysis',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _buildSubTab('Credit Analysis'),
                _buildSubTab('Debit Analysis'),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        if (selectedSubTab == 'Credit Analysis') const CreditAnalysisChart(),
        if (selectedSubTab == 'Debit Analysis') const DebitAnalysisChart(),
      ],
    );
  }

  Widget _buildSubTab(String title) {
    final isSelected = selectedSubTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedSubTab = title),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BCD4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00BCD4), width: 2),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF00BCD4),
          ),
        ),
      ),
    );
  }
}

// CREDIT ANALYSIS CHART
class DebitAnalysisChart extends StatelessWidget {
  const DebitAnalysisChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildDonutChart()),
                      SizedBox(width: 40),
                      Expanded(flex: 3, child: _buildMetrics()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildDonutChart(),
                      SizedBox(height: 24),
                      _buildMetrics(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDayWiseDebitChart()),
                  SizedBox(width: 20),
                  Expanded(child: _buildTopDebitorsChart()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDayWiseDebitChart(),
                  SizedBox(height: 20),
                  _buildTopDebitorsChart(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Debit Amount by Channel',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: 46.3,
                      color: const Color(0xFF80CBC4),
                      radius: 50,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 53.7,
                      color: const Color(0xFFCE93D8),
                      radius: 50,
                      title: '',
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 30,
                child: const Text(
                  'ITR 46.3%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 30,
                child: const Text(
                  'DDS 53.7%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('ITR', const Color(0xFF80CBC4)),
            SizedBox(width: 20),
            _buildLegend('DDS', const Color(0xFFCE93D8)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed breakdown of expenses',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildMetricCard('ITR Debit Amount', '-AED19,175')),
            SizedBox(width: 16),
            Expanded(child: _buildMetricCard('DDS Debit Amount', '-AED22,240')),
          ],
        ),
      ],
    );
  }

  Widget _buildDayWiseDebitChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Day wise Debit Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  minY: -20000,
                  maxY: 0,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Day',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            '2',
                            '4',
                            '8',
                            '11',
                            '12',
                            '15',
                            '20',
                            '21',
                            '25',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value < 0 ? "-" : ""}AED${(value.abs() / 1000).toInt()}K',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: -500,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: -300,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: -15000,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: -800,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: -1200,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                          toY: -600,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      barRods: [
                        BarChartRodData(
                          toY: -18000,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 7,
                      barRods: [
                        BarChartRodData(
                          toY: -400,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 8,
                      barRods: [
                        BarChartRodData(
                          toY: -1000,
                          color: const Color(0xFF80CBC4),
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text(
                'September',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDebitorsChart() {
    final debtors = [
      'Raja General Stores',
      'Kapoor Enterprises',
      'Gupta Traders',
      'Sharma Brothers',
      'Malhotra Emporium',
      'Verma Distributors',
      'Patel Retailers',
      'Chawla Wholesalers',
      'Saxena Merchants',
    ];

    final values = [580, 540, 520, 490, 470, 440, 410, 380, 350];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 10 Debitors',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: debtors.length,
                itemBuilder: (context, index) {
                  double barWidth =
                      (values[index] / 280) * 200; // proportional width

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            debtors[index],
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // FIXED: Removed Expanded. Using SizedBox with width.
                        SizedBox(
                          width: barWidth,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCE93D8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// EXPENSE TAB
class ExpenseTab extends StatelessWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildDonutChart()),
                  SizedBox(width: 60),
                  Expanded(flex: 3, child: _buildMetrics()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDonutChart(),
                  SizedBox(height: 24),
                  _buildMetrics(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDonutChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expense Summary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        SizedBox(
          height: 350,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 80,
                  sections: [
                    PieChartSectionData(
                      value: 63.85,
                      color: const Color(0xFF80CBC4),
                      radius: 100,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 13.41,
                      color: const Color(0xFF4DB6AC),
                      radius: 90,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 0.2,
                      color: const Color(0xFF26A69A),
                      radius: 80,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 8.46,
                      color: const Color(0xFFFFEB3B),
                      radius: 95,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 9.11,
                      color: const Color(0xFFB2DFDB),
                      radius: 85,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 4.95,
                      color: const Color(0xFFE0F2F1),
                      radius: 75,
                      title: '',
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Loan 63.85%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 40,
                bottom: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Salary Payments 9.11%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 50,
                bottom: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Utility Payments',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '8.46%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bank Charges',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '0.2%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                top: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Cash Withdr...',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '13.41%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 80,
                top: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Investments',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '4.95%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed breakdown of expenses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricCard('Loan', 'AED38,67,051'),
            _buildMetricCard('Utility Payment', 'AED5,12,402'),
            _buildMetricCard('Cash Withdrawals', 'AED8,12,400'),
            _buildMetricCard('Bank Charges', 'AED12,252'),
            _buildMetricCard('Salary Payment', 'AED5,52,000'),
            _buildMetricCard('Investments', 'AED3,00,000'),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ALARMING TRANSACTIONS TAB
class AlarmingTransactionsTab extends StatelessWidget {
  const AlarmingTransactionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildIndicators()),
                  SizedBox(width: 40),
                  Expanded(flex: 2, child: _buildMetrics()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildIndicators(),
                  SizedBox(height: 24),
                  _buildMetrics(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alarming Transaction',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.shade300, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.red.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Possible fraud Indicators - 2',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              _buildIndicatorRow(
                'Suspicious bank eStatement',
                'N',
                Colors.orange,
              ),
              const Divider(),
              _buildIndicatorRow(
                'Suspicious FTS Transactions',
                'N',
                Colors.orange,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade300, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Behavioural/Transactional Indicators',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16),
              _buildIndicatorRow(
                'Cheque number in series\n(Cheque number should not be in series)',
                'N',
                Colors.green,
              ),
              const Divider(),
              _buildIndicatorRow(
                'Discontinuity in credits/ receivables\n(For non-retail customers, identify if the delay between two successive credits is more than 15 days.)',
                'N',
                Colors.green,
              ),
              const Divider(),
              _buildIndicatorRow(
                'Immediate big debit after Salary credit\n(Withdrawal of big amount of money soon after salary credit may be due to forged salary entries.)',
                'Y',
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      children: [
        _buildMetricCard(
          'Bounces and Penalized transactions\nBalance',
          'AED10,000',
          Colors.red,
        ),
        SizedBox(height: 16),
        _buildMetricCard(
          'Bounces and Penalized transactions\nAmount',
          'AED5,000',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildIndicatorRow(String text, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: statusColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// FOIR DISTRIBUTION TAB
class FOIRDistributionTab extends StatelessWidget {
  const FOIRDistributionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FOIR Distributions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 350,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Bar Chart
                      BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceEvenly,
                          maxY: 100,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const labels = [
                                    'September',
                                    'October',
                                    'November',
                                    'December',
                                    'January',
                                    'February',
                                  ];
                                  const years = [
                                    '2024',
                                    '',
                                    '',
                                    '',
                                    '2025',
                                    '',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < labels.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            labels[value.toInt()],
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          if (years[value.toInt()].isNotEmpty)
                                            Text(
                                              years[value.toInt()],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 70,
                                interval: 10,
                                getTitlesWidget: (value, meta) {
                                  if (value % 10 == 0) {
                                    return Text(
                                      '${(value * 300000).toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(\d{3})+$)'), (m) => '${m[1]},')}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              axisNameWidget: const Padding(
                                padding: EdgeInsets.only(left: 8, bottom: 4),
                                child: Text(
                                  'FOIR_%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: 10,
                                getTitlesWidget: (value, meta) {
                                  final foirPercent =
                                      40 + (value * 0.4).toInt();
                                  if (value % 25 == 0 &&
                                      foirPercent >= 40 &&
                                      foirPercent <= 80) {
                                    return Text(
                                      '$foirPercent%',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 25,
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: List.generate(6, (i) {
                            final outflow = [
                              100.0,
                              93.3,
                              83.3,
                              90.0,
                              96.7,
                              103.3,
                            ][i];
                            final inflow = [
                              66.7,
                              60.0,
                              53.3,
                              63.3,
                              66.7,
                              70.0,
                            ][i];
                            return BarChartGroupData(
                              x: i,
                              barsSpace: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: outflow,
                                  color: const Color(0xFF80CBC4),
                                  width: 40,
                                  borderRadius: BorderRadius.zero,
                                ),
                                BarChartRodData(
                                  toY: inflow,
                                  color: const Color(0xFFCE93D8),
                                  width: 40,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      // Line Chart Overlay - positioned to touch bar midpoints
                      Positioned.fill(
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 100,minX: 0,
                            maxX:5.5,
                            lineBarsData: [
                              LineChartBarData(
                                spots: _calculateMidpointSpots(),
                                isCurved: true,
                                curveSmoothness: 0.35,
                                color: Colors.orange,
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 5,
                                          color: Colors.orange,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                ),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(show: false),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData(enabled: false),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend('OutFlow', const Color(0xFF80CBC4)),
                const SizedBox(width: 24),
                _buildLegend('Inflow', const Color(0xFFCE93D8)),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(width: 20, height: 3, color: Colors.orange),
                    const SizedBox(width: 6),
                    const Text('FOIR_%', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildFOIRTable(),
          ],
        ),
      ),
    );
  }

  // Calculate spots at the top of Inflow bars (connection point)
List<FlSpot> _calculateMidpointSpots() {
  final inflowValues = [52.51, 61.84, 71.81, 68.60, 68.43, 72.26];
  final totalBars = inflowValues.length;

  return List.generate(totalBars, (i) {
    // The +0.5 only works if spacing from alignment is even.
    // Let's calculate based on assumed uniform width:
    final xValue = i.toDouble() + 1;
    return FlSpot(xValue, inflowValues[i]);
  });
}


  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFOIRTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FixedColumnWidth(180),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(120),
            3: FixedColumnWidth(100),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(100),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(100),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.teal.shade700),
              children: [
                _buildTableCell('FOIR', isHeader: true),
                _buildTableCell('Year\nvalue', isHeader: true),
                _buildTableCell('2024\nSeptember', isHeader: true),
                _buildTableCell('October', isHeader: true),
                _buildTableCell('November', isHeader: true),
                _buildTableCell('December', isHeader: true),
                _buildTableCell('2025\nJanuary', isHeader: true),
                _buildTableCell('February', isHeader: true),
              ],
            ),
            _buildDataRow(
              'Monthly Inflow/ Income',
              '2102221.00',
              '1898921.00',
              '1728822.00',
              '1910222.00',
              '2010011.00',
              '2010101.00',
            ),
            _buildDataRow(
              'EMI Payments',
              '489536.00',
              '551525.00',
              '613514.00',
              '675503.00',
              '737492.00',
              '799481.00',
            ),
            _buildDataRow(
              'Utility Payments',
              '518273.00',
              '524445.00',
              '530617.00',
              '536789.00',
              '542961.00',
              '549133.00',
            ),
            _buildDataRow(
              'Salary Payments',
              '92000.00',
              '92000.00',
              '92000.00',
              '92000.00',
              '92000.00',
              '92000.00',
            ),
            _buildDataRow(
              'Others',
              '2042.00',
              '4220.00',
              '3231.00',
              '4020.00',
              '1020.00',
              '9821.00',
            ),
            _buildDataRow(
              'Bank Charges',
              '2042.00',
              '2042.00',
              '2042.00',
              '2042.00',
              '2042.00',
              '2042.00',
            ),
            TableRow(
              decoration: BoxDecoration(color: Colors.teal.shade700),
              children: [
                _buildTableCell('FOIR', isHeader: true),
                _buildTableCell('', isHeader: true),
                _buildTableCell('0.53', isHeader: true, isOrange: true),
                _buildTableCell('0.62', isHeader: true, isOrange: true),
                _buildTableCell('0.72', isHeader: true, isOrange: true),
                _buildTableCell('0.69', isHeader: true, isOrange: true),
                _buildTableCell('0.68', isHeader: true, isOrange: true),
                _buildTableCell('0.72', isHeader: true, isOrange: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    String label,
    String v1,
    String v2,
    String v3,
    String v4,
    String v5,
    String v6,
  ) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.orange.shade100),
      children: [
        _buildTableCell(label),
        _buildTableCell(''),
        _buildTableCell(v1),
        _buildTableCell(v2),
        _buildTableCell(v3),
        _buildTableCell(v4),
        _buildTableCell(v5),
        _buildTableCell(v6),
      ],
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isOrange = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader
              ? Colors.white
              : (isOrange ? Colors.orange.shade800 : Colors.black87),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// CASHFLOW TAB
class CashflowTab extends StatelessWidget {
  const CashflowTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCashInflowTable(),
          SizedBox(height: 20),
          _buildCashOutflowTable(),
          SizedBox(height: 20),
          _buildGrossInflowTable(),
          SizedBox(height: 20),
          _buildBankChargesTable(),
        ],
      ),
    );
  }

  Widget _buildCashInflowTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(60),
                2: FixedColumnWidth(80),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(100),
                5: FixedColumnWidth(100),
                6: FixedColumnWidth(100),
                7: FixedColumnWidth(100),
                8: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.teal.shade700),
                  children: [
                    _buildCell('Particulars', isHeader: true),
                    _buildCell('%', isHeader: true),
                    _buildCell('Year\nvalue', isHeader: true),
                    _buildCell('2024\nSeptember', isHeader: true),
                    _buildCell('October', isHeader: true),
                    _buildCell('November', isHeader: true),
                    _buildCell('December', isHeader: true),
                    _buildCell('2025\nJanuary', isHeader: true),
                    _buildCell('February', isHeader: true),
                  ],
                ),
                _buildRow(
                  'Cash Deposits',
                  '48.95%',
                  '1598000',
                  '2,50,000.00',
                  '47,48,000.00',
                  '2,50,000.00',
                  '2,50,000.00',
                  '2,50,000.00',
                  '2,50,000.00',
                ),
                _buildRow(
                  'Clearing Receipt*',
                  '1.69%',
                  '73300',
                  '6,100.00',
                  '6,100.00',
                  '6,100.00',
                  '6,100.00',
                  '6,100.00',
                  '6,100.00',
                ),
                _buildRow(
                  'Interest/Revenue',
                  '8.09%',
                  '487520',
                  '9,300.00',
                  '49,88,100.00',
                  '9,300.00',
                  '9,300.00',
                  '9,300.00',
                  '9,300.00',
                ),
                _buildRow(
                  'Online Receipt*',
                  '7.18%',
                  '360400',
                  '30,000.00',
                  '30,000.00',
                  '30,000.00',
                  '30,000.00',
                  '30,000.00',
                  '30,000.00',
                ),
                _buildRow(
                  'Other Receipt',
                  '30.17%',
                  '2548000',
                  '2,04,000.00',
                  '2,04,000.00',
                  '2,04,000.00',
                  '2,04,000.00',
                  '2,04,000.00',
                  '2,04,000.00',
                ),
                _buildRow(
                  'Total Inflow (%)',
                  '9.60%',
                  '',
                  '0.00',
                  '1.06',
                  '0.00',
                  '0.00',
                  '0.00',
                  '0.00',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCashOutflowTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(60),
                2: FixedColumnWidth(80),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(100),
                5: FixedColumnWidth(100),
                6: FixedColumnWidth(100),
                7: FixedColumnWidth(100),
                8: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.teal.shade700),
                  children: [
                    _buildCell('Particulars', isHeader: true),
                    _buildCell('%', isHeader: true),
                    _buildCell('Year\nvalue', isHeader: true),
                    _buildCell('2024\nSeptember', isHeader: true),
                    _buildCell('October', isHeader: true),
                    _buildCell('November', isHeader: true),
                    _buildCell('December', isHeader: true),
                    _buildCell('2025\nJanuary', isHeader: true),
                    _buildCell('February', isHeader: true),
                  ],
                ),
                _buildRow(
                  'Cash Withdrawal',
                  '9.87%',
                  '34110',
                  '1,500.00',
                  '1,41.00',
                  '1,500.00',
                  '60,000.00',
                  '1,600.00',
                  '1,600.00',
                ),
                _buildRow(
                  'Charge Payment*',
                  '0.16%',
                  '78500',
                  '6,500.00',
                  '6,500.00',
                  '6,500.00',
                  '6,500.00',
                  '6,500.00',
                  '6,500.00',
                ),
                _buildRow(
                  'Online Payment*',
                  '19.84%',
                  '2660000',
                  '1,37,000.00',
                  '2,30,000.00',
                  '8,50,000.00',
                  '8,50,000.00',
                  '6,20,000.00',
                  '6,50,000.00',
                ),
                _buildRow(
                  'Other Payment*',
                  '0.00%',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                ),
                _buildRow(
                  'Outflow/Expenses',
                  '0.99%',
                  '4729899',
                  '39,98,672.00',
                  '23,54,318.00',
                  '25,51,240.00',
                  '46,88,602.00',
                  '54,05,048.00',
                  '57,12,484.00',
                ),
                _buildRow(
                  'Total Outflow (%)',
                  '0.80%',
                  '',
                  '0.02',
                  '0.01',
                  '0.02',
                  '0.04',
                  '0.04',
                  '0.05',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrossInflowTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(60),
                2: FixedColumnWidth(80),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(100),
                5: FixedColumnWidth(100),
                6: FixedColumnWidth(100),
                7: FixedColumnWidth(100),
                8: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.teal.shade700),
                  children: [
                    _buildCell('Particulars', isHeader: true),
                    _buildCell('%', isHeader: true),
                    _buildCell('Year\nvalue', isHeader: true),
                    _buildCell('2024\nSeptember', isHeader: true),
                    _buildCell('October', isHeader: true),
                    _buildCell('November', isHeader: true),
                    _buildCell('December', isHeader: true),
                    _buildCell('2025\nJanuary', isHeader: true),
                    _buildCell('February', isHeader: true),
                  ],
                ),
                _buildRow(
                  'Gross Inflow/Profit',
                  '9.00%',
                  '48240758',
                  '40,08,572.00',
                  '26,33,731.00',
                  '26,61,873.00',
                  '54,88,756.00',
                  '54,41,384.00',
                  '57,35,429.00',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankChargesTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(60),
                2: FixedColumnWidth(80),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(100),
                5: FixedColumnWidth(100),
                6: FixedColumnWidth(100),
                7: FixedColumnWidth(100),
                8: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.teal.shade700),
                  children: [
                    _buildCell('Particulars', isHeader: true),
                    _buildCell('%', isHeader: true),
                    _buildCell('Year\nvalue', isHeader: true),
                    _buildCell('2024\nSeptember', isHeader: true),
                    _buildCell('October', isHeader: true),
                    _buildCell('November', isHeader: true),
                    _buildCell('December', isHeader: true),
                    _buildCell('2025\nJanuary', isHeader: true),
                    _buildCell('February', isHeader: true),
                  ],
                ),
                _buildRow(
                  'Bank Charges',
                  '0.04%',
                  '16800',
                  '2,800.00',
                  '1,400.00',
                  '500.00',
                  '1,400.00',
                  '1,600.00',
                  '1,600.00',
                ),
                _buildRow(
                  'Contra',
                  '12.74%',
                  '6024002',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                ),
                _buildRow(
                  'Forex',
                  '12.44%',
                  '6024002',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                  '5,02,000.00',
                ),
                _buildRow(
                  'Interest Paid',
                  '0.20%',
                  '8400',
                  '8,000.00',
                  '8,000.00',
                  '8,000.00',
                  '8,000.00',
                  '8,000.00',
                  '8,000.00',
                ),
                _buildRow('Loan', '0.00%', '', '', '', '', '', '', ''),
                _buildRow(
                  'Penalty',
                  '0.88%',
                  '414500',
                  '37,500.00',
                  '35,500.00',
                  '4,000.00',
                  '37,500.00',
                  '37,500.00',
                  '37,500.00',
                ),
                _buildRow(
                  'Salary Payment',
                  '45.14%',
                  '2150450',
                  '95,950.00',
                  '19,32,000.00',
                  '19,32,000.00',
                  '19,32,000.00',
                  '19,32,000.00',
                  '19,32,000.00',
                ),
                _buildRow(
                  'Sweep-in',
                  '1.91%',
                  '45000',
                  '4,100.00',
                  '4,100.00',
                  '4,100.00',
                  '4,100.00',
                  '4,100.00',
                  '4,100.00',
                ),
                _buildRow(
                  'Sweep-out',
                  '0.23%',
                  '108800',
                  '9,000.00',
                  '9,000.00',
                  '9,000.00',
                  '9,000.00',
                  '9,000.00',
                  '9,000.00',
                ),
                _buildRow(
                  'Tax Payment',
                  '0.11%',
                  '52800',
                  '4,400.00',
                  '4,400.00',
                  '4,400.00',
                  '4,400.00',
                  '4,400.00',
                  '4,400.00',
                ),
                _buildRow(
                  'Tax Refund',
                  '1.65%',
                  '21600',
                  '1,750.00',
                  '1,750.00',
                  '1,750.00',
                  '1,750.00',
                  '1,750.00',
                  '1,750.00',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(
    String label,
    String percent,
    String value,
    String v1,
    String v2,
    String v3,
    String v4,
    String v5,
    String v6, {
    bool isBold = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isBold ? Colors.grey.shade200 : Colors.white,
      ),
      children: [
        _buildCell(label, isBold: isBold),
        _buildCell(percent, isBold: isBold),
        _buildCell(value, isBold: isBold),
        _buildCell(v1, isBold: isBold),
        _buildCell(v2, isBold: isBold),
        _buildCell(v3, isBold: isBold),
        _buildCell(v4, isBold: isBold),
        _buildCell(v5, isBold: isBold),
        _buildCell(v6, isBold: isBold),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false, bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: (isHeader || isBold)
              ? FontWeight.bold
              : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// DEBIT ANALYSIS CHART
class CreditAnalysisChart extends StatelessWidget {
  const CreditAnalysisChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildDonutChart()),
                      SizedBox(width: 40),
                      Expanded(flex: 3, child: _buildMetrics()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildDonutChart(),
                      SizedBox(height: 24),
                      _buildMetrics(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDayWiseCreditChart()),
                  SizedBox(width: 20),
                  Expanded(child: _buildTopCreditorsChart()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDayWiseCreditChart(),
                  SizedBox(height: 20),
                  _buildTopCreditorsChart(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Credit Amount by Channel',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: 57.13,
                      color: const Color(0xFF80CBC4),
                      radius: 50,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 42.87,
                      color: const Color(0xFFCE93D8),
                      radius: 50,
                      title: '',
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 30,
                child: const Text(
                  'ITR 57.13%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 30,
                child: const Text(
                  'DDS 42.87%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('ITR', const Color(0xFF80CBC4)),
            SizedBox(width: 20),
            _buildLegend('DDS', const Color(0xFFCE93D8)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed breakdown of expenses',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildMetricCard('ITR Credit Amount', 'AED40,050')),
            SizedBox(width: 16),
            Expanded(child: _buildMetricCard('DDS Credit Amount', 'AED30,050')),
          ],
        ),
      ],
    );
  }

  Widget _buildDayWiseCreditChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Day wise Credit Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Day',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            '18',
                            '7',
                            '27',
                            '29',
                            '15',
                            '4',
                            '21',
                            '3',
                            '23',
                            '12',
                            '20',
                            '24',
                            '5',
                            '16',
                            '10',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'AED${(value / 1000).toInt()}K',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    15,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: [
                            18000,
                            14000,
                            8000,
                            8000,
                            8000,
                            5000,
                            4000,
                            2000,
                            1500,
                            1000,
                            800,
                            600,
                            500,
                            400,
                            300,
                          ][i].toDouble(),
                          color: const Color(0xFF80CBC4),
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                'September',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCreditorsChart() {
    final creditors = [
      'Gopal Enterprises',
      'Ananya Traders',
      'Rajendra Emporium',
      'Rishi Merchants',
      'Naveen Distributors',
      'Arjun Enterprises',
      'Meera Retailers',
      'Sunil Suppliers',
      'Maya Traders',
    ];

    final values = [600, 550, 520, 500, 450, 420, 380, 350, 320];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 10 Creditors',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: creditors.length,
                itemBuilder: (context, index) {
                  double barWidth =
                      (values[index] / 300) * 200; // proportional width

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            creditors[index],
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // FIXED: Replaced Expanded with SizedBox
                        SizedBox(
                          width: barWidth,
                          child: Container(
                            height: 20,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCE93D8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// DEBIT ANALYSIS CHART
// class DebitAnalysisChart extends StatelessWidget {
//   const DebitAnalysisChart({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth > 800) {
//                   return Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
