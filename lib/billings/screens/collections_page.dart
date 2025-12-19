import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final collections = [
      {
        'billId': 'INV-00123',
        'customer': 'Ahmed Al Mansouri',
        'emiNo': '3/12',
        'amount': 100,
        'date': 'Dec 05, 2025',
        'bank': 'Emirates NBD',
        'status': 'active',
      },
      {
        'billId': 'INV-00124',
        'customer': 'Hana Al Ketbi',
        'emiNo': '2/12',
        'amount': 67,
        'date': 'Dec 03, 2025',
        'bank': 'FAB',
        'status': 'failed',
      },
      {
        'billId': 'INV-00123',
        'customer': 'Mohammed Al Mazrouei',
        'emiNo': '1/12',
        'amount': 208,
        'date': 'Dec 10, 2025',
        'bank': 'ADCB',
        'status': 'active',
      },
    ];

    final columns = [
      'Bill ID',
      'Customer',
      'EMI #',
      'Amount (AED)',
      'Debit Date',
      'Bank',
      'Status',
      'Action',
    ];

    final columnFlex = [1, 2, 1, 1, 1, 1, 1, 1];

    return SingleChildScrollView(
      padding: EdgeInsets.all(28),
      child: Column(
        children: [
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
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E293B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '💰 Collection Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      children: [
                        // Search Box
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              fillColor: Colors.white.withOpacity(0.1),
                              hintStyle: TextStyle(color: AppTheme.textSecondary),
                              border: InputBorder.none,
                              prefixText: '🔍 ',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            style: TextStyle(color: AppTheme.textPrimary),
                          ),
                        ),

                        // Table Header
                        _buildTableHeader(columns, columnFlex),

                        // Table Rows
                        ...collections.map((col) {
                          return _buildTableRow(
                            columnFlex: columnFlex,
                            cells: [
                              Text(col['billId'] as String, style: tableText),
                              Text(col['customer'] as String, style: boldTableText),
                              Text(col['emiNo'] as String, style: tableText),
                              Text(col['amount'].toString(), style: tableText),
                              Text(col['date'] as String, style: tableText),
                              Text(col['bank'] as String, style: tableText),
                              _buildStatusBadge(col['status'] as String),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  minimumSize: Size(0, 30),
                                ),
                                child: Text(
                                  col['status'] == 'active' ? 'Receipt' : 'Retry',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> columns, List<int> columnFlex) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBg.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(columns.length, (index) {
          return Expanded(
            flex: columnFlex[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                columns[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTableRow({
    required List<int> columnFlex,
    required List<Widget> cells,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppTheme.borderLight.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          return Expanded(
            flex: columnFlex[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: cells[index],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status == 'active' ? AppTheme.statusActive : AppTheme.statusFailed;
    final label = status == 'active' ? '✓ Success' : '✕ Failed';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

}

final tableText = TextStyle(
  fontSize: 13,
  color: AppTheme.textPrimary,
);

final boldTableText = TextStyle(
  fontSize: 13,
  color: AppTheme.textPrimary,
  fontWeight: FontWeight.w600,
);

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