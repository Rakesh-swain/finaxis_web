// lib/screens/active_emis_page.dart
import 'package:finaxis_web/billings/screens/emi_details_page.dart';
import 'package:finaxis_web/views/transactions/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:finaxis_web/billings/models/emi_model.dart';
import 'package:finaxis_web/billings/widgets/custom_table.dart';

class ActiveEMIsPage extends StatefulWidget {
  final Function(EMIApplication)? onEMISelect;

  const ActiveEMIsPage({this.onEMISelect});

  @override
  State<ActiveEMIsPage> createState() => _ActiveEMIsPageState();
}

class _ActiveEMIsPageState extends State<ActiveEMIsPage> {
  String? _selectedEMIId;

  @override
  Widget build(BuildContext context) {
    final emiData = EMIApplication.getDummyData();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 28,horizontal: 15),
      child: _buildEMIsTable(emiData, context),
    );
  }

 Widget _buildEMIsTable(
    List<EMIApplication> emiData, BuildContext context) {
  final columns = [
    'Bill ID',
    'Customer',
    'Amount (AED)',
    'EMI/Month (AED)',
    'Tenure',
    'Paid',
    'Status',
    'Next Debit',
    'Action'
  ];

  // flex ratios (change anytime)
  final columnFlex = [1, 2, 1, 1, 1, 1, 1, 1, 1];

  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF1E293B).withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.borderLight),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'All Active Bills',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),

        // Search + Table Container
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                CustomTableHeader(
                  columns: columns,
                  columnFlex: columnFlex,
                ),

                // Table Rows
                ...emiData.map((app) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionsDetailPage(),
                          ),
                        );
                      },
                      child: CustomTableRow(
                        columnFlex: columnFlex,
                        cells: [
                          Text(app.billId, style: tableText),
                          Text(app.customerName, style: boldTableText),
                          Text(app.amount.toStringAsFixed(0), style: tableText),
                          Text(app.emiPerMonth.toStringAsFixed(0),
                              style: tableText),
                          Text(app.tenure, style: tableText),
                          Text("${app.paidMonths}/${app.totalMonths}",
                              style: tableText),
                          StatusBadge(app.status),
                          Text(app.nextDebit, style: tableText),

                          // VIEW BUTTON
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionsDetailPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              minimumSize: Size(0, 30),
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
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

}

