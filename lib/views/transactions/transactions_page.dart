import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:finaxis_web/views/applicant/applicants_view.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:finaxis_web/widgets/futuristic_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends GetView<ApplicantsController> {
  const TransactionsPage({Key? key}) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
      case 'completed':
      case 'approved':
        return const Color(0xFF10B981); // Green
      case 'pending':
      case 'processing':
        return const Color(0xFFF59E0B); // Amber
      case 'failed':
      case 'rejected':
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
      final platform = platformController.currentPlatform.value;
      final isLending = platform == PlatformType.lending;

      // Platform and Theme-aware colors
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
          : const Color(0xFFF8FAFC); // Soft white for light

      final dividerColor = isDarkMode
          ? const Color(0xFF334155) // Dark border
          : const Color(0xFFE2E8F0); // Light border

      final rowBgColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;

      final headingBgColor = isDarkMode
          ? const Color(0xFF0F172A)
          : primaryColor.withOpacity(0.08);

      return FuturisticLayout(
        selectedIndex: 4, // Transactions section
        pageTitle: 'Transactions',
        headerActions: [
          Tooltip(
            message: 'Add Transaction',
            child: InkWell(
              onTap: () => Get.toNamed('/add-transaction'),
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
                      'Add Transaction',
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
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (controller.filtered.isEmpty) {
            return Center(
              child: Text(
                'No transactions found',
                style: TextStyle(color: subtitleColor, fontSize: 16),
              ),
            );
          }

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor, width: 1),
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
                      'Transactions Overview',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      isLending
                          ? 'View and manage all financial transactions across applicants.'
                          : 'View and manage all payment transactions and billing records.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Data Table
                    SizedBox(
                      height: 500,
                      child: Obx(
                        () => FuturisticTable(
                          columns: [
                            const FuturisticTableColumn(
                              title: 'Applicant Name',
                            ),
                            const FuturisticTableColumn(
                              title: 'Transaction Ref No.',
                            ),
                            const FuturisticTableColumn(title: 'Amount'),
                            const FuturisticTableColumn(title: 'Status'),
                            const FuturisticTableColumn(title: 'Created At'),
                          ],
                          rows: controller.filtered
                              .where(
                                (applicant) => applicant.cif == "CIF001235",
                              )
                              .map((applicant) {
                                final status = 'Successful';
                                final amount = 'AED 150,000';
                                final refNo = applicant.cif;

                                return FuturisticTableRow(
                                  cells: [
                                    FuturisticTableCell(
                                      text: applicant.name,
                                      widget: Text(
                                        applicant.name,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    FuturisticTableCell(
                                      text: refNo,
                                      widget: Text(
                                        refNo,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    FuturisticTableCell(
                                      text: amount,
                                      widget: Text(
                                        amount,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    FuturisticTableCell(
                                      text: status,
                                      widget: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusColor(
                                            status,
                                          ).withOpacity(0.1),
                                          border: Border.all(
                                            color: _statusColor(
                                              status,
                                            ).withOpacity(0.4),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                            const SizedBox(width: 8),
                                            Text(
                                              status,
                                              style: TextStyle(
                                                color: _statusColor(status),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    FuturisticTableCell(
                                      text: DateFormat(
                                        'MMM dd, yy',
                                      ).format(applicant.lastUpdated),
                                      widget: Text(
                                        DateFormat(
                                          'MMM dd, yy',
                                        ).format(applicant.lastUpdated),
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                          onRowTap: (index) => Get.toNamed(
                            '/transactions/${controller.filtered[index].cif}',
                          ),
                          isLoading: controller.isLoading.value,
                          emptyMessage: 'No recent transactions found',
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
