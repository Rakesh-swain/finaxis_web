import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:finaxis_web/views/applicant/applicants_view.dart';
import 'package:finaxis_web/views/consent/add_consent_page.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:finaxis_web/widgets/futuristic_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

class ConsentView extends GetView<ApplicantsController> {
  const ConsentView({Key? key}) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981); // Green
      case 'pending':
        return const Color(0xFFF59E0B); // Amber
      case 'expired':
      case 'revoked':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF64748B); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;

      // Theme-aware colors
      final primaryColor = isDarkMode
          ? const Color(0xFF0066CC) // Blue for dark
          : const Color(0xFF1E3A8A); // Navy for light

      final textColor = isDarkMode
          ? const Color(0xFFCBD5E1) // Light for dark theme
          : const Color(0xFF0F172A); // Dark for light theme

      final subtitleColor = isDarkMode
          ? const Color(0xFF94A3B8) // Slate for dark
          : const Color(0xFF64748B); // Mist gray for light

      final cardBgColor = isDarkMode
          ? const Color(0xFF1E293B) // Dark navy for dark theme
          : Colors.white; // White for light

      final dividerColor = isDarkMode
          ? const Color(0xFF334155) // Dark border
          : const Color(0xFFE2E8F0); // Light border

      return FuturisticLayout(
        selectedIndex: 2, // Consents section
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
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Add Consent',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (controller.filtered.isEmpty) {
            return Center(
              child: Text(
                'No applicants found',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dividerColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(isDarkMode ? 0.1 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Data Access Consents',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Manage customer consent for data access and processing.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Futuristic Data Table
                    SizedBox(
                      height: 500,
                      child: Obx(
                        () => FuturisticTable(
                          columns: [
                            const FuturisticTableColumn(
                              title: 'Applicant Name',
                            ),
                            const FuturisticTableColumn(
                              title: 'Application No.',
                            ),
                            const FuturisticTableColumn(
                              title: 'Mobile Number',
                            ),
                            // const FuturisticTableColumn(
                            //   title: 'Status',
                            // ),
                            const FuturisticTableColumn(
                              title: 'Bank Name',
                            ),
                            const FuturisticTableColumn(
                              title: 'Created At',
                            ),
                            const FuturisticTableColumn(
                              title: 'Action',
                              sortable: false,
                            ),
                          ],
                          rows: controller.filtered.map((applicant) {
                            final status = (applicant.mobile?.isEmpty ?? true)
                                ? 'Pending'
                                : 'Active';

                            return FuturisticTableRow(
                              cells: [
                                FuturisticTableCell(
                                  text: applicant.name,
                                  widget: Text(
                                    applicant.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                FuturisticTableCell(
                                  text: applicant.cif,
                                  widget: Text(
                                    applicant.cif,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                FuturisticTableCell(
                                  text: applicant.mobile.isEmpty
                                      ? '_'
                                      : applicant.mobile,
                                  widget: Center(
                                    child: Text(
                                      applicant.mobile.isEmpty
                                          ? '_'
                                          : applicant.mobile,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                // FuturisticTableCell(
                                //   text: status,
                                //   widget: Container(
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 12,
                                //       vertical: 6,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       color: _statusColor(status)
                                //           .withOpacity(0.1),
                                //       border: Border.all(
                                //         color: _statusColor(status)
                                //             .withOpacity(0.4),
                                //       ),
                                //       borderRadius: BorderRadius.circular(20),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Container(
                                //           width: 8,
                                //           height: 8,
                                //           decoration: BoxDecoration(
                                //             color: _statusColor(status),
                                //             shape: BoxShape.circle,
                                //           ),
                                //         ),
                                //         const SizedBox(width: 8),
                                //         Text(
                                //           status,
                                //           style: TextStyle(
                                //             color: _statusColor(status),
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 12,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                FuturisticTableCell(
                                  text: applicant.bankName.isEmpty
                                      ? '_'
                                      : applicant.bankName,
                                  widget: Center(
                                    child: Text(
                                      applicant.bankName.isEmpty
                                          ? '_'
                                          : applicant.bankName,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                FuturisticTableCell(
                                  text: DateFormat('MMM dd, yy')
                                      .format(applicant.lastUpdated),
                                  widget: Text(
                                    DateFormat('MMM dd, yy')
                                        .format(applicant.lastUpdated),
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                FuturisticTableCell(
                                  text: (applicant.mobile?.isEmpty ?? true)
                                      ? 'Pending'
                                      : 'Approved',
                                  widget: SizedBox(
                                    width: 105,
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        (applicant.mobile?.isEmpty ?? true)
                                            ? Icons.hourglass_empty_rounded
                                            : Icons.check_circle,
                                        size: 16,
                                      ),
                                      label: Text(
                                        (applicant.mobile?.isEmpty ?? true)
                                            ? 'Pending'
                                            : 'Approved',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            (applicant.mobile?.isEmpty ?? true)
                                                ? const Color(0xFF64748B)
                                                : primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          isLoading: controller.isLoading.value,
                          emptyMessage: 'No consents found',
                          onRowTap: (index){
                            controller.navigateToDetail(controller.filtered[index].cif);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}