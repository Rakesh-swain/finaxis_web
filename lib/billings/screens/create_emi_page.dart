import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:finaxis_web/billings/models/emi_model.dart';
import 'package:finaxis_web/billings/screens/bill_settlement_page.dart';
import 'package:finaxis_web/billings/screens/emi_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEMIPage extends StatefulWidget {
  final VoidCallback onBack;

  const CreateEMIPage({required this.onBack});

  @override
  State<CreateEMIPage> createState() => _CreateEMIPageState();
}

class _CreateEMIPageState extends State<CreateEMIPage> {
  bool showModal = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // EMI List in Background
        SingleChildScrollView(
          padding: EdgeInsets.all(28),
          child: _buildEMIListView(),
        ),
        // Modal Overlay
        if (showModal)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: _buildCreateEMIModal(),
            ),
          ),
      ],
    );
  }

  Widget _buildEMIListView() {
    final emiData = EMIApplication.getDummyData();
    final columns = [
      'Bill ID',
      'Customer',
      'Amount (AED)',
      'EMI/Month (AED)',
      'Tenure',
      'Paid',
      'Status',
      'Next Debit',
      'Action',
    ];
    final columnFlex = [1, 1, 1, 1, 1, 1, 1, 1, 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Bill Applications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => setState(() => showModal = true),
              icon: Icon(Icons.add),
              label: Text('ADD BILL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
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
                      ...emiData.map((app) {
                        return _buildTableRow(
                          columnFlex: columnFlex,
                          cells: [
                            Text(app.billId, style: tableText),
                            Text(app.customerName, style: boldTableText),
                            Text(app.amount.toStringAsFixed(0), style: tableText),
                            Text(app.emiPerMonth.toStringAsFixed(0), style: tableText),
                            Text(app.tenure, style: tableText),
                            Text('${app.paidMonths}/${app.totalMonths}', style: tableText),
                            _buildStatusBadge(app.status),
                            Text(app.nextDebit, style: tableText),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EMIDetailsPage(
                                      emiData: app,
                                      onBack: () {
                                        Navigator.pop(context);
                                      },
                                    ),
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

  Widget _buildCreateEMIModal() {
    return Dialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📝 New BILL Application',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() => showModal = false),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      border: Border(
                        left: BorderSide(
                          color: AppTheme.primaryBlue,
                          width: 3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ℹ️ Enter bill details and customer information. System will automatically send OFTF consent link and validate DSR/FOIR eligibility.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryBlue.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ..._buildFormFields(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(BillSettlementPage(onBack: (){}));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('✓ EMI Created!\n📨 Consent link sent to customer\n⏳ Awaiting customer approval'),
                          //     backgroundColor: AppTheme.statusActive,
                          //   ),
                          // );
                          setState(() => showModal = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                        ),
                        child: Text('Add Bill'),
                      ),
                      // Expanded(
                      //   child: OutlinedButton(
                      //     onPressed: () => _formKey.currentState?.reset(),
                      //     child: Text('Clear Form'),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fields = [
      {'label': 'Bill ID / Invoice', 'hint': 'INV-00123'},
      {'label': 'Bill Amount (AED)', 'hint': '1200'},
      {'label': 'Customer Name', 'hint': 'Ahmed Al Mansouri'},
      {'label': 'Customer ID / CIF', 'hint': 'CIF001235'},
      {'label': 'Mobile Number', 'hint': '+971 50 123 4567'},
      {'label': 'Email', 'hint': 'customer@example.com'},
      {'label': 'Product / Item', 'hint': 'Samsung 65 inch TV'},
    ];

    return fields.map((field) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field['label']!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textTertiary,
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: TextEditingController(text: field['hint']),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.sidebarBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.borderLight),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

    Widget _buildStatusBadge(String status) {
    final colors = ColorConfig.statusColors;
    final color = colors[status] ?? AppTheme.statusPending;
    return ElevatedButton(
      onPressed: (){},
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        disabledForegroundColor: color,
        disabledBackgroundColor: color.withOpacity(0.2),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        // minimumSize: Size(0, 20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color),
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