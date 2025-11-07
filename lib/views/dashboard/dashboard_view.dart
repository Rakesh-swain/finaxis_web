import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_sidebar.dart';
import '../../widgets/animated_kpi_card.dart';
import '../../widgets/responsive_layout.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(context),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Navbar with Theme Selector
                _buildTopNavbar(context, themeController),
                // Content
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      decoration: BoxDecoration(
                        gradient: themeController.getBackgroundGradient(),
                      ),
                      child: SingleChildScrollView(
                        padding: Responsive.getPadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildKpiCards(context, themeController),
                            SizedBox(height: Responsive.getSpacing(context)),
                            _buildChartsRow(context, themeController),
                            SizedBox(height: Responsive.getSpacing(context)),
                            _buildApplicantsTable(context),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return AnimatedSidebar(
      selectedIndex: 0,
      onItemSelected: (index) {
        switch (index) {
          case 0:
            if (Get.currentRoute != '/dashboard') Get.offNamed('/dashboard');
            break;
          case 1:
            Get.offNamed('/consent');
            break;
          case 2:
            Get.offNamed('/applicants');
            break;
        }
      },
    );
  }

  Widget _buildTopNavbar(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Title
          Text(
            'Finaxis',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 24),
          // Search Bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  hintText: 'Search applicants, consents or reports',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Notifications with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Theme Selector Dropdown
          Obx(() => _buildThemeDropdown(context, themeController)),
          const SizedBox(width: 16),
          // Profile
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDropdown(BuildContext context, ThemeController themeCtrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: themeCtrl.currentThemeName,
          isDense: true,
          icon: Icon(
            Icons.palette_outlined,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          items: ThemeController.availableThemes.map((theme) {
            return DropdownMenuItem(
              value: theme,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getThemeIcon(theme),
                  const SizedBox(width: 6),
                  Text(theme),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) themeCtrl.switchTheme(value);
          },
        ),
      ),
    );
  }

  Icon _getThemeIcon(String theme) {
    switch (theme) {
      case 'Light':
        return const Icon(Icons.wb_sunny, size: 14, color: Colors.orange);
      case 'Dark':
        return const Icon(
          Icons.nightlight_round,
          size: 14,
          color: Colors.indigo,
        );
      case 'Gold':
        return const Icon(Icons.star, size: 14, color: Colors.amber);
      case 'Emerald':
        return const Icon(Icons.eco, size: 14, color: Colors.green);
      case 'Royal':
        return const Icon(Icons.shield, size: 14, color: Colors.deepPurple);
      default:
        return const Icon(Icons.palette, size: 14);
    }
  }

  Widget _buildKpiCards(BuildContext context, ThemeController themeCtrl) {
    final data = controller.dashboardData.value;
    if (data == null) return const SizedBox();

    final crossAxisCount = Responsive.getColumns(context, max: 4);
    final chartColors = themeCtrl.getChartColors();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: Responsive.getSpacing(context),
      crossAxisSpacing: Responsive.getSpacing(context),
      childAspectRatio: 1.6,
      children: [
        AnimatedKpiCard(
          title: 'Total Applicants',
          value: data.kpis.totalApplicants.toString(),
          percentage: data.kpis.totalApplicantsMoM,
          icon: Icons.people_alt_rounded,
          gradient: LinearGradient(
            colors: [chartColors[0], chartColors[1]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        AnimatedKpiCard(
          title: 'Active Consents',
          value: data.kpis.activeConsents.toString(),
          percentage: data.kpis.activeConsentsMoM,
          icon: Icons.verified_user_rounded,
          gradient: LinearGradient(
            colors: [chartColors[1], chartColors[2]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        AnimatedKpiCard(
          title: 'Avg Credit Score',
          value: data.kpis.avgCreditScore.toStringAsFixed(0),
          percentage: data.kpis.avgCreditScoreMoM,
          icon: Icons.star_rate_rounded,
          gradient: LinearGradient(
            colors: [chartColors[2], chartColors[3]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        AnimatedKpiCard(
          title: 'Total Disbursed (YTD)',
          value: NumberFormat.compactCurrency(
            symbol: '₹',
            decimalDigits: 1,
          ).format(data.kpis.totalDisbursed),
          percentage: data.kpis.totalDisbursedMoM,
          icon: Icons.attach_money_rounded,
          gradient: AppTheme.copperGradient,
        ),
      ],
    );
  }

  Widget _buildChartsRow(BuildContext context, ThemeController themeCtrl) {
    final dashboard = controller.dashboardData.value;
    if (dashboard == null) return const SizedBox();

    final rag = dashboard.ragSummary;
    final funnel = dashboard.funnelStages;
    final chartColors = themeCtrl.getChartColors();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Donut Chart: RAG Distribution
        Expanded(
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Portfolio Distribution',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: AspectRatio(
                      aspectRatio:
                          1, // ✅ ensures equal height and width (perfect circle)
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: [
                            PieChartSectionData(
                              color: AppTheme.ragGreen,
                              value: rag.green.toDouble(),
                              title:
                                  '${((rag.green / rag.total) * 100).toStringAsFixed(0)}%',
                              radius: 80,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            PieChartSectionData(
                              color: AppTheme.ragAmber,
                              value: rag.amber.toDouble(),
                              title:
                                  '${((rag.amber / rag.total) * 100).toStringAsFixed(0)}%',
                              radius: 80, // ✅ keep consistent radius
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            PieChartSectionData(
                              color: AppTheme.ragRed,
                              value: rag.red.toDouble(),
                              title:
                                  '${((rag.red / rag.total) * 100).toStringAsFixed(0)}%',
                              radius: 80,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        swapAnimationDuration: AppTheme.normalAnimation,
                        swapAnimationCurve: Curves.easeOutCubic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _legendDot(AppTheme.ragGreen, 'Low Risk (${rag.green})'),
                      _legendDot(
                        AppTheme.ragAmber,
                        'Medium Risk (${rag.amber})',
                      ),
                      _legendDot(AppTheme.ragRed, 'High Risk (${rag.red})'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Bar Chart: Applicant Funnel
        Expanded(
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Funnel',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final label = funnel[group.x.toInt()].stage;
                              return BarTooltipItem(
                                '$label\n',
                                Theme.of(context).textTheme.labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: NumberFormat.compact().format(
                                      rod.toY,
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx >= 0 && idx < funnel.length) {
                                  final label = funnel[idx].stage
                                      .split(' ')
                                      .first;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              reservedSize: 32,
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(funnel.length, (i) {
                          final count = funnel[i].count.toDouble();
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: count,
                                width: 18,
                                gradient: LinearGradient(
                                  colors: [chartColors[0], chartColors[1]],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                      ),
                      swapAnimationDuration: AppTheme.normalAnimation,
                      swapAnimationCurve: Curves.easeOutCubic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildApplicantsTable(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Applicants',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: controller.selectedRagFilter.value == 'all',
                        onSelected: (_) => controller.filterByRag('all'),
                      ),
                      FilterChip(
                        label: const Text('Green'),
                        selected: controller.selectedRagFilter.value == 'green',
                        onSelected: (_) => controller.filterByRag('green'),
                      ),
                      FilterChip(
                        label: const Text('Amber'),
                        selected: controller.selectedRagFilter.value == 'amber',
                        onSelected: (_) => controller.filterByRag('amber'),
                      ),
                      FilterChip(
                        label: const Text('Red'),
                        selected: controller.selectedRagFilter.value == 'red',
                        onSelected: (_) => controller.filterByRag('red'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('CIF')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Credit Score')),
                    DataColumn(label: Text('Risk Score')),
                    DataColumn(label: Text('RAG Status')),
                    DataColumn(label: Text('Bank')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: controller.filteredApplicants.map((applicant) {
                    return DataRow(
                      cells: [
                        DataCell(Text(applicant.cif)),
                        DataCell(Text(applicant.name)),
                        DataCell(Text(applicant.creditScore.toString())),
                        DataCell(Text(applicant.riskScore.toStringAsFixed(2))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.getRagColor(
                                applicant.ragStatus,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.getRagColor(
                                  applicant.ragStatus,
                                ).withOpacity(0.4),
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
                                Text(
                                  applicant.ragStatus.toUpperCase(),
                                  style: TextStyle(
                                    color: AppTheme.getRagColor(
                                      applicant.ragStatus,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Text(applicant.bankName)),
                        DataCell(
                          ElevatedButton(
                            onPressed: () => controller
                                .navigateToApplicantDetail(applicant.cif),
                            child: const Text('View'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
