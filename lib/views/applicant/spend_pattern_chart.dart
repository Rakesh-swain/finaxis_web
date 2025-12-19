import 'package:flutter/material.dart';

Widget spendPatternCharts() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: const [
        SpendPatternChart(
          title: 'Spend Pattern - Channel',
          data: {
            'CHEQUE': 0,
            'EFT': 3259,
            'FTS': 4500,
            'WAPI': 0,
            'ITR': 1018,
            'CASH': 0,
            'OTHERS': 21194,
          },
        ),
        SizedBox(height: 32),
        SpendPatternChart(
          title: 'Spend Pattern - SIC',
          data: {
            'CARD PAYMENT': 0,
            'EDUTECH': 0,
            'FOOD': 0,
            'LOAN REPAYMENT': 0,
            'OTHER BANK': 8777,
            'UNCLASSIFIED': 21194,
          },
        ),
      ],
    ),
  );
}

class SpendPatternChart extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const SpendPatternChart({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    final yAxisMax = ((maxValue / 5000).ceil() * 5000).toDouble();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis
                SizedBox(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(6, (index) {
                      final value = (yAxisMax / 5 * (5 - index)).toInt();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Chart area
                Expanded(
                  child: Stack(
                    children: [
                      // Grid lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return Container(
                            height: 1,
                            color: const Color(0xFFE0E0E0),
                          );
                        }),
                      ),
                      // Bars
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: data.entries.map((entry) {
                          return Expanded(
                            child: BarItem(
                              label: entry.key,
                              value: entry.value,
                              maxValue: yAxisMax,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarItem extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;

  const BarItem({
    Key? key,
    required this.label,
    required this.value,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barHeight = value > 0 ? (value / maxValue) * 350 : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (value > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ),
          Container(
            width: double.infinity,
            height: barHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF5B7FDB),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}