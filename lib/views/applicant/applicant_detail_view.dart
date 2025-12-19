import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:html' as html;
import 'package:finaxis_web/score_card.dart';
import 'package:finaxis_web/views/applicant/balance.dart';
import 'package:finaxis_web/views/applicant/balance_trend.dart';
import 'package:finaxis_web/views/applicant/chart_screen.dart';
import 'package:finaxis_web/views/applicant/customer_ai_chatview.dart';
import 'package:finaxis_web/views/applicant/spend_pattern_chart.dart';
import 'package:finaxis_web/views/dashboard/assessment_dashboard_view.dart';
import 'package:finaxis_web/views/powerbi/powerbi.dart';
import 'package:finaxis_web/views/powerbi/powerbi_page.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/applicant_detail_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_theme.dart';

/// 🌟 2050 Book-Open Applicant Detail View with Dark Theme Support
class ApplicantDetailView extends GetView<ApplicantDetailController> {
  const ApplicantDetailView({super.key});

  Future<void> downloadAnalyticsPdf() async {
    try {
      final ByteData data = await rootBundle.load(
        'assets/analytics_report.pdf',
      );
      final Uint8List bytes = data.buffer.asUint8List();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'Finaxis_Analytics_Report.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
      Get.snackbar(
        'Download Started',
        'Your analytics report is being downloaded.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Download Failed',
        'Could not download report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: _buildBackgroundGradient(themeController, isDarkMode),
          ),
          child: Column(
            children: [
              _buildCustomHeader(context, themeController, isDarkMode),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: _buildLoadingSpinner(themeController));
                  }
                  final detail = controller.currentApplicant.value;
                  if (detail == null) {
                    return Center(
                      child: _buildEmptyState(themeController, isDarkMode),
                    );
                  }
                  return _buildBookOpenLayout(
                    context,
                    detail,
                    themeController,
                    isDarkMode,
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBookOpenLayout(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                _buildHeroProfileCard(
                      context,
                      detail,
                      themeController,
                      isDarkMode,
                    )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child:
                      _buildEnhancedTabContent(
                            detail,
                            themeController,
                            isDarkMode,
                          )
                          .animate()
                          .fadeIn(duration: 1000.ms, delay: 400.ms)
                          .slideX(
                            begin: -0.2,
                            end: 0,
                            curve: Curves.easeOutBack,
                          ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildVerticalSpinableTabs(themeController, isDarkMode)
                      .animate()
                      .fadeIn(duration: 1200.ms, delay: 600.ms)
                      .slideX(begin: 0.5, end: 0, curve: Curves.easeOutBack)
                      .scale(duration: 800.ms, delay: 800.ms),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildHeroProfileCard(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: _buildProfileGradient(themeController),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: 15,
          ),
          child: Row(
            children: [
              _buildAnimatedAvatar(detail, themeController),
              const SizedBox(width: 32),
              Expanded(
                child: _buildProfileInfo(
                  context,
                  detail,
                  themeController,
                  isDarkMode,
                ),
              ),
              detail.applicant.riskScore == 0?Container():_buildFloatingScoreCards(detail, themeController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAvatar(dynamic detail, ThemeController themeController) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: themeController.getThemeData().primaryColor.withOpacity(
                  0.3,
                ),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: themeController.getPrimaryGradient(),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  detail.applicant.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .scale(duration: 1200.ms, curve: Curves.elasticOut)
            .fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildProfileInfo(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                  detail.applicant.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 200.ms)
                .slideX(begin: -0.3, end: 0),
            const SizedBox(width: 15),
            _pillChip(Icons.badge_outlined, detail.applicant.cif),
          ],
        ),
        const SizedBox(height: 20),
        _buildQuickChatBar(context, themeController, detail),
      ],
    );
  }

  Widget _buildQuickChatBar(
    BuildContext context,
    ThemeController themeController,
    dynamic detail,
  ) {
    return FuturisticCard(
          width: 380,
          height: 55,
          padding: const EdgeInsets.all(8),
          // onTap: () => Get.to(
          //   CustomerAiChatView(
          //     customerId: '',
          //     customerName: detail.applicant.name,
          //   ),
          // ),
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

  Widget _buildFloatingScoreCards(
    dynamic detail,
    ThemeController themeController,
  ) {
    print(detail.applicant.ragStatus);
    return Column(
      children: [
        Row(
          children: [
            // _buildFloatingScoreCard(
            //   'AECB Score',
            //   detail.applicant.creditScore.toString(),
            //   const Color.fromARGB(255, 161, 252, 202),
            //   themeController,
            // ),
            const SizedBox(width: 16),
            _buildFloatingScoreCard(
              'Finaxis Credit Score',
              detail.applicant.riskScore.toString(),
              Colors.amber,
              themeController,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _pillChip(
              Icons.shield_outlined,
              'Risk: ${detail.applicant.ragStatus == "amber" ? "Medium" :detail.applicant.ragStatus == "green" ? "Low" :"High"}',
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms).scale(),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingScoreCard(
    String title,
    String value,
    Color color,
    ThemeController themeController,
  ) {
    return Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 247, 246, 246).withOpacity(0.15),
                const Color.fromARGB(255, 253, 253, 253).withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .scale(duration: 800.ms, delay: 600.ms, curve: Curves.elasticOut)
        .fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildVerticalSpinableTabs(
    ThemeController themeController,
    bool isDarkMode,
  ) {
    final applicantName = controller.applicantDetail!.applicant.name;

    final tabs = [
      {
        'icon': Icons.account_circle_outlined,
        'label': 'General',
        'color': Colors.blue,
      },
      {
        'icon': Icons.stacked_line_chart,
        'label': 'Balance Analysis',
        'color': Colors.green,
      },
      {
        'icon': Icons.analytics_outlined,
        'label': 'Transaction Analysis',
        'color': Colors.deepPurple,
      },
      {
        'icon': Icons.receipt_long_outlined,
        'label': 'Expense',
        'color': Colors.orange,
      },
      {
        'icon': Icons.warning_amber_rounded,
        'label': 'Alarming Transactions',
        'color': Colors.redAccent,
      },
      {'icon': Icons.percent_outlined, 'label': 'FOIR', 'color': Colors.teal},
      {'icon': Icons.calculate_outlined, 'label': 'DSR', 'color': Colors.brown},
      // {
      //   'icon': Icons.moving_outlined,
      //   'label': 'Cashflow',
      //   'color': Colors.indigo,
      // },
    ];

    // If RAKESH → keep only first tab
    final visibleTabs = applicantName != "Mohammed Al Mansoori"
        ? tabs.sublist(0, 1)
        : tabs;

    return Container(
      height: 600,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: visibleTabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;

          final isSelected = controller.selectedTabIndex.value == index;

          return _buildNormalTabItem(
            index,
            tab,
            isSelected,
            themeController,
            isDarkMode,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNormalTabItem(
    int index,
    Map<String, dynamic> tab,
    bool isSelected,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (tab['color'] as Color),
                        (tab['color'] as Color).withOpacity(0.8),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [Colors.grey.shade800, Colors.grey.shade700]
                          : [Colors.white, const Color(0xFFF8F9FA)],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDarkMode
                          ? Colors.grey.shade600
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: (tab['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (tab['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      tab['icon'] as IconData,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : (tab['color'] as Color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tab['label'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF374151)),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPageTransition(
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
      child: Container(
        key: ValueKey<int>(controller.selectedTabIndex.value),
        child: _buildTabContent(detail, themeController, isDarkMode),
      ),
    );
  }

  Widget _buildTabContent(
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    final applicantName = controller.applicantDetail!.applicant.name;

    // If name is not Mohammed Al Mansoori → always show only first tab
    if (applicantName != "Mohammed Al Mansoori") {
      return AssessmentDashboardView(
        name: controller.applicantDetail!.applicant.name,
      );
    }

    // ELSE → Normal flow based on selected tab index
    switch (controller.selectedTabIndex.value) {
      case 0:
        return AssessmentDashboardView(
          name: controller.applicantDetail!.applicant.name,
        );
      case 1:
        // Balance Analysis - Power BI Report
        return PowerBIEmbedViewWithReport(
          reportKey: 'balance',
          reportName: 'Balance Analysis',
        );
      case 2:
        // Transaction Analysis - Power BI Report
        return PowerBIEmbedViewWithReport(
          reportKey: 'transaction',
          reportName: 'Transaction Analysis',
        );
      case 3:
        // Expense - Power BI Report
        return PowerBIEmbedViewWithReport(
          reportKey: 'expense',
          reportName: 'Expense',
        );
      case 4:
        // Alarming Transactions - Power BI Report
        return PowerBIEmbedViewWithReport(
          reportKey: 'alarming',
          reportName: 'Alarming Transactions',
        );
      case 5:
        // FOIR - Power BI Report
        return PowerBIEmbedViewWithReport(
          reportKey: 'foir',
          reportName: 'FOIR',
        );
      case 6:
        // DSR - Power BI Report
        return PowerBIEmbedViewWithReport(reportKey: 'dsr', reportName: 'DSR');
      // case 7:
      //   // Cashflow - Power BI Report
      //   return PowerBIEmbedViewWithReport(
      //     reportKey: 'cashflow',
      //     reportName: 'Cashflow',
      //   );
      default:
        return _buildGeneralTab(detail, isDarkMode);
    }
  }

  Widget _buildEnhancedTabContent(
    dynamic detail,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    final cardBg = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final shadowColor = isDarkMode ? Colors.black : Colors.black;

    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  cardBg.withOpacity(0.98),
                  Colors.grey.shade900.withOpacity(0.92),
                  Colors.grey.shade800.withOpacity(0.88),
                ]
              : [
                  Colors.white.withOpacity(0.98),
                  Colors.white.withOpacity(0.92),
                  Colors.white.withOpacity(0.88),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(isDarkMode ? 0.2 : 0.08),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: themeController.getThemeData().primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Obx(() {
          return _buildAnimatedPageTransition(
            detail,
            themeController,
            isDarkMode,
          );
        }),
      ),
    );
  }

  LinearGradient _buildProfileGradient(ThemeController themeController) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        themeController.getThemeData().primaryColor,
        themeController.getThemeData().primaryColor.withOpacity(0.8),
      ],
      stops: const [0.0, 1.0],
    );
  }

  Widget _buildLoadingSpinner(ThemeController themeController) {
    return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: themeController.getPrimaryGradient(),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 2000.ms);
  }

  Widget _buildEmptyState(ThemeController themeController, bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person_off_outlined,
          size: 80,
          color: themeController.getThemeData().primaryColor.withOpacity(0.5),
        ),
        const SizedBox(height: 24),
        Text(
          'No applicant data available',
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode
                ? Colors.white.withOpacity(0.7)
                : themeController.getThemeData().primaryColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).scale();
  }

  Widget _pillChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value, {
    bool emphasize = false,
    bool isDarkMode = false,
  }) {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.4,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab: General
  Widget _buildGeneralTab(detail, bool isDarkMode) {
    final applicant = detail.applicant;
    final cif = (applicant.cif ?? '').toString();
    final name = (applicant.name ?? '').toString().toUpperCase();
    final custType = 'SINGLE';
    final rag = (applicant.ragStatus ?? 'LOW').toString();
    final risk = (applicant.riskScore ?? 0).toDouble().clamp(0, 100);
    final credit = (applicant.creditScore ?? 0).toDouble().clamp(300, 900);
    final dob = (applicant.dateOfBirth ?? '').toString();
    final email = (applicant.email ?? '').toString();
    final mobile = (applicant.mobile ?? '').toString();
    final bank = (applicant.bankName ?? '').toString();
    final branch = (applicant.branch ?? '').toString();
    final accountNo = (applicant.accountNumber ?? '').toString();
    final accountType = (applicant.accountType ?? '').toString();
    final accountOpenDate = (applicant.accountOpeningDate ?? '').toString();
    final closingBal = (applicant.closingBalance ?? '').toString();
    final avgBalLatest = (applicant.averageQuarterlyBalanceLatest ?? '')
        .toString();
    final avgBalPrev = (applicant.averageQuarterlyBalancePrevious ?? '')
        .toString();
    final odCcLimit = (applicant.odCcLimit ?? '').toString();
    final loanType = (applicant.loanType ?? '').toString();
    final employmentType = (applicant.employmentType ?? '').toString();
    final ckyc = (applicant.ckycCompliance ?? '').toString();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text(
              'Application Details',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: 0.4,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  'Account Number',
                  accountNo,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  'Account Type',
                  accountType,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard(
                  'Opening Date',
                  accountOpenDate,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard(
                  'CKYC Compliance',
                  ckyc == 'Y' ? 'Yes' : 'No',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  'Closing Balance',
                  'AED $closingBal',
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard(
                  'Avg Quarterly Bal (Latest)',
                  'AED $avgBalLatest',
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard(
                  'Avg Quarterly Bal (Prev)',
                  'AED $avgBalPrev',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  'OD/CC Limit',
                  'AED $odCcLimit',
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard('Loan Type', loanType, isDarkMode: isDarkMode),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard(
                  'Employment Type',
                  employmentType,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: RiskScoreCard(score: risk)),
              const SizedBox(width: 16),
              Expanded(child: CreditScoreCard(score: credit)),
            ],
          ),
        ],
      ),
    );
  }

  // Tab: Balance Trends
  Widget _buildBalanceTrendTab(detail, bool isDarkMode) {
    final series = _extractMonthlyBalances(detail);
    final quarterly = _computeQuarterlyAverage(series);
    final avgSeries = _computeMonthlyAggregate(series, agg: 'avg');
    final minSeries = _computeMonthlyAggregate(series, agg: 'min');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          BalanceTrendTab(),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Card(
          //         color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Average Balance Trend',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w700,
          //                   color: isDarkMode ? Colors.white : Colors.black,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               SizedBox(
          //                 height: 180,
          //                 child: _SmallLineChart(data: avgSeries, xLabelEvery: 2, isDarkMode: isDarkMode),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //     Expanded(
          //       child: Card(
          //         color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Minimum Balance Trend',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w700,
          //                   color: isDarkMode ? Colors.white : Colors.black,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               SizedBox(
          //                 height: 180,
          //                 child: _SmallLineChart(data: minSeries, xLabelEvery: 2, isDarkMode: isDarkMode),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //     Expanded(
          //       child: Card(
          //         color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Quarterly Average Balance Trend',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w700,
          //                   color: isDarkMode ? Colors.white : Colors.black,
          //                 ),
          //               ),
          //               const SizedBox(height: 12),
          //               SizedBox(
          //                 height: 180,
          //                 child: _BarChartWithLabels(data: quarterly, isDarkMode: isDarkMode),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 16),
          Card(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Running Balance Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 320, child: BalanceTrendsPage()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab: Spend Trends
  Widget _buildSpendTrendTab(detail) {
    return spendPatternCharts();
  }

  // Tab: Key Features
  Widget _buildKeyFeaturesTab(detail, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.8,
        ),
        itemCount: detail.keyFeatures.length,
        itemBuilder: (context, index) {
          final f = detail.keyFeatures[index];
          final ragColor = AppTheme.getRagColor(f.ragStatus);
          return _FeatureCard(
            title: f.name,
            value: f.value,
            ragColor: ragColor,
            trend: f.trend,
            chipText: f.ragStatus.toUpperCase(),
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }

  // Tab: Credit Card
  Widget _buildCreditCardTab(detail, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Card Provider',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Credit Limit',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Outstanding',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Utilization',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
          rows: detail.creditCards.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final card = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? (isDarkMode
                          ? Colors.grey.shade700
                          : Colors.black.withOpacity(0.02))
                    : Colors.transparent,
              ),
              cells: [
                DataCell(
                  Text(
                    card.cardProvider,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    'AED ${card.creditLimit.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    'AED ${card.outstandingAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${card.utilizationRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(_buildStatusChip(card.status, isDarkMode)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Tab: Inquiry History
  Widget _buildInquiryHistoryTab(detail, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Inquiry Type',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Lender',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Purpose',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
          rows: detail.inquiries.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final inquiry = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? (isDarkMode
                          ? Colors.grey.shade700
                          : Colors.black.withOpacity(0.02))
                    : Colors.transparent,
              ),
              cells: [
                DataCell(
                  Text(
                    inquiry.inquiryType,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    inquiry.lender,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    inquiry.date.toString().substring(0, 10),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    inquiry.purpose,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Tab: Balance Enquiry
  Widget _buildBalanceEnquiryTab(detail, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Access ID',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Consent ID',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Loan Number',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Requested At',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Action',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
          rows: detail.accessRequests.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final request = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? (isDarkMode
                          ? Colors.grey.shade700
                          : Colors.black.withOpacity(0.02))
                    : Colors.transparent,
              ),
              cells: [
                DataCell(
                  Text(
                    request.accessId,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    request.consentId,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    request.loanNumber,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(_buildAccessChip(request.status, isDarkMode)),
                DataCell(
                  Text(
                    request.requestedAt.toString().substring(0, 16),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.white,
                          title: Text(
                            'Access Request Details',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Access ID: ${request.accessId}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                'Consent ID: ${request.consentId}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                'Loan Number: ${request.loanNumber}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                'Status: ${request.status}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              if (request.balanceUrl != null)
                                Text(
                                  'URL: ${request.balanceUrl}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                        barrierColor: Colors.black54,
                        transitionCurve: Curves.easeInOut,
                      );
                    },
                    child: const Text('View'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDarkMode) {
    final c = AppTheme.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: c),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(color: c, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessChip(String status, bool isDarkMode) {
    late Color color;
    switch (status.toUpperCase()) {
      case 'FETCHED':
        color = Colors.green;
        break;
      case 'INITIATED':
        color = Colors.blue;
        break;
      case 'FAILED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  LinearGradient _buildBackgroundGradient(
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDarkMode
          ? [
              const Color(0xFF0F172A),
              const Color(0xFF0F172A).withOpacity(0.95),
              Colors.grey.shade900.withOpacity(0.9),
            ]
          : [
              themeController.getThemeData().scaffoldBackgroundColor,
              themeController
                  .getThemeData()
                  .scaffoldBackgroundColor
                  .withOpacity(0.95),
              themeController.getThemeData().cardColor.withOpacity(0.9),
            ],
      stops: const [0.0, 0.4, 1.0],
    );
  }

  Widget _buildCustomHeader(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeController.getThemeData().primaryColor.withOpacity(0.95),
            themeController.getThemeData().primaryColor.withOpacity(0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
                onTap: () {
                  if (Get.previousRoute.isNotEmpty) {
                    Get.back(); // normal back
                  } else {
                    Get.offAllNamed('/applicants'); // fallback
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
              .animate()
              .scale(duration: 600.ms, delay: 100.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                      ).createShader(bounds),
                      child: const Text(
                        'Applicant Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.2, end: 0),
                const Text(
                      'Detailed financial assessment & insights',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.2, end: 0),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     _buildHeaderActionButton(
          //           icon: Icons.download_rounded,
          //           label: 'Export',
          //           onTap: downloadAnalyticsPdf,
          //           color: Colors.green,
          //         )
          //         .animate()
          //         .scale(duration: 600.ms, delay: 400.ms)
          //         .fadeIn(duration: 400.ms, delay: 400.ms),
          //     const SizedBox(width: 12),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// Data models and helpers
class _Point {
  final DateTime x;
  final double y;
  final bool salary;
  final bool emi;
  _Point(this.x, this.y, {this.salary = false, this.emi = false});
}

class _Bar {
  final String label;
  final double value;
  _Bar(this.label, this.value);
}

class _BarChartWithLabels extends StatelessWidget {
  final List<_Bar> data;
  final bool isDarkMode;
  const _BarChartWithLabels({required this.data, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarWithLabelsPainter(data, isDarkMode: isDarkMode),
      child: Container(),
    );
  }
}

class _BarWithLabelsPainter extends CustomPainter {
  final List<_Bar> data;
  final bool isDarkMode;
  _BarWithLabelsPainter(this.data, {required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final double maxV = data
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final double barW = size.width / (data.length * 1.8);
    final double gap = barW * 0.8;
    double x = gap / 2;
    final paint = Paint()..color = Colors.indigo;
    final labelStyle = TextStyle(
      fontSize: 10,
      color: isDarkMode ? Colors.white : Colors.black87,
    );
    final valStyle = TextStyle(
      fontSize: 11,
      color: isDarkMode ? Colors.white : Colors.black87,
      fontWeight: FontWeight.bold,
    );
    for (final b in data) {
      final double h = maxV == 0
          ? 0.0
          : (b.value / maxV) * (size.height * 0.75);
      final rect = Rect.fromLTWH(x, size.height - h, barW, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      final vt = TextPainter(
        text: TextSpan(text: b.value.toStringAsFixed(0), style: valStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      vt.paint(
        canvas,
        Offset(x + barW / 2 - vt.width / 2, size.height - h - vt.height - 2),
      );
      final tp = TextPainter(
        text: TextSpan(text: b.label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: barW + gap);
      tp.paint(canvas, Offset(x - 4, size.height - tp.height));
      x += barW + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _BarWithLabelsPainter old) => old.data != data;
}

class _SmallLineChart extends StatelessWidget {
  final List<_Point> data;
  final int xLabelEvery;
  final bool isDarkMode;
  const _SmallLineChart({
    required this.data,
    this.xLabelEvery = 2,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SmallLinePainter(
        data,
        xLabelEvery: xLabelEvery,
        isDarkMode: isDarkMode,
      ),
      child: Container(),
    );
  }
}

class _SmallLinePainter extends CustomPainter {
  final List<_Point> data;
  final int xLabelEvery;
  final bool isDarkMode;
  _SmallLinePainter(
    this.data, {
    required this.xLabelEvery,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minX = 0;
    final maxX = data.length - 1;
    double sx(int i) => i / (maxX == 0 ? 1 : maxX) * size.width;
    double sy(double v) => maxY == minY
        ? size.height / 2
        : size.height - ((v - minY) / (maxY - minY)) * (size.height * 0.85);
    final grid = Paint()
      ..color = isDarkMode ? Colors.grey.shade700 : Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = sx(i);
      final y = sy(data[i].y);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final stroke = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, stroke);
    final dot = Paint()..color = Colors.indigo;
    for (int i = 0; i < data.length; i++) {
      final x = sx(i);
      final y = sy(data[i].y);
      canvas.drawCircle(Offset(x, y), 3, dot);
    }
    final style = TextStyle(
      fontSize: 10,
      color: isDarkMode ? Colors.white : Colors.black87,
    );
    for (int i = 0; i < data.length; i += xLabelEvery) {
      final tp = TextPainter(
        text: TextSpan(text: 'Month-${i + 1}', style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(sx(i) - tp.width / 2, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant _SmallLinePainter old) =>
      old.data != data || old.xLabelEvery != xLabelEvery;
}

// Data adapters from detail
List<_Point> _extractMonthlyBalances(detail) {
  try {
    final list = (detail.balanceTrends ?? detail.monthlyBalances ?? []) as List;
    List<_Point> pts = [];
    if (list.isNotEmpty) {
      pts = list.take(24).map<_Point>((e) {
        final date =
            DateTime.tryParse(
              e.date?.toString() ?? e['date']?.toString() ?? '',
            ) ??
            DateTime.now();
        final y = (e.balance ?? e['balance'] ?? 0).toDouble();
        final salary = (e.salary ?? e['salary'] ?? false) == true;
        final emi = (e.emi ?? e['emi'] ?? false) == true;
        return _Point(date, y, salary: salary, emi: emi);
      }).toList()..sort((a, b) => a.x.compareTo(b.x));
    }
    if (pts.isEmpty) {
      // Demo fallback: last 12 months synthetic wave with markers
      final now = DateTime.now();
      pts = List.generate(12, (i) {
        final d = DateTime(now.year, now.month - (11 - i), 15);
        final y = 500 + 400 * Math.max(0, Math.sin(i / 2));
        final sal = i % 3 == 0;
        final e = i % 5 == 0;
        return _Point(d, y.toDouble(), salary: sal, emi: e);
      });
    }
    return pts;
  } catch (_) {
    // Hard fallback
    final now = DateTime.now();
    return List.generate(12, (i) {
      final d = DateTime(now.year, now.month - (11 - i), 15);
      final y = 300 + 300 * Math.max(0, Math.cos(i / 3));
      return _Point(d, y.toDouble());
    });
  }
}

List<_Bar> _computeQuarterlyAverage(List<_Point> series) {
  if (series.isEmpty) return [];
  final sorted = [...series]..sort((a, b) => a.x.compareTo(b.x));
  final Map<int, List<double>> quarters = {};
  for (final p in sorted) {
    final q = ((p.x.month - 1) ~/ 3) + 1;
    quarters.putIfAbsent(q, () => []).add(p.y);
  }
  return quarters.entries
      .map(
        (e) => _Bar(
          'Q${e.key}',
          e.value.isEmpty
              ? 0
              : e.value.reduce((a, b) => a + b) / e.value.length,
        ),
      )
      .toList();
}

Map<String, double> _aggregateChannels(detail) {
  try {
    final raw = (detail.spend?.channels ?? detail.channels ?? []) as List;
    final Map<String, double> acc = {};
    for (final e in raw) {
      if (e is Map && (e['label'] != null || e['channel'] != null)) {
        final k = (e['label'] ?? e['channel']).toString();
        final v = (e['value'] ?? e['amount'] ?? 0).toDouble();
        acc[k] = (acc[k] ?? 0) + v;
      } else {
        final parts = (e.parts ?? e['parts'] ?? e['values'] ?? {}) as Map;
        parts.forEach((k, v) {
          acc[k.toString()] = (acc[k.toString()] ?? 0) + (v as num).toDouble();
        });
      }
    }
    if (acc.isEmpty) {
      // Demo fallback matching your screenshot style
      return {
        'CHEQUE': 10000,
        'EFT': 5259,
        'FTS': 14500,
        'WAPI': 12300,
        'ITR': 10180,
        'CASH': 4390,
        'OTHERS': 11194,
      }.map((k, v) => MapEntry(k, v.toDouble()));
    }
    return acc;
  } catch (_) {
    return {
      'CHEQUE': 10000,
      'EFT': 5259,
      'FTS': 14500,
      'WAPI': 12300,
      'ITR': 10180,
      'CASH': 4390,
      'OTHERS': 11194,
    }.map((k, v) => MapEntry(k, v.toDouble()));
  }
}

Map<String, double> _aggregateSic(detail) {
  try {
    final raw =
        (detail.spend?.categories ??
                detail.sicCategories ??
                detail.spendCategories ??
                [])
            as List;
    final Map<String, double> acc = {};
    for (final e in raw) {
      if (e is Map) {
        final k = (e['name'] ?? e['label'] ?? 'CAT').toString();
        final v = (e['value'] ?? e['amount'] ?? 0).toDouble();
        acc[k] = (acc[k] ?? 0) + v;
      } else {
        final k = (e.name ?? 'CAT').toString();
        final v = (e.value ?? 0).toDouble();
        acc[k] = (acc[k] ?? 0) + v;
      }
    }
    if (acc.isEmpty) {
      return {
        'CARD PAYMENT': 0,
        'EDUTECH': 0,
        'FOOD': 0,
        'LOAN REPAYMENT': 0,
        'OTHER BANK': 8777,
        'UNCLASSIFIED': 21194,
      }.map((k, v) => MapEntry(k, v.toDouble()));
    }
    return acc;
  } catch (_) {
    return {
      'OTHER BANK': 8000,
      'UNCLASSIFIED': 20000,
    }.map((k, v) => MapEntry(k, v.toDouble()));
  }
}

List<_Point> _computeMonthlyAggregate(
  List<_Point> series, {
  required String agg,
}) {
  if (series.isEmpty) return [];
  // group by month index from start
  final Map<int, List<_Point>> g = {};
  for (int i = 0; i < series.length; i++) {
    g.putIfAbsent(i, () => []).add(series[i]);
  }
  return g.entries.map((e) {
    double val;
    if (agg == 'min') {
      val = e.value.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    } else {
      // avg
      final ys = e.value.map((p) => p.y).toList();
      val = ys.reduce((a, b) => a + b) / ys.length;
    }
    return _Point(series[e.key].x, val);
  }).toList();
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final double value;
  final Color ragColor;
  final String trend;
  final String chipText;
  final bool isDarkMode;
  const _FeatureCard({
    required this.title,
    required this.value,
    required this.ragColor,
    required this.trend,
    required this.chipText,
    required this.isDarkMode,
  });
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _elev;
  late final Animation<double> _valAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _elev = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _valAnim = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Material(
            color: Theme.of(context).cardColor,
            elevation: 50,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 10,
                    //         vertical: 6,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: widget.ragColor.withOpacity(0.12),
                    //         border: Border.all(color: widget.ragColor),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Container(
                    //             width: 8,
                    //             height: 8,
                    //             decoration: BoxDecoration(
                    //               color: widget.ragColor,
                    //               shape: BoxShape.circle,
                    //             ),
                    //           ),
                    //           const SizedBox(width: 6),
                    //           Text(
                    //             widget.chipText,
                    //             style: TextStyle(
                    //               color: widget.ragColor,
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 11,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const Spacer(),
                    //     Icon(
                    //       widget.trend == 'up'
                    //           ? Icons.trending_up
                    //           : widget.trend == 'down'
                    //           ? Icons.trending_down
                    //           : Icons.trending_flat,
                    //       size: 18,
                    //       color: widget.ragColor,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.title == 'Avg Balance Repayment Week' ||
                                  widget.title == 'Credit Utilization' ||
                                  widget.title == 'Monthly Savings'
                              ? 'AED ${_valAnim.value.toStringAsFixed(2)}'
                              : _valAnim.value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: widget.ragColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 40,
                    //   child: CustomPaint(
                    //     painter: _MiniSparklinePainter(widget.ragColor),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tab: Other Loans
Widget _buildOtherLoansTab(detail, bool isDarkMode) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: 2,
          sortAscending: false,
          columns: const [
            DataColumn(label: Text('Loan Type')),
            DataColumn(label: Text('Lender')),
            DataColumn(label: Text('Sanctioned')),
            DataColumn(label: Text('Outstanding')),
            DataColumn(label: Text('Tenure')),
            DataColumn(label: Text('Status')),
          ],
          rows: detail.otherLoans.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final loan = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? Colors.black.withOpacity(0.02)
                    : Colors.transparent,
              ),
              cells: [
                DataCell(Text(loan.loanType)),
                DataCell(Text(loan.lender)),
                DataCell(
                  Text('AED ${loan.sanctionedAmount.toStringAsFixed(0)}'),
                ),
                DataCell(
                  Text('AED ${loan.outstandingAmount.toStringAsFixed(0)}'),
                ),
                DataCell(Text('${loan.tenure} months')),
                DataCell(_buildStatusChip(loan.status)),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}

Widget _buildStatusChip(String status) {
  final c = AppTheme.getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: c.withOpacity(0.12),
      border: Border.all(color: c),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: c),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(color: c, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
