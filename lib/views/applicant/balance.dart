import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceTrendTab extends StatefulWidget {
  final bool isDarkMode;

  const BalanceTrendTab({Key? key, this.isDarkMode = false}) : super(key: key);

  @override
  State<BalanceTrendTab> createState() => _BalanceTrendTabState();
}

class _BalanceTrendTabState extends State<BalanceTrendTab> {
  late List<FlSpot> avgData;
  late List<FlSpot> minData;
  late List<BarChartGroupData> quarterlyData;
  late List<String> dateLabels;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    // Actual data from document
    final dates = [
      '19/3',
      '19/3',
      '22/4',
      '23/4',
      '23/4',
      '1/5',
      '18/6',
      '6/8',
      '7/8',
      '8/8',
    ];
    dateLabels = dates;

    // Actual balance data
    avgData = [
      FlSpot(0, 2300),
      FlSpot(1, 600),
      FlSpot(2, 500),
      FlSpot(3, 4989),
      FlSpot(4, 400),
      FlSpot(5, 300),
      FlSpot(6, 3000),
      FlSpot(7, 3700),
      FlSpot(8, 700),
      FlSpot(9, 100),
    ];

    minData = [
      FlSpot(0, 2300),
      FlSpot(1, 600),
      FlSpot(2, 500),
      FlSpot(3, 4989),
      FlSpot(4, 400),
      FlSpot(5, 300),
      FlSpot(6, 3000),
      FlSpot(7, 3700),
      FlSpot(8, 700),
      FlSpot(9, 100),
    ];

    // Quarterly data
    quarterlyData = [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 1463, color: const Color(0xFF5B7FFF).withOpacity(0.3))],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 1563, color: const Color(0xFF5B7FFF).withOpacity(0.3))],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 2400, color: const Color(0xFF5B7FFF).withOpacity(0.3))],
      ),  
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Top 3 Charts Row
          Row(
            children: [
              // Average Balance Chart
              Expanded(
                child: Card(
                  color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Average Balance Trend',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: 1000,
                                verticalInterval: 1,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < dateLabels.length) {
                                        return Text(dateLabels[index],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                            ));
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1000,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt()}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                          ));
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: avgData,
                                  isCurved: true,
                                  color: const Color(0xFF5B7FFF),
                                  barWidth: 2,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 3,
                                        color: const Color(0xFF5B7FFF),
                                        strokeWidth: 0,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(0xFF5B7FFF).withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Minimum Balance Chart
              Expanded(
                child: Card(
                  color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minimum Balance Trend',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: 1000,
                                verticalInterval: 1,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < dateLabels.length) {
                                        return Text(dateLabels[index],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                            ));
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1000,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt()}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                          ));
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: minData,
                                  isCurved: true,
                                  color: const Color(0xFF5B7FFF),
                                  barWidth: 2,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 3,
                                        color: const Color(0xFF5B7FFF),
                                        strokeWidth: 0,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(0xFF5B7FFF).withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Quarterly Bar Chart
              Expanded(
                child: Card(
                  color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quarterly Average Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              gridData: FlGridData(show: true, horizontalInterval: 1000),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const quarters = ['Q1', 'Q2', 'Q3'];
                                      return Text(quarters[value.toInt()],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                          ));
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1000,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt()}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                          ));
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: quarterlyData,
                              maxY: 5000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // // Full Width Running Balance Chart
          // Card(
          //   color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
          //   elevation: 2,
          //   child: Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Running Balance Trend',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: widget.isDarkMode ? Colors.white : Colors.black,
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         SizedBox(
          //           height: 300,
          //           child: LineChart(
          //             LineChartData(
          //               gridData: FlGridData(
          //                 show: true,
          //                 drawVerticalLine: true,
          //                 horizontalInterval: 1000,
          //                 verticalInterval: 1,
          //               ),
          //               titlesData: FlTitlesData(
          //                 bottomTitles: AxisTitles(
          //                   sideTitles: SideTitles(
          //                     showTitles: true,
          //                     interval: 1,
          //                     getTitlesWidget: (value, meta) {
          //                       int index = value.toInt();
          //                       if (index >= 0 && index < dateLabels.length) {
          //                         return Text(dateLabels[index],
          //                             style: TextStyle(
          //                               fontSize: 11,
          //                               color: widget.isDarkMode ? Colors.white70 : Colors.black54,
          //                             ));
          //                       }
          //                       return const Text('');
          //                     },
          //                   ),
          //                 ),
          //                 leftTitles: AxisTitles(
          //                   sideTitles: SideTitles(
          //                     showTitles: true,
          //                     interval: 1000,
          //                     getTitlesWidget: (value, meta) {
          //                       return Text('${value.toInt()}',
          //                           style: TextStyle(
          //                             fontSize: 11,
          //                             color: widget.isDarkMode ? Colors.white70 : Colors.black54,
          //                           ));
          //                     },
          //                   ),
          //                 ),
          //                 topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          //                 rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          //               ),
          //               borderData: FlBorderData(show: false),
          //               lineBarsData: [
          //                 LineChartBarData(
          //                   spots: avgData,
          //                   isCurved: true,
          //                   color: const Color(0xFF5B7FFF),
          //                   barWidth: 3,
          //                   dotData: FlDotData(
          //                     show: true,
          //                     getDotPainter: (spot, percent, barData, index) {
          //                       return FlDotCirclePainter(
          //                         radius: 5,
          //                         color: const Color(0xFF5B7FFF),
          //                         strokeWidth: 2,
          //                         strokeColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
          //                       );
          //                     },
          //                   ),
          //                   belowBarData: BarAreaData(
          //                     show: true,
          //                     color: const Color(0xFF5B7FFF).withOpacity(0.3),
          //                     gradient: LinearGradient(
          //                       begin: Alignment.topCenter,
          //                       end: Alignment.bottomCenter,
          //                       colors: [
          //                         const Color(0xFF5B7FFF).withOpacity(0.4),
          //                         const Color(0xFF5B7FFF).withOpacity(0.0),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}