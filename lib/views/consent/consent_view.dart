import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:finaxis_web/views/applicant/applicants_view.dart';
import 'package:finaxis_web/views/consent/add_consent_page.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

class ConsentView extends GetView<ApplicantsController> {
  const ConsentView({Key? key}) : super(key: key);

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
        Tooltip(
          message: 'Add Consent',
          child: InkWell(
            onTap: () => Get.toNamed('/add-consent'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E3A8A).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('Add Consent',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filtered.isEmpty) {
          return const Center(child: Text('No applicants found'));
        }

        return SingleChildScrollView(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Access Consents',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage customer consent for data access and processing.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Applicant Name')),
                         DataColumn(label: Text('Application No.')),
                        DataColumn(label: Text('Mobile Number')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Bank Name')),
                        DataColumn(label: Text('Created At')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: controller.filtered.map((applicant) {
                        // Simulate consent status (replace with real consent data if available)
                        final status = (applicant.mobile?.isEmpty ?? true)
                            ? 'Pending'
                            : 'Active';

                        return DataRow(cells: [
                          DataCell(Text(applicant.name)),
                          DataCell(Text(applicant.cif)),
                          DataCell(Center(child: Text(applicant.mobile.isEmpty? '_' : applicant.mobile))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _statusColor(status).withOpacity(0.1),
                              border: Border.all(
                                  color: _statusColor(status).withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _statusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: _statusColor(status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          DataCell(Center(
                            child: Text(applicant.bankName.isEmpty
                                    ? '_'
                                    : applicant.bankName,),
                          )),
                          DataCell(Text(
                                DateFormat(
                                  'MMM dd, yy',
                                ).format(applicant.lastUpdated),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              )),
                          DataCell(ElevatedButton.icon(
                            onPressed: (applicant.mobile?.isEmpty ?? true)
                                ? null
                                : () =>
                                    controller.navigateToDetail(applicant.cif),
                            icon: Icon(
                              (applicant.mobile?.isEmpty ?? true)
                                  ? Icons.hourglass_empty_rounded
                                  : Icons.auto_stories_rounded,
                              size: 16,
                            ),
                            label: Text(
                              (applicant.mobile?.isEmpty ?? true)
                                  ? 'Pending'
                                  : 'Open',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (applicant.mobile?.isEmpty ?? true)
                                      ? Colors.grey
                                      : themeController
                                          .getThemeData()
                                          .primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
