import 'package:finaxis_web/widgets/futuristic_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/platform_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/futuristic_layout.dart';

enum DateFilterType { today, week, month, calendar }

/// 🚀 Executive Dashboard - 2050 Style Premium Console
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();

    return FuturisticLayout(
      selectedIndex: 1,
      pageTitle: 'Good morning AHMED FALASI',
      headerActions: [_buildDateFilterSection(context, themeController)],
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: _buildLoadingState(context, themeController));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              const SizedBox(height: 0),
              _buildExecutiveMetrics(
                context,
                themeController,
                platformController,
              ),
              const SizedBox(height: 20),
              _buildChartsSection(context, themeController),
              const SizedBox(height: 20),
              _buildRecentApplicants(
                context,
                themeController,
                platformController,
              ),
=======
              const SizedBox(height: 16),

              // 📅 Date Filter Section
              // _buildDateFilterSection(context, themeController),


              // 📊 Executive Metrics Row
              _buildExecutiveMetrics(context, themeController),

              const SizedBox(height: 20),

              // 📈 Charts & Analytics Row
              _buildChartsSection(context, themeController),

              const SizedBox(height: 20),

              // 👥 Recent Applicants Grid (Futuristic)
              _buildRecentApplicants(context, themeController),
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
            ],
          ),
        );
      }),
    );
  }

  /// Build Date Filter Section
  Widget _buildDateFilterSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final selectedFilter = controller.selectedDateFilter.value;
      final fromDate = controller.fromDate.value;
      final toDate = controller.toDate.value;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ToggleButtons(
                  isSelected: [
                    selectedFilter == DateFilterType.today,
                    selectedFilter == DateFilterType.week,
                    selectedFilter == DateFilterType.month,
                    selectedFilter == DateFilterType.calendar,
                  ],
                  onPressed: (index) {
                    final filterType = DateFilterType.values[index];
                    controller.setDateFilter(filterType);

                    if (filterType == DateFilterType.calendar) {
                      _showCalendarPicker(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: themeController.getThemeData().primaryColor,
                  color: themeController.getThemeData().primaryColor,
                  constraints: const BoxConstraints(
                    minHeight: 36.0,
                    minWidth: 70.0,
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Today'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Week'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Month'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Calendar'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDatePickerCard(
                  context,
                  themeController,
                  'From',
                  fromDate,
                  isEnabled: selectedFilter != DateFilterType.today,
                  onTap: selectedFilter != DateFilterType.today
                      ? () => _showDatePicker(context, true)
                      : null,
                  small: true,
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  color: themeController.getThemeData().primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                _buildDatePickerCard(
                  context,
                  themeController,
                  'To',
                  toDate,
                  isEnabled: selectedFilter != DateFilterType.today,
                  onTap: selectedFilter != DateFilterType.today
                      ? () => _showDatePicker(context, false)
                      : null,
                  small: true,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build Date Picker Card
  Widget _buildDatePickerCard(
    BuildContext context,
    ThemeController themeController,
    String label,
    DateTime date, {
    bool isEnabled = true,
    VoidCallback? onTap,
    bool small = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: small ? 6 : 12,
          horizontal: small ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? Theme.of(context).cardColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: themeController.getThemeData().primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: small ? 14 : 18,
              color: themeController.getThemeData().primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              '${label}: ${DateFormat('dd MMM').format(date)}',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: small ? 13 : 15,
                color: isEnabled
                    ? themeController.getThemeData().primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Date Picker
  Future<void> _showDatePicker(BuildContext context, bool isFromDate) async {
    final selectedFilter = controller.selectedDateFilter.value;
    final currentDate = isFromDate
        ? controller.fromDate.value
        : controller.toDate.value;

    DateTime? firstDate;
    DateTime? lastDate;

    if (selectedFilter == DateFilterType.week) {
      if (isFromDate) {
        firstDate = DateTime(2020);
        lastDate = controller.toDate.value.subtract(const Duration(days: 1));
      } else {
        firstDate = controller.fromDate.value.add(const Duration(days: 1));
        lastDate = controller.fromDate.value.add(const Duration(days: 7));
      }
    } else {
      firstDate = DateTime(2020);
      lastDate = DateTime.now().add(const Duration(days: 365));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.find<ThemeController>().getThemeData().primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isFromDate) {
        controller.setFromDate(picked);

        if (selectedFilter == DateFilterType.week) {
          final newToDate = picked.add(const Duration(days: 6));
          if (newToDate.isAfter(DateTime.now())) {
            controller.setToDate(DateTime.now());
          } else {
            controller.setToDate(newToDate);
          }
        }
      } else {
        controller.setToDate(picked);
      }

      controller.fetchDashboardData();
    }
  }

  /// Show Calendar Range Picker
  Future<void> _showCalendarPicker(BuildContext context) async {
    final theme = Get.find<ThemeController>().getThemeData();

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: controller.fromDate.value,
        end: controller.toDate.value,
      ),
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: theme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black,
                ),
                dialogTheme: DialogThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      controller.setFromDate(picked.start);
      controller.setToDate(picked.end);
      controller.fetchDashboardData();
    }
  }

  /// Build executive metrics - NOW ONLY 3 CARDS
Widget _buildExecutiveMetrics(
    BuildContext context,
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Obx(() {
      final dashboardData = controller.dashboardData.value;
      final selectedFilter = controller.selectedDateFilter.value;

      // Define cards based on filter type and platform
      List<Widget> cards = [];

      if (platformController.isLending) {
        // LENDING PLATFORM CARDS
        if (selectedFilter == DateFilterType.today) {
          // Show only 3 cards for Today
          cards = [
            _buildFloatingMetricCard(
              'Total Consent Requests (Today)',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.people_alt_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Consents Granted (Today)',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.verified_user_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
               'Consents Pending (Today)',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.timer_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
          ];
        } else if (selectedFilter == DateFilterType.week) {
          // Show all 6 cards for Week
          cards = [
            _buildFloatingMetricCard(
             'Total Consent Requests (Week)',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.people_alt_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Consents Granted (Week)',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.verified_user_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
              'Consents Pending (Week)',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.timer_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
<<<<<<< HEAD
            _buildFloatingMetricCard(
               'Total Loans Approved (Week)',
              '${dashboardData?.kpis.totalTransactions.toString()}' ?? '0',
              Icons.swap_horiz_rounded,
              LinearGradient(
                colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
              ),
              context,
              themeController,
              index: 3,
            ),
            _buildFloatingMetricCard(
              'Total Amount Sanctioned (Week)',
              'AED ${NumberFormat('#,###').format(dashboardData?.kpis.totalAmount ?? 0)}',
              Icons.error_outline_rounded,
              LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
              ),
              context,
              themeController,
              index: 4,
            ),
            _buildFloatingMetricCard(
              'Risk Alerts (Week)',
              '${dashboardData?.kpis.openAlerts ?? 0}',
              Icons.warning_amber_rounded,
              LinearGradient(
                colors: [Colors.redAccent.shade400, Colors.red.shade700],
              ),
              context,
              themeController,
              index: 5,
=======
            '0%',
            context,
            themeController,
            index: 2,
          ),
          _buildFloatingMetricCard(
            'Total Loans Approved (Week)',
            '${dashboardData?.kpis.totalTransactions.toString()}' ?? '0',
            Icons.swap_horiz_rounded,
            LinearGradient(
              colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
            ),
            '+12.1%',
            context,
            themeController,
            index: 3,
          ),
          _buildFloatingMetricCard(
            'Total Amount Sanctioned (Week)',
            'AED ${NumberFormat('#,###').format(dashboardData?.kpis.totalAmount ?? 0)}',
            Icons.error_outline_rounded,
            LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700],
            ),
            '+1.4%',
            context,
            themeController,
            index: 4,
          ),
          _buildFloatingMetricCard(
            'Risk Alerts (Week)',
            '${dashboardData?.kpis.openAlerts ?? 0}',
            Icons.warning_amber_rounded,
            LinearGradient(
              colors: [Colors.redAccent.shade400, Colors.red.shade700],
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
            ),
          ];
        } else {
          // Show all 6 cards for Month and Calendar
          cards = [
            _buildFloatingMetricCard(
              'Total Consent Requests (30 Days)',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.people_alt_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Consents Granted (Total Active)',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.verified_user_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
               'Consents Pending Action',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.timer_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
            _buildFloatingMetricCard(
              'Total Loans Approved (Current Month)',
              '${dashboardData?.kpis.totalTransactions.toString()}' ?? '0',
              Icons.swap_horiz_rounded,
              LinearGradient(
                colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
              ),
              context,
              themeController,
              index: 3,
            ),
            _buildFloatingMetricCard(
              'Total Amount Sanctioned',
              'AED ${NumberFormat('#,###').format(dashboardData?.kpis.totalAmount ?? 0)}',
              Icons.error_outline_rounded,
              LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
              ),
              context,
              themeController,
              index: 4,
            ),
            _buildFloatingMetricCard(
              'Risk Alerts',
              '${dashboardData?.kpis.openAlerts ?? 0}',
              Icons.warning_amber_rounded,
              LinearGradient(
                colors: [Colors.redAccent.shade400, Colors.red.shade700],
              ),
              context,
              themeController,
              index: 5,
            ),
          ];
        }
      } else {
        // BILLING PLATFORM CARDS - EMI METRICS
        if (selectedFilter == DateFilterType.today) {
          cards = [
            _buildFloatingMetricCard(
              'Total EMIs',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.receipt_long_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Active EMIs',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.check_circle_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
              'Pending EMIs',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.hourglass_empty_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
<<<<<<< HEAD
          ];
        } else if (selectedFilter == DateFilterType.week) {
          cards = [
            _buildFloatingMetricCard(
              'Total EMIs',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.receipt_long_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Active EMIs',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.check_circle_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
              'Pending EMIs',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.hourglass_empty_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
=======
            '0%',
            context,
            themeController,
            index: 2,
          ),
          _buildFloatingMetricCard(
            'Total Loans Approved (Current Month)',
             '${dashboardData?.kpis.totalTransactions.toString()}' ?? '0',
            Icons.swap_horiz_rounded,
            LinearGradient(
              colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
            ),
            '+12.1%',
            context,
            themeController,
            index: 3,
          ),
          _buildFloatingMetricCard(
            'Total Amount Sanctioned',
           'AED ${NumberFormat('#,###').format(dashboardData?.kpis.totalAmount ?? 0)}',
            Icons.error_outline_rounded,
            LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700],
            ),
            '+1.4%',
            context,
            themeController,
            index: 4,
          ),
          _buildFloatingMetricCard(
            'Risk Alerts',
            '${dashboardData?.kpis.openAlerts ?? 0}',
            Icons.warning_amber_rounded,
            LinearGradient(
              colors: [Colors.redAccent.shade400, Colors.red.shade700],
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
            ),
          ];
        } else if (selectedFilter == DateFilterType.month) {
          cards = [
            _buildFloatingMetricCard(
              'Total EMIs',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.receipt_long_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Active EMIs',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.check_circle_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
              'Pending EMIs',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.hourglass_empty_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
          ];
        } else if (selectedFilter == DateFilterType.calendar) {
          cards = [
            _buildFloatingMetricCard(
              'Total EMIs',
              '${dashboardData?.kpis.activeCustomers ?? 0}',
              Icons.receipt_long_rounded,
              LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              context,
              themeController,
              index: 0,
            ),
            _buildFloatingMetricCard(
              'Active EMIs',
              '${dashboardData?.kpis.activeConsents ?? 0}',
              Icons.check_circle_rounded,
              LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              context,
              themeController,
              index: 1,
            ),
            _buildFloatingMetricCard(
              'Pending EMIs',
              '${dashboardData?.kpis.expiringConsents ?? 0}',
              Icons.hourglass_empty_rounded,
              LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              context,
              themeController,
              index: 2,
            ),
          ];
        }
      }

      return LayoutBuilder(
        builder: (context, constraints) {
    int crossAxisCount;
    double width = constraints.maxWidth;

    if (width < 600) {
      crossAxisCount = 1;
    } else if (width < 900) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.9,
      crossAxisSpacing: 12,
      mainAxisSpacing: 0,
      children: cards,
    );

        }
      );
    });
  }

  /// Build floating metric card with animations - no overflow
  Widget _buildFloatingMetricCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    BuildContext context,
    ThemeController themeController, {
    required int index,
  }) {
    return SingleChildScrollView(
      child: FuturisticCard(
        height: 150,
        isElevated: true,
        gradient: gradient,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (index * 200).ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, delay: 800.ms);
  }
  /// Build charts section
  Widget _buildChartsSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPortfolioChart(context, themeController)),
        const SizedBox(width: 24),
        Expanded(child: Container()),
      ],
    );
  }

  /// Build portfolio donut chart
  Widget _buildPortfolioChart(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final dashboardData = controller.dashboardData.value;
      if (dashboardData == null) return const SizedBox();

      final rag = dashboardData.ragSummary;

      return FuturisticCard(
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Portfolio Distribution',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          color: AppTheme.ragGreen,
                          value: rag.green.toDouble(),
                          title:
                              '${((rag.green / rag.total) * 100).toStringAsFixed(0)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        PieChartSectionData(
                          color: AppTheme.ragAmber,
                          value: rag.amber.toDouble(),
                          title:
                              '${((rag.amber / rag.total) * 100).toStringAsFixed(0)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        PieChartSectionData(
                          color: AppTheme.ragRed,
                          value: rag.red.toDouble(),
                          title:
                              '${((rag.red / rag.total) * 100).toStringAsFixed(0)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem(AppTheme.ragGreen, 'Low Risk', rag.green),
                _buildLegendItem(AppTheme.ragAmber, 'Medium Risk', rag.amber),
                _buildLegendItem(AppTheme.ragRed, 'High Risk', rag.red),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build legend item
  Widget _buildLegendItem(Color color, String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($value)',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// Build recent applicants table
  Widget _buildRecentApplicants(
    BuildContext context,
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Obx(() {
      final applicants = controller.filteredApplicants.take(10).toList();
      final platform = platformController.currentPlatform.value;
      final isLending = platform == PlatformType.lending;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                platformController.isBilling
                    ? '💳 Recent Payments'
                    : '👥 Recent Applicants',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isLending
                      ? const Color(0xFF1E3A8A) // Navy for light
                      : const Color(0xFFFFFFFF),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/applicants'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('View All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeController.getThemeData().primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Your existing table code here
          SizedBox(
            height: 500,
            child: Obx(
              () => FuturisticTable(
                columns: [
<<<<<<< HEAD
                  const FuturisticTableColumn(title: 'Application No.'),
                  const FuturisticTableColumn(title: 'Name'),
                
                  const FuturisticTableColumn(title: 'Finaxis Credit Score'),
                  const FuturisticTableColumn(title: 'Risk Status'),
                  const FuturisticTableColumn(title: 'Loan Amount'),
                    const FuturisticTableColumn(title: 'DateTime'),
                  const FuturisticTableColumn(title: 'Status', sortable: false),
=======
                  const FuturisticTableColumn(
                    title: 'Application No.',
                  ),
                  const FuturisticTableColumn(
                    title: 'Name',
                  ),
                  const FuturisticTableColumn(
                    title: 'AECB Score',
                  ),
                  const FuturisticTableColumn(
                    title: 'Finaxis Credit Score',
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Status',
                  ),
                  const FuturisticTableColumn(
                    title: 'Loan Amount',
                  ),
                  const FuturisticTableColumn(
                    title: 'Status',
                    sortable: false,
                  ),
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                ],
                rows: applicants
                    .map(
                      (applicant) => FuturisticTableRow(
                        cells: [
                          FuturisticTableCell(text: applicant.cif),
                          FuturisticTableCell(text: applicant.name),
                          // FuturisticTableCell(
                          //   text: applicant.creditScore.toString() == '0'
                          //       ? ''
                          //       : applicant.creditScore.toString(),
                          //   widget: applicant.creditScore.toString() == '0'
                          //       ? Container(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8,
                          //             vertical: 4,
                          //           ),
                          //           child: Text(
                          //             applicant.creditScore.toString() == '0'
                          //                 ? '_'
                          //                 : applicant.creditScore.toString(),
                          //             style: TextStyle(
                          //               color: isLending
                          //                   ? const Color(0xFF1E3A8A)
                          //                   : const Color(0xFFFFFFFF),
                          //               fontWeight: FontWeight.w600,
                          //               fontSize: 13,
                          //             ),
                          //           ),
                          //         )
                          //       : Container(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8,
                          //             vertical: 4,
                          //           ),
                          //           decoration: BoxDecoration(
                          //             gradient: themeController
                          //                 .getPrimaryGradient(),
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //           child: Text(
                          //             applicant.creditScore.toString(),
                          //             style: const TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w600,
                          //               fontSize: 13,
                          //             ),
                          //           ),
                          //         ),
                          // ),
                          FuturisticTableCell(
                            text: applicant.riskScore.toString() == '0'
                                ? ''
                                : applicant.riskScore.toString(),
                            widget: applicant.riskScore.toString() == '0'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      applicant.riskScore.toString() == '0'
                                          ? '_'
                                          : applicant.riskScore.toString(),
                                      style: TextStyle(
                                        color: isLending
                                            ? const Color(0xFF1E3A8A)
                                            : const Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: themeController
                                          .getPrimaryGradient(),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      applicant.riskScore.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
                          FuturisticTableCell(
                            text: applicant.ragStatus.isEmpty
                                ? ''
                                : applicant.ragStatus,
                            widget: applicant.ragStatus.isEmpty
                                ? Text(
                                    applicant.ragStatus.isEmpty
                                        ? '_'
                                        : applicant.ragStatus,
                                    style: TextStyle(
                                      color: isLending
                                          ? const Color(0xFF1E3A8A)
                                          : const Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.getRagColor(
                                        applicant.ragStatus,
                                      ),
                                      // borderRadius: BorderRadius.circular(12),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.getRagColor(
                                          applicant.ragStatus,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppTheme.getRagColor(
                                              applicant.ragStatus,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Text(
                                        //   applicant.ragStatus.toUpperCase() ==
                                        //           "GREEN"
                                        //       ? "Low"
                                        //       : applicant.ragStatus
                                        //                 .toUpperCase() ==
                                        //             "AMBER"
                                        //       ? "Medium"
                                        //       : "High",
                                        //   style: TextStyle(
                                        //     color: AppTheme.getRagColor(
                                        //       applicant.ragStatus,
                                        //     ),
                                        //     fontWeight: FontWeight.w700,
                                        //     fontSize: 11,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                          ),
                          FuturisticTableCell(
<<<<<<< HEAD
                            text: applicant.bankName.isEmpty ? '' : '150,000',
=======
                            text: applicant.bankName.isEmpty
                                ? ''
                                : '5,00,000',
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                            widget: applicant.creditScore.toString() == '0'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      applicant.bankName.toString() == ''
                                          ? '_'
                                          : applicant.bankName.toString(),
                                      style: TextStyle(
                                        color: isLending
                                            ? const Color(0xFF1E3A8A)
                                            : const Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: themeController
                                          .getPrimaryGradient(),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
<<<<<<< HEAD
                                      '150,000',
=======
                                      '5,00,000',
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
<<<<<<< HEAD
                                                    FuturisticTableCell(
                            text: DateFormat(
                              'MMM dd, yy',
                            ).format(applicant.lastUpdated),
                            widget: Text(
                              DateFormat(
                                'MMM dd, yy',
                              ).format(applicant.lastUpdated),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ),
                                                    FuturisticTableCell(
                            text: applicant.status,
                            widget: SizedBox(
                              width: 105, 
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    () => controller.navigateToApplicantDetail(
                                      applicant.cif,
                                    ),
                                icon: Icon(
                                  applicant.status == "Approved"
                                      ? Icons.check_box
                                      : applicant.status == "Pending"
                                      ? Icons.hourglass_empty_rounded
                                      : applicant.status == "New"?Icons.new_label:Icons.cancel,
                                  size: 16,
=======
                          FuturisticTableCell(
                            text: applicant.mobile?.isEmpty ?? true
                                ? 'Pending'
                                : 'Approved',
                            widget: ElevatedButton.icon(
                              onPressed: (applicant.mobile?.isEmpty ?? true)
                                  ? null
                                  : () => controller.navigateToApplicantDetail(
                                      applicant.cif,
                                    ),
                              icon: Icon(
                                (applicant.mobile?.isEmpty ?? true)
                                    ? Icons.hourglass_empty_rounded
                                    : Icons.check_box,
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
                                    ? Colors.grey
                                    : themeController
                                          .getThemeData()
                                          .primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                                ),
                                label: Text(applicant.status),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: applicant.status == "Pending"
                                      ? Colors.grey
                                      : applicant.status == "Rejected"?Colors.red:themeController
                                            .getThemeData()
                                            .primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                onRowTap: (index) =>
                    controller.navigateToApplicantDetail(applicants[index].cif),
                isLoading: controller.isLoading.value,
                emptyMessage: 'No recent applicants found',
                sortColumnIndex:
                    controller.recentApplicantsSortColumnIndex.value,
                sortAscending: controller.recentApplicantsSortAscending.value,
                onSort: (columnIndex, ascending) =>
                    controller.sortRecentApplicants(columnIndex, ascending),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Build loading state
  Widget _buildLoadingState(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: themeController.getPrimaryGradient(),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 40,
              ),
            )
            .animate()
            .scale(duration: 800.ms)
            .then()
            .shimmer(
              duration: 1500.ms,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.3),
              ],
            ),
        const SizedBox(height: 24),
        Text(
          'Loading Executive Console...',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
      ],
    );
  }
}

/// 🎨 Futuristic Card
class FuturisticCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isElevated;
  final LinearGradient? gradient;
  final VoidCallback? onTap;

  const FuturisticCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.isElevated = false,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Theme.of(context).cardColor : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
