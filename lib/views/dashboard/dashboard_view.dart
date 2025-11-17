import 'package:finaxis_web/views/dashboard/date_picker.dart';
import 'package:finaxis_web/widgets/animated_kpi_card.dart';
import 'package:finaxis_web/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/futuristic_layout.dart';
import '../../widgets/futuristic_sidebar.dart';
import '../../widgets/futuristic_table.dart';

enum DateFilterType { today, week, month, calendar }

/// 🚀 Executive Dashboard - 2050 Style Premium Console
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return FuturisticLayout(
      selectedIndex: 1, // Dashboard index (AI Chat Hub=0, Dashboard=1)
      pageTitle: 'Good morning AHMED FALASI',
      headerActions: [
        _buildDateFilterSection(context, themeController),
      ],
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: _buildLoadingState(context, themeController));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      // padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Theme.of(context).cardColor,
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
          // 🔹 Filter buttons row
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

          // 🔹 Compact From-To Row (aligned to right)
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
                small: true, // custom flag for smaller size
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
  bool small = false, // new flag
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
        color: isEnabled
            ? Theme.of(context).cardColor
            : Colors.grey.shade200,
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
    final currentDate = isFromDate ? controller.fromDate.value : controller.toDate.value;
    
    DateTime? firstDate;
    DateTime? lastDate;
    
    // Set constraints based on filter type
    if (selectedFilter == DateFilterType.week) {
      // For week, limit to 7 days range
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
        
        // Auto-adjust toDate for week filter
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

  // Use Flutter's built-in date range picker wrapped in a Dialog
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 450,
            maxHeight: 600,
          ),
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

  // Update dates if user selected a range
  if (picked != null) {
    controller.setFromDate(picked.start);
    controller.setToDate(picked.end);
    controller.fetchDashboardData();
  }
}





  /// Build executive metrics with floating cards
  Widget _buildExecutiveMetrics(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final dashboardData = controller.dashboardData.value;
      final selectedFilter = controller.selectedDateFilter.value;
      
      // Define cards based on filter type
      List<Widget> cards = [];
      
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
            '+5.2%',
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
            '+8.3%',
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
            '0%',
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
            '+5.2%',
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
            '+8.3%',
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
            ),
            'Monitor',
            context,
            themeController,
            index: 5,
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
            '+5.2%',
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
            '+8.3%',
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
            ),
            'Monitor',
            context,
            themeController,
            index: 5,
          ),
        ];
      }

      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.9,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        children: cards,
      );
    });
  }

  /// Build floating metric card with animations
  Widget _buildFloatingMetricCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    String percentage,
    BuildContext context,
    ThemeController themeController, {
    required int index,
  }) {
    return FuturisticCard(
          height: 120,
          isElevated: true,
          gradient: gradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Text(
                      percentage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
        Expanded(child: Container())
        // Expanded(child: _buildPipelineFunnel(context, themeController)),
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

  /// Build pipeline funnel
  Widget _buildPipelineFunnel(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final dashboardData = controller.dashboardData.value;
      if (dashboardData == null) return const SizedBox();

      final funnel = dashboardData.funnelStages;

      return FuturisticCard(
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Pipeline',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(funnel.length, (index) {
                    final stage = funnel[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: stage.count.toDouble(),
                          width: 32,
                          gradient: themeController.getPrimaryGradient(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: Theme.of(context).textTheme.labelSmall,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < funnel.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                funnel[index].stage.split(' ').first,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: false,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Colors.grey, width: 1),
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
              ),
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

  /// Build recent applicants futuristic table
  Widget _buildRecentApplicants(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final applicants = controller.filteredApplicants.take(10).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '👥 Recent Applicants',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
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
          SizedBox(
            height: 500,
            child: Obx(
              () => FuturisticTable(
                columns: [
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
                ],
                rows: applicants
                    .map(
                      (applicant) => FuturisticTableRow(
                        cells: [
                          FuturisticTableCell(text: applicant.cif),
                          FuturisticTableCell(text: applicant.name),
                          FuturisticTableCell(
                            text: applicant.creditScore.toString() == '0'
                                ? ''
                                : applicant.creditScore.toString(),
                            widget: applicant.creditScore.toString() == '0'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      applicant.creditScore.toString() == '0'
                                          ? '_'
                                          : applicant.creditScore.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                      applicant.creditScore.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
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
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                    style: const TextStyle(
                                      color: Colors.black,
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
                            text: applicant.bankName.isEmpty
                                ? ''
                                : '5,00,000',
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
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                      '5,00,000',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
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
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(fontSize: 12),
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

// Custom FuturisticCard Widget (if not already defined in your project)
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