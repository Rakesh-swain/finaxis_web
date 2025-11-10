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

/// 🚀 Executive Dashboard - 2050 Style Premium Console
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return FuturisticLayout(
      selectedIndex: 1, // Dashboard index (AI Chat Hub=0, Dashboard=1)
      pageTitle: 'Executive Console',
      headerActions: [
        _buildQuickAIButton(context, themeController),
        _buildThemeSelector(context, themeController),
      ],
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: _buildLoadingState(context, themeController));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎯 Hero Section with Finaxis Branding
              _buildHeroSection(context, themeController),

              const SizedBox(height: 32),

              // 📊 Executive Metrics Row
              _buildExecutiveMetrics(context, themeController),

              const SizedBox(height: 32),

              // 📈 Charts & Analytics Row
              _buildChartsSection(context, themeController),

              const SizedBox(height: 32),

              // 🔍 AI Insights Carousel
              // _buildAIInsightsCarousel(context, themeController),

              // const SizedBox(height: 32),

              // 👥 Recent Applicants Grid (Futuristic)
              _buildRecentApplicants(context, themeController),
            ],
          ),
        );
      }),
    );
  }

  /// Build hero section with Finaxis branding
  Widget _buildHeroSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // 🌟 Dynamic Finaxis Logo with Gradient
          ShaderMask(
                shaderCallback: (bounds) =>
                    themeController.getPrimaryGradient().createShader(bounds),
                child: Text(
                  'FINAXIS',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4.0,
                    fontSize: 35,
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideY(begin: -0.3, end: 0)
              .then()
              .shimmer(duration: 2000.ms, delay: 1000.ms),

          const SizedBox(height: 16),

          // ✨ Animated Subtitle
          SizedBox(
            height: 40,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Executive Financial Intelligence Platform',
                  textStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                  speed: const Duration(milliseconds: 80),
                ),
                TypewriterAnimatedText(
                  'AI-Powered Risk Analysis & Portfolio Management',
                  textStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(seconds: 3),
              displayFullTextOnTap: true,
            ),
          ).animate().fadeIn(duration: 1000.ms, delay: 1200.ms),

          const SizedBox(height: 24),

          // 🔍 Quick AI Chat Bar
          _buildQuickChatBar(context, themeController),
        ],
      ),
    );
  }

  /// Build quick AI chat integration
  Widget _buildQuickChatBar(
    BuildContext context,
    ThemeController themeController,
  ) {
    return FuturisticCard(
          width: 600,
          height: 64,
          padding: const EdgeInsets.all(8),
          onTap: () => Get.toNamed('/ai-chat'),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: themeController.getPrimaryGradient(),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Ask AI about your customer...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: themeController.getThemeData().primaryColor,
                size: 20,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 1800.ms)
        .slideY(begin: 0.3, end: 0);
  }

  /// Build executive metrics with floating cards
  Widget _buildExecutiveMetrics(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final dashboardData = controller.dashboardData.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 1200;
          final crossAxisCount = isLargeScreen ? 5 : 2;

          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            children: [
              _buildFloatingMetricCard(
                'Total Portfolio',
                NumberFormat.currency(
                  symbol: '₹',
                  decimalDigits: 0,
                ).format(dashboardData?.kpis.totalDisbursed ?? 0),
                Icons.account_balance_wallet_rounded,
                themeController.getPrimaryGradient(),
                '+12.5%',
                context,
                themeController,
                index: 0,
              ),
              _buildFloatingMetricCard(
                'Active Consents',
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
              // _buildFloatingMetricCard(
              //   'Risk Score',
              //   '${dashboardData?.kpis.avgCreditScore.toStringAsFixed(1) ?? '0.0'}',
              //   Icons.shield_rounded,
              //   LinearGradient(
              //     colors: [Colors.amber.shade400, Colors.orange.shade500],
              //   ),
              //   'Low Risk',
              //   context,
              //   themeController,
              //   index: 2,
              // ),
              _buildFloatingMetricCard(
                'Pending Consents',
                '${dashboardData?.kpis.pendingConsents ?? 0}',
                Icons.pending_actions_rounded,
                LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                ),
                '-5.2%',
                context,
                themeController,
                index: 3,
              ),
              _buildFloatingMetricCard(
                'Total Applicants',
                '${dashboardData?.kpis.totalApplicants ?? 0}',
                Icons.people_rounded,
                LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade600],
                ),
                '+15 Today',
                context,
                themeController,
                index: 4,
              ),
            ],
          );
        },
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
          height: 100,
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
                    child: Icon(icon, color: Colors.white, size: 24),
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
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
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
        // Portfolio Donut Chart
        Expanded(child: _buildPortfolioChart(context, themeController)),
        const SizedBox(width: 24),
        // Pipeline Funnel
        Expanded(child: _buildPipelineFunnel(context, themeController)),
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
                      centerSpaceRadius: 70,
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
                          // Show only integer labels on Y-axis
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
                    show: false, // ✅ enable grid lines
                    drawVerticalLine: false, // only horizontal grid lines
                    horizontalInterval: 5, // adjust based on your data scale
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

  /// Build AI insights carousel
  Widget _buildAIInsightsCarousel(
    BuildContext context,
    ThemeController themeController,
  ) {
    final insights = [
      {
        'title': '🎯 Portfolio Optimization',
        'description':
            'Consider diversifying high-risk assets by 15% to improve overall portfolio stability',
        'action': 'View Recommendations',
      },
      {
        'title': '📈 Growth Opportunity',
        'description':
            'Emerging market trends suggest potential 8.5% growth in renewable energy loans',
        'action': 'Explore Trends',
      },
      {
        'title': '⚠️ Risk Alert',
        'description':
            '3 applicants require immediate attention due to credit score fluctuations',
        'action': 'Review Alerts',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔮 AI-Powered Insights',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return Container(
                    width: 320,
                    margin: const EdgeInsets.only(right: 16),
                    child: FuturisticCard(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeController
                              .getThemeData()
                              .primaryColor
                              .withOpacity(0.1),
                          themeController
                              .getThemeData()
                              .primaryColor
                              .withOpacity(0.05),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['title']!,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              insight['description']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(height: 1.4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController
                                    .getThemeData()
                                    .primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(insight['action']!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: (index * 300).ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: 0.3, end: 0);
            },
          ),
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
                    title: 'CIF',
                    // icon: Icons.fingerprint_rounded,
                    flex: 1,
                  ),
                  const FuturisticTableColumn(
                    title: 'Name',
                    // icon: Icons.person_rounded,
                    flex: 2,
                  ),
                  const FuturisticTableColumn(
                    title: 'Credit Score',
                    // icon: Icons.star_rounded,
                    flex: 1,
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Score',
                    // icon: Icons.star_rounded,
                    flex: 1,
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Status',
                    // icon: Icons.security_rounded,
                    flex: 1,
                  ),
                  const FuturisticTableColumn(
                    title: 'Bank',
                    // icon: Icons.account_balance_rounded,
                    flex: 2,
                  ),
                  const FuturisticTableColumn(
                    title: 'Action',
                    sortable: false,
                    flex: 1,
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
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
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
                                        Text(
                                          applicant.ragStatus.toUpperCase() ==
                                                  "GREEN"
                                              ? "Low"
                                              : applicant.ragStatus
                                                        .toUpperCase() ==
                                                    "AMBER"
                                              ? "Medium"
                                              : "High",
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
                          FuturisticTableCell(
                            text: applicant.bankName.isEmpty
                                ? ''
                                : applicant.bankName,
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
                                      applicant.bankName.toString(),
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
                                : 'Open',
                            widget: ElevatedButton.icon(
                              onPressed: (applicant.mobile?.isEmpty ?? true)
                                  ? null // disable button if mobile is empty
                                  : () => controller.navigateToApplicantDetail(
                                      applicant.cif,
                                    ),
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

  /// Build quick AI button
  Widget _buildQuickAIButton(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: themeController.getPrimaryGradient(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => Get.toNamed('/ai-chat'),
        icon: const Icon(Icons.smart_toy_rounded, color: Colors.white),
        tooltip: 'Ask AI',
      ),
    );
  }

  /// Build theme selector
  Widget _buildThemeSelector(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(
      () => PopupMenuButton<String>(
        icon: Icon(
          Icons.palette_rounded,
          color: themeController.getThemeData().primaryColor,
        ),
        onSelected: (themeName) => themeController.switchTheme(themeName),
        itemBuilder: (context) =>
            [
                  'Classic Light',
                  'Emerald Luxe',
                  'Royal Gold',
                  'Aurora Green',
                  'Cyber Violet',
                ]
                .map(
                  (theme) => PopupMenuItem(
                    value: theme,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: _getThemeGradient(theme),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(theme),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  /// Get theme gradient preview
  LinearGradient _getThemeGradient(String theme) {
    switch (theme) {
      case 'Classic Light':
        return const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        );
      case 'Emerald Luxe':
        return const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF10B981)],
        );
      case 'Royal Gold':
        return const LinearGradient(
          colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
        );
      case 'Aurora Green':
        return const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF06B6D4)],
        );
      case 'Cyber Violet':
        return const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
        );
      default:
        return const LinearGradient(colors: [Colors.blue, Colors.blueAccent]);
    }
  }

  // Widget _buildSidebar(BuildContext context) {
  //   return FuturisticSidebar(
  //     selectedIndex: 0,
  //     onItemSelected: (index) {
  //       switch (index) {
  //         case 0:
  //           if (Get.currentRoute != '/dashboard') Get.offNamed('/dashboard');
  //           break;
  //         case 1:
  //           Get.offNamed('/consent');
  //           break;
  //         case 2:
  //           Get.offNamed('/applicants');
  //           break;
  //       }
  //     },
  //   );
  // }

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
