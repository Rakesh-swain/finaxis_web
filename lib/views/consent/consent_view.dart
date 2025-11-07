import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../widgets/futuristic_layout.dart';

/// 🌟 2050 Futuristic Consent Management View
class ConsentView extends StatefulWidget {
  const ConsentView({Key? key}) : super(key: key);

  @override
  State<ConsentView> createState() => _ConsentViewState();
}

class _ConsentViewState extends State<ConsentView> with SingleTickerProviderStateMixin {
  late AnimationController _chipCtrl;
  late Animation<double> _chipAnim;

  final List<Map<String, String>> _consentData = [
    {'applicant': 'John Doe', 'cif': 'CIF123456', 'consent_id': 'CNS001', 'status': 'Active', 'expires': '2024-12-31', 'purpose': 'Credit Assessment'},
    {'applicant': 'Jane Smith', 'cif': 'CIF234567', 'consent_id': 'CNS002', 'status': 'Pending', 'expires': '2024-11-30', 'purpose': 'Loan Processing'},
    {'applicant': 'Bob Wilson', 'cif': 'CIF345678', 'consent_id': 'CNS003', 'status': 'Expired', 'expires': '2024-10-15', 'purpose': 'Risk Analysis'},
    {'applicant': 'Alice Brown', 'cif': 'CIF456789', 'consent_id': 'CNS004', 'status': 'Active', 'expires': '2025-01-15', 'purpose': 'Portfolio Review'},
    {'applicant': 'Charlie Davis', 'cif': 'CIF567890', 'consent_id': 'CNS005', 'status': 'Revoked', 'expires': '2024-09-30', 'purpose': 'Credit Monitoring'},
  ];

  @override
  void initState() {
    super.initState();
    _chipCtrl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _chipAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chipCtrl, curve: Curves.easeInOut),
    );
    _chipCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _chipCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
      case 'revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return FuturisticLayout(
      selectedIndex: 3, // Consents section
      pageTitle: 'Consent Management',
      headerActions: [
        _buildHeaderAction(
          icon: Icons.refresh_rounded,
          label: 'Refresh',
          onTap: () => setState(() {}),
          color: themeController.getThemeData().primaryColor,
        ),
        _buildHeaderAction(
          icon: Icons.download_rounded,
          label: 'Export',
          onTap: () => Get.snackbar('Export', 'Export functionality coming soon'),
          color: Colors.blue,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Access Consents',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Manage customer consent for data access and processing. Monitor consent status, expiry dates, and purposes.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Applicant')),
                          DataColumn(label: Text('CIF')),
                          DataColumn(label: Text('Consent ID')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Purpose')),
                          DataColumn(label: Text('Expires')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _consentData.map((c) {
                          return DataRow(cells: [
                            DataCell(Text(c['applicant']!)),
                            DataCell(Text(c['cif']!)),
                            DataCell(Text(c['consent_id']!)),
                            DataCell(
                              AnimatedBuilder(
                                animation: _chipAnim,
                                builder: (context, _) {
                                  final color = _statusColor(c['status']!);
                                  final t = 0.8 + 0.2 * _chipCtrl.value;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12 * t),
                                      border: Border.all(color: color.withOpacity(0.4)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          c['status']!,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            DataCell(Text(c['purpose']!)),
                            DataCell(Text(c['expires']!)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {
                                      // Edit consent logic
                                    },
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    onPressed: () {
                                      // Delete consent logic
                                    },
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ))
                    ],
                  ),
                
              ),
            )
          ].map((card) => card.animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack)
          ).toList(),
        ),
      ),
    );
  }

  /// 🎯 Build header action button
  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Tooltip(
      message: label,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}