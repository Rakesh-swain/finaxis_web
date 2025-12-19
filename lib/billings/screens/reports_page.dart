import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui' as ui;

class ReportsPage extends StatefulWidget {
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _collectionPeriod = 'last6';
  String _statusPeriod = 'last6';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          

          // Two Chart Cards Row
          if (!isMobile)
            SizedBox(
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildMonthlyCollectionCard()),
                  SizedBox(width: 20),
                  Expanded(child: _buildCollectionStatusCard()),
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: 400, child: _buildMonthlyCollectionCard()),
                SizedBox(height: 20),
                SizedBox(height: 400, child: _buildCollectionStatusCard()),
              ],
            ),
          
          SizedBox(height: 28),

          // Bottom Two Cards Row
          if (!isMobile)
            SizedBox(
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTopProductsCard()),
                  SizedBox(width: 20),
                  Expanded(child: _buildKeyMetricsCard()),
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: 400, child: _buildTopProductsCard()),
                SizedBox(height: 20),
                SizedBox(height: 400, child: _buildKeyMetricsCard()),
              ],
            ),
        ],
      ),
    );
  }

 
  Widget _buildMonthlyCollectionCard() {
    final collectionsData = [80, 100, 120, 140, 160, 170,];

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 Monthly Collection Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 200,
                minY: 0,
                barGroups: List.generate(
                  collectionsData.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: collectionsData[index].toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                        ),
                        width: 20,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['May','Jun','Jul', 'Aug', 'Sep', 'Oct',];
                        return Text(
                          months[value.toInt()],
                          style: TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.right,
                        );
                      },
                      reservedSize: 35,
                      interval: 50,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 50,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'AED Collections - Last 6 Months',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFA78BFA),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓ Collection Status Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 1,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 94.2,
                          color: Color(0xFF4ADE80),
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 3.7,
                          color: Color(0xFFFBBF24),
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 2.1,
                          color: Color(0xFFEF4444),
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 1.3,
                          color: Color(0xFF94A3B8),
                          title: '',
                          radius: 50,
                        ),
                      ],
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                // Center Text and Legend
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '94.2%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Success',
                              style: TextStyle(
                                color: Color(0xFFA78BFA),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildLegendItem('Successful (1173)', Color(0xFF4ADE80)),
                      SizedBox(height: 10),
                      _buildLegendItem('Pending (37)', Color(0xFFFBBF24)),
                      SizedBox(height: 10),
                      _buildLegendItem('Failed (24)', Color(0xFFEF4444)),
                      SizedBox(height: 10),
                      _buildLegendItem('Retrying (13)', Color(0xFF94A3B8)),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsCard() {
    final products = [
      {'name': 'Samsung TVs', 'emis': '450 EMIs', 'percent': 0.85},
      {'name': 'LG Appliances', 'emis': '380 EMIs', 'percent': 0.72},
      {'name': 'Sony Electronics', 'emis': '280 EMIs', 'percent': 0.53},
      {'name': 'Apple Devices', 'emis': '137 EMIs', 'percent': 0.26},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏆 Top Products by Collection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: List.generate(products.length, (index) {
                final product = products[index];
                final colors = [
                  [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  [Color(0xFF10B981), Color(0xFF059669)],
                  [Color(0xFFF59E0B), Color(0xFFD97706)],
                ];

                return Padding(
                  padding: EdgeInsets.only(bottom: index < products.length - 1 ? 12 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['name'] as String,
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          Text(
                            product['emis'] as String,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: product['percent'] as double,
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors[index][0],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsCard() {
    final metrics = [
      {'label': 'Avg Collection Time', 'value': '2.3 days'},
      {'label': 'Avg EMI Amount', 'value': 'AED 145'},
      {'label': 'Retry Success Rate', 'value': '96.8%', 'color': Color(0xFF4ADE80)},
      {'label': 'Churn Rate (30d)', 'value': '2.1%', 'color': Color(0xFFFBBF24)},
      {'label': 'Avg Customer LTV', 'value': 'AED 8,450'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Key Metrics Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: List.generate(metrics.length, (index) {
                final metric = metrics[index];
                final isLast = index == metrics.length - 1;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          metric['label'] as String,
                          style: TextStyle(fontSize: 13, color: Color(0xFFA78BFA)),
                        ),
                        Text(
                          metric['value'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: metric['color'] as Color? ?? Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (!isLast)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    if (isLast) SizedBox(height: 0),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}