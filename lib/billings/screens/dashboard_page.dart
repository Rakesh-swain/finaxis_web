import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _chartPeriod1 = 'last6';
  String _chartPeriod2 = 'last6';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Grid
          GridView.count(
            crossAxisCount: isMobile ? 1 : 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 3.5 : 1.7,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              _buildKPICard('Total Bills Active', '1,247', '↑ 12% from last month'),
              _buildKPICard('Total AUM', 'AED 45.2M', 'Assets Under Management'),
              _buildKPICard('This Month Collected', 'AED 8.9M', '1,247 Bill collections'),
              _buildKPICard('Collection Rate', '94.2%', '↑ 2.1% improvement'),
            ],
          ),
          SizedBox(height: 28),

          // Two Chart Cards Row
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildSalesVsCollectionsCard()),
                SizedBox(width: 20),
                Expanded(child: _buildSalesBreakdownCard()),
              ],
            )
          else
            Column(
              children: [
                _buildSalesVsCollectionsCard(),
                SizedBox(height: 20),
                _buildSalesBreakdownCard(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String label, String value, String subtext) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFD8B4FE),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFD8B4FE),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesVsCollectionsCard() {
    final isLast6 = _chartPeriod1 == 'last6';
    final months = isLast6 ? ['May','Jun','Jul', 'Aug', 'Sep', 'Oct',]
        : ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    
    final salesData = isLast6 
        ? [100, 120, 140, 160, 170, 150]
        : [100, 120, 110, 130];
    
    final collectionsData = isLast6
        ? [80, 100, 120, 140, 150, 130]
        : [80, 95, 105, 125];

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
          // Header with Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📈 Monthly Sales vs Collections',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(
                      'Last 6M',
                      _chartPeriod1 == 'last6',
                      () => setState(() => _chartPeriod1 = 'last6'),
                    ),
                    _buildToggleButton(
                      'This Month',
                      _chartPeriod1 == 'thisMonth',
                      () => setState(() => _chartPeriod1 = 'thisMonth'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 250,
            child: _buildBarChart(salesData, collectionsData, months),
          ),
          SizedBox(height: 12),

          Text(
            'AED in Millions - Sales vs Collections Trend',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFA78BFA),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesBreakdownCard() {
    final isLast6 = _chartPeriod2 == 'last6';
    
    final billsData = isLast6 ? 247 : 65;
    final amountData = 'AED 9.2M';
    final avgBill = isLast6 ? 'AED 3,723' : 'AED 3,840';
    final conversionRate = isLast6 ? 78.5 : 82.3;

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
          // Header with Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏪 Sales Breakdown - This Month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(
                      'Last 6M',
                      _chartPeriod2 == 'last6',
                      () => setState(() => _chartPeriod2 = 'last6'),
                    ),
                    _buildToggleButton(
                      'This Month',
                      _chartPeriod2 == 'thisMonth',
                      () => setState(() => _chartPeriod2 = 'thisMonth'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Stats
          _buildStatBar('Total Bills Created', billsData.toString(), 1.0),
          SizedBox(height: 14),
          _buildStatBar('Total Amount Sold', amountData, 1.0, color: Color(0xFFA855F7)),
          SizedBox(height: 14),
          _buildStatBar('Avg Bill Amount', avgBill, 0.85, color: Color(0xFF10B981)),
          SizedBox(height: 14),
          _buildStatBar('EMI Conversion Rate', '${conversionRate.toStringAsFixed(1)}%', conversionRate / 100, color: Color(0xFFF59E0B)),
          SizedBox(height: 14),
          Divider(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Month Growth',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFA78BFA),
                ),
              ),
              Text(
                '↑ 18.2%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4ADE80),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : Color(0xFFD8B4FE),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(
    List<int> salesData,
    List<int> collectionsData,
    List<String> labels,
  ) {
    final maxValue = [...salesData, ...collectionsData].reduce((a, b) => a > b ? a : b);
    final chartHeight = 180.0;
    final yAxisLabels = ['0', '${maxValue ~/ 3}', '${maxValue ~/ 1.5}', '${maxValue}'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Y-Axis with grid lines and labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              yAxisLabels[3],
              style: TextStyle(fontSize: 9, color: Color(0xFFA78BFA)),
            ),
            Text(
              yAxisLabels[2],
              style: TextStyle(fontSize: 9, color: Color(0xFFA78BFA)),
            ),
            Text(
              yAxisLabels[1],
              style: TextStyle(fontSize: 9, color: Color(0xFFA78BFA)),
            ),
            Text(
              yAxisLabels[0],
              style: TextStyle(fontSize: 9, color: Color(0xFFA78BFA)),
            ),
          ],
        ),
        SizedBox(width: 12),

        // Chart with grid lines
        Expanded(
          child: Column(
            children: [
              // Grid lines container
              SizedBox(
                height: chartHeight,
                child: Stack(
                  children: [
                    // Horizontal grid lines
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.1),
                        );
                      }),
                    ),
                    // Bar chart
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(labels.length, (index) {
                        final saleHeight = (salesData[index] / maxValue) * chartHeight;
                        final collHeight = (collectionsData[index] / maxValue) * chartHeight;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 10,
                                  height: saleHeight,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3B82F6),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      topRight: Radius.circular(2),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  width: 10,
                                  height: collHeight,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFA855F7),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      topRight: Radius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // X-Axis labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: labels.map((label) {
                  return Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFA78BFA),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(
    String label,
    String value,
    double fillPercentage, {
    Color color = const Color(0xFF3B82F6),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFD8B4FE),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fillPercentage,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// Import this for backdrop filter