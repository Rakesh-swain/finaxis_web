import 'package:finaxis_web/views/dashboard/assessment_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:intl/intl.dart';

class TransactionsDetailPage extends StatefulWidget {
  const TransactionsDetailPage({Key? key}) : super(key: key);

  @override
  State<TransactionsDetailPage> createState() => _TransactionsDetailPageState();
}

class _TransactionsDetailPageState extends State<TransactionsDetailPage> {
  bool isHijri = false;
  AssessmentDashboardController assessmentDashboardController = Get.put(
    AssessmentDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final platform = platformController.currentPlatform.value;
      final isLending = platform == PlatformType.lending;

      // Platform and Theme-aware colors (matching TransactionsPage)
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

      final backgroundColor = isDarkMode
          ? const Color(0xFF0F172A) // Dark navy for dark
          : const Color(0xFFFFFFFF); // Pure white for light

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          decoration: isDarkMode
              ? const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0f172a),
                      Color(0xFF1a2a4a),
                      Color(0xFF0f172a),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                )
              : null,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, themeController, isDarkMode),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 1024;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1400),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 32),
                                _buildTimelineCard(
                                  primaryColor,
                                  textColor,
                                  subtitleColor,
                                  cardBgColor,
                                  dividerColor,
                                  isDarkMode,
                                ),
                                const SizedBox(height: 20),
                                isDesktop
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: _buildLeftColumn(
                                              primaryColor,
                                              textColor,
                                              subtitleColor,
                                              cardBgColor,
                                              dividerColor,
                                              isDarkMode,
                                              themeController,
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            flex: 1,
                                            child: _buildRightColumn(
                                              primaryColor,
                                              textColor,
                                              subtitleColor,
                                              cardBgColor,
                                              dividerColor,
                                              isDarkMode,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _buildLeftColumn(
                                            primaryColor,
                                            textColor,
                                            subtitleColor,
                                            cardBgColor,
                                            dividerColor,
                                            isDarkMode,
                                            themeController,
                                          ),
                                          const SizedBox(height: 24),
                                          _buildRightColumn(
                                            primaryColor,
                                            textColor,
                                            subtitleColor,
                                            cardBgColor,
                                            dividerColor,
                                            isDarkMode,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Container(
      height: 95,
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
                    Get.offAllNamed('/transactions'); // fallback
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
                      child: Text(
                        'Applicant Transactions',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.2, end: 0),
                const Text(
                      'View and manage applicant transaction history',
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
        ],
      ),
    );
  }

  Widget _buildDataSourceCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      context,
      themeController,
      title: 'Mohammed Al Mansoori',
      subtitle: 'CUST-892-4521',
      icon: Icons.cloud_outlined,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.getThemeData().primaryColor.withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeController.getThemeData().primaryColor.withOpacity(
                  0.3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LMS INTEGRATION',
                  style: TextStyle(
                    color: themeController.getThemeData().primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    'Connected from: ${assessmentDashboardController.lmsSource.value}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDataGrid([
            Obx(
              () => _buildDataCell(
                'Loan Amount',
                NumberFormat(
                  '####,##0.00',
                ).format(assessmentDashboardController.loanAmount.value),
                isHighlighted: true,
                editIcon: Icons.edit_outlined,
                onEdit: () {},
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Application Reference',
                assessmentDashboardController.appReference.value,
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Data Received',
                assessmentDashboardController.dataReceived.value,
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Data Completeness',
                assessmentDashboardController.dataCompleteness.value,
                subtext: 'All required fields verified',
              ),
            ),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildCustomerProfileCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      title: 'Customer Profile',
      icon: Icons.person_outline,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: _buildDataGrid([
        Obx(
          () => _buildDataCell(
            'Full Name',
            assessmentDashboardController.customerName.value,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Emirates ID',
            assessmentDashboardController.emiratesId.value,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Nationality',
            assessmentDashboardController.nationality.value,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Employment Status',
            assessmentDashboardController.employmentStatus.value,
            subtext: assessmentDashboardController.employmentSector.value,
          ),
        ),
        // Obx(() => _buildDataCell('Primary Bank', assessmentDashboardController.primaryBank.value)),
        // Obx(() => _buildDataCell('Account Age', assessmentDashboardController.accountAge.value)),
      ]),
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2);
  }

  Widget _buildFinancialDataCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      title: 'Financial Data',
      icon: Icons.account_balance_wallet_outlined,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: _buildDataGrid([
        Obx(
          () => _buildDataCell(
            'Monthly Income',
            NumberFormat(
              '#,###',
            ).format(assessmentDashboardController.monthlyIncome.value),
            subtext: 'AED (Verified)',
            isHighlighted: true,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Current Obligations',
            NumberFormat(
              '####,##0.00',
            ).format(assessmentDashboardController.currentObligations.value),
            subtext: 'AED / month',
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Requested Loan Amount',
            NumberFormat(
              '####,##0.00',
            ).format(assessmentDashboardController.loanAmount.value),
            subtext: 'AED',
            isHighlighted: true,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Requested Tenure',
            '${assessmentDashboardController.tenure.value}',
            subtext: 'Months',
          ),
        ),
      ]),
    ).animate().fadeIn(duration: 600.ms, delay: 150.ms).slideY(begin: 0.2);
  }

  Widget _buildCalculationsCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      title: 'Finaxis Insights',
      icon: Icons.calculate_outlined,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: Obx(
        () => Column(
          children: [
            _buildMetricBar(
              'FOIR (Fixed Obligation to Income)',
              'FOIR',
              'Target: ≤40%',
              assessmentDashboardController.foir.value,
              35.20,
              40,
              50,
              assessmentDashboardController.getProgressColor(
                assessmentDashboardController.foir.value,
                30,
                40,
              ),
              context,
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricBar(
              'DSR (Debt Service Ratio)',
              'DSR',
              'Target: ≤50%',
              assessmentDashboardController.dsr.value,
              23.0,
              50,
              60,
              assessmentDashboardController.getProgressColor(
                assessmentDashboardController.dsr.value,
                40,
                50,
              ),
              context,
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricContainer(
              'Calculated Monthly EMI',
              'Proposed Loan',
              NumberFormat(
                '#,###',
              ).format(assessmentDashboardController.emi.value),
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricContainer(
              'Calculated Tenure',
              'Proposed Loan',
              '12 months',
              isDarkMode,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildMetricContainer(
    String title,
    String subtitle,
    String value,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? const Color(0xFFa78bfa)
                      : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? const Color(0xFF94A3B8) : Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditScoreCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      title: 'Credit Score Analysis',
      icon: Icons.star_outline,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                'Our Score',
                '741',
                '✓ EXCELLENT',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'AECB Score',
                '712',
                '✓ EXCELLENT',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'Default Risk',
                'Low',
                'Historical Performance',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'Bureau Verification',
                'Verified',
                '✓ VALID',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
          ],
        ),
      
    ).animate().fadeIn(duration: 600.ms, delay: 250.ms).slideY(begin: 0.2);
  }

  Widget _buildDecisionCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color cardBgColor,
    Color dividerColor,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      title: 'Assessment Decision',
      icon: Icons.gavel_outlined,
      isDarkMode: isDarkMode,
      cardBgColor: cardBgColor,
      dividerColor: dividerColor,
      child: Obx(
        () => SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      assessmentDashboardController
                          .getDecisionColor()
                          .withOpacity(0.1),
                      assessmentDashboardController
                          .getDecisionColor()
                          .withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: assessmentDashboardController.getDecisionColor(),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      assessmentDashboardController.decisionStatus.value,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: assessmentDashboardController.getDecisionColor(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '✓ Credit Score: ${assessmentDashboardController.aecbScore.value} (≥700 required)',
                      style: const TextStyle(fontSize: 14, height: 1.8),
                    ),
                    Text(
                      '✓ FOIR: ${assessmentDashboardController.foir.value.toStringAsFixed(1)}% (≤40% required)',
                      style: const TextStyle(fontSize: 14, height: 1.8),
                    ),
                    Text(
                      '✓ DSR: ${assessmentDashboardController.dsr.value.toStringAsFixed(1)}% (≤50% required)',
                      style: const TextStyle(fontSize: 14, height: 1.8),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isDarkMode
                                ? const Color(0xFF334155)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: Text(
                        'Risk Assessment: ${assessmentDashboardController.riskAssessment.value}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'With an additional loan of AED 1,000,000, your FOIR will be 21%. This indicates low financial stress.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Going beyond a loan of AED 2,500,000, your FOIR will be 43% and may result in financial stress.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '💡 Recommendation: A loan commitment between AED 1,000,000 and AED 2,000,000 is ideal based on your income analysis.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: assessmentDashboardController.approveAndSync,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('APPROVE & SYNC TO LMS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeController
                            .getThemeData()
                            .primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: assessmentDashboardController.requestMoreInfo,
                      child: const Text('Request More Info'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color(0xFF334155)
                            : Colors.grey.shade300,
                        foregroundColor: isDarkMode
                            ? const Color(0xFFCBD5E1)
                            : Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: assessmentDashboardController.rejectCase,
                      child: const Text('Reject Application'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color(0xFF334155)
                            : Colors.grey.shade300,
                        foregroundColor: isDarkMode
                            ? const Color(0xFFCBD5E1)
                            : Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2);
  }

  Widget _buildCard2(
    BuildContext context,
    ThemeController themeController, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    required bool isDarkMode,
    required Color cardBgColor,
    required Color dividerColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeController
                      .getThemeData()
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: themeController.getThemeData().primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF0F172A),
                ),
              ),
              subtitle.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : Colors.blue.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Customer Id:'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? const Color(0xFF0066CC)
                                  : Colors.blue.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDataGrid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2,
      children: children,
    );
  }

  Widget _buildDataCell(
    String label,
    String value, {
    String? subtext,
    bool isHighlighted = false,
    VoidCallback? onEdit,
    IconData? editIcon,
    Function(String)? onSave,
    bool isDarkMode = false,
  }) {
    final TextEditingController _controller = TextEditingController(
      text: value,
    );
    final ValueNotifier<bool> _isEditing = ValueNotifier(false);
    final ValueNotifier<String> _displayValue = ValueNotifier(value);

    final bgColor = isHighlighted
        ? (isDarkMode ? Colors.blue.shade900 : Colors.blue.shade50)
        : (isDarkMode ? const Color(0xFF1E293B) : Colors.grey.shade100);

    final borderColor = isHighlighted
        ? (isDarkMode ? Colors.blue.shade600 : Colors.blue.shade200)
        : null;

    final labelTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : Colors.grey.shade600;

    final valueTextColor = isDarkMode
        ? const Color(0xFFCBD5E1)
        : (isHighlighted ? Colors.blue.shade700 : null);

    final subtextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : Colors.grey.shade600;

    return ValueListenableBuilder<bool>(
      valueListenable: _isEditing,
      builder: (context, isEditing, _) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted
                ? Border.all(color: borderColor ?? Colors.blue.shade200)
                : null,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: labelTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isEditing)
                    TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: isHighlighted ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: isHighlighted
                            ? (isDarkMode
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700)
                            : valueTextColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.blue.shade600
                                : Colors.blue.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.blue.shade600
                                : Colors.blue.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.blue.shade400
                                : Colors.blue.shade500,
                            width: 2,
                          ),
                        ),
                      ),
                      maxLines: 1,
                    )
                  else
                    ValueListenableBuilder<String>(
                      valueListenable: _displayValue,
                      builder: (context, displayValue, _) {
                        return Text(
                          displayValue,
                          style: TextStyle(
                            fontSize: isHighlighted ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color:
                                valueTextColor ??
                                (isDarkMode ? const Color(0xFFCBD5E1) : null),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  if (subtext != null && !isEditing) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtext,
                      style: TextStyle(fontSize: 11, color: subtextColor),
                    ),
                  ],
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: isEditing
                    ? InkWell(
                        onTap: () {
                          _displayValue.value = _controller.text;
                          onSave?.call(_controller.text);
                          _isEditing.value = false;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    : onEdit != null
                    ? InkWell(
                        onTap: () {
                          _isEditing.value = true;
                          onEdit();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade500,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            editIcon ?? Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricBar(
    String name,
    String name2,
    String threshold,
    double value,
    double value2,
    double thresholdValue,
    double maxValue,
    Color color,
    BuildContext context,
    bool isDarkMode,
  ) {
    final themeController = Get.find<ThemeController>();
    final bgColor = isDarkMode ? const Color(0xFF1E293B) : Colors.grey.shade100;

    final textColor = isDarkMode
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF0F172A);

    final subtitleColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : Colors.grey.shade700;

    final progressBgColor = isDarkMode
        ? const Color(0xFF334155)
        : Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    threshold,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showInfoDialog(context, name2),
                child: Icon(Icons.info_outline, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 15),
          name2 == "FOIR"?Container():Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current $name2",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (value / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: progressBgColor,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Post Approved $name2",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (value2 / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: progressBgColor,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${value2.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String metricName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metricName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (metricName == 'DSR')
                    _buildDSRTable()
                  else if (metricName == 'FOIR')
                    _buildFOIRTable()
                  else
                    Text('No information available'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDSRTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(['Range', 'Meaning', 'Action']),
        _buildDSRRow('0–35%', 'Very strong', 'Easily eligible', Colors.green),
        _buildDSRRow(
          '35–45%',
          'Good',
          'Eligible with normal checks',
          Colors.blue,
        ),
        _buildDSRRow(
          '45–50%',
          'Critical band',
          'Eligible but tight; often lower amount or shorter tenure',
          Colors.orange,
        ),
        _buildDSRRow(
          '> 50%',
          'Not allowed',
          'Loan must be rejected/reduced',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildFOIRTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(['Range', 'Category', 'Description']),
        _buildFOIRRow('< 40%', 'Strong', 'Low fixed obligations', Colors.green),
        _buildFOIRRow('40–50%', 'Acceptable', 'But risky', Colors.orange),
        _buildFOIRRow('> 50%', 'Bad', 'Generally not favorable', Colors.red),
      ],
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: headers.map((header) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                header,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDSRRow(
    String range,
    String meaning,
    String action,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                meaning,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFOIRRow(
    String range,
    String category,
    String description,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    String label,
    String value,
    String status,
    Color statusColor,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    final bgColor = isDarkMode ? const Color(0xFF1E293B) : Colors.grey.shade100;

    final borderColor = isDarkMode
        ? const Color(0xFF334155)
        : Colors.grey.shade300;

    final labelTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : Colors.grey.shade600;

    final valueTextColor = isDarkMode
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: labelTextColor,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: valueTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
    ThemeController themeController,
  ) {
    return Column(
      children: [
        // _buildEMISummaryCard(
        //   primaryColor,
        //   textColor,
        //   subtitleColor,
        //   cardBgColor,
        //   dividerColor,
        //   isLending,
        // ),
        _buildDataSourceCard(
          context,
          themeController,
          themeController.isDarkMode,
          cardBgColor,
          dividerColor,
        ),
        const SizedBox(height: 24),
        _buildCustomerProfileCard(
          context,
          themeController,
          themeController.isDarkMode,
          cardBgColor,
          dividerColor,
        ),
        const SizedBox(height: 24),
        _buildFinancialDataCard(
          context,
          themeController,
          themeController.isDarkMode,
          cardBgColor,
          dividerColor,
        ),
        const SizedBox(height: 24),
        _buildCalculationsCard(
          context,
          themeController,
          themeController.isDarkMode,
          cardBgColor,
          dividerColor,
        ),
        const SizedBox(height: 24),
        _buildCreditScoreCard(
          context,
          themeController,
          themeController.isDarkMode,
          cardBgColor,
          dividerColor,
        ),
        const SizedBox(height: 24),
        _buildConsentStatusCard(
          primaryColor,
          textColor,
          subtitleColor,
          cardBgColor,
          dividerColor,
          isLending,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRightColumn(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return Column(
      children: [
        _buildFOIRCard(
          primaryColor,
          textColor,
          subtitleColor,
          cardBgColor,
          dividerColor,
          isLending,
        ),
        const SizedBox(height: 24),
        _buildCollectionsCard(
          primaryColor,
          textColor,
          subtitleColor,
          cardBgColor,
          dividerColor,
          isLending,
        ),
        const SizedBox(height: 24),
        _buildAlertsCard(
          primaryColor,
          textColor,
          subtitleColor,
          cardBgColor,
          dividerColor,
          isLending,
        ),
      ],
    );
  }

  Widget _buildCard({
    required Widget child,
    EdgeInsets? padding,
    Color? bgColor,
    Color? borderColor,
    bool isLending = false,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color:
            bgColor ??
            (isLending
                ? const Color(0xFFF8FAFC)
                : Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              borderColor ??
              (isLending
                  ? const Color(0xFFE2E8F0)
                  : Colors.white.withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLending ? 0.05 : 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEMISummaryCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer EMI Summary',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ahmed Al Mansouri',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  ),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22c55e).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '✓ ACTIVE CONSENT',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return isMobile
                  ? Column(
                      children: [
                        _buildBillSection(
                          primaryColor,
                          textColor,
                          subtitleColor,
                          isLending,
                        ),
                        const SizedBox(height: 16),
                        _buildPaymentDetailsSection(
                          textColor,
                          subtitleColor,
                          isLending,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildBillSection(
                            primaryColor,
                            textColor,
                            subtitleColor,
                            isLending,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPaymentDetailsSection(
                            textColor,
                            subtitleColor,
                            isLending,
                          ),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillSection(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BILL DETAILS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildBillItem('Samsung 65" Smart TV 4K', 'AED 2,500', textColor),
          _buildBillItem('Sony Wireless Headphones', 'AED 450', textColor),
          _buildBillItem('Apple iPad Pro 11"', 'AED 2,800', textColor),
          _buildBillItem('Dell Laptop Stand', 'AED 150', textColor),
          _buildBillItem('Logitech MX Master 3', 'AED 350', textColor),
          _buildBillItem('Samsung Galaxy Watch', 'AED 750', textColor),
          Divider(
            color: primaryColor.withOpacity(0.3),
            thickness: 1,
            height: 24,
          ),
          _buildBillSummaryRow('Subtotal(5 items):', 'AED 7,000.00', textColor),
          _buildBillSummaryRow('VAT @ 5%:', 'AED 350', textColor),
          _buildBillSummaryRow(
            'Discount Applied:',
            'AED 100',
            const Color(0xFF22c55e),
          ),
          Divider(
            color: primaryColor.withOpacity(0.3),
            thickness: 1,
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Text(
                'AED 7,250',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem(String product, String amount, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              product,
              style: GoogleFonts.inter(fontSize: 14, color: textColor),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummaryRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: valueColor == const Color(0xFF22c55e)
                    ? valueColor
                    : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsSection(
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildStatBox(
                'Total Price',
                'AED 7,000',
                textColor,
                subtitleColor,
                isLending,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildStatBox(
                'Down Payment',
                'AED 1,000',
                textColor,
                subtitleColor,
                isLending,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildStatBox(
                'EMI/Month',
                'AED 250',
                textColor,
                subtitleColor,
                isLending,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildStatBox(
                'Tenure',
                '24 months',
                textColor,
                subtitleColor,
                isLending,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildStatBox(
                'Next Debit',
                'Dec 5, 2025',
                textColor,
                subtitleColor,
                isLending,
                sub: 'in 17 days',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _buildProgressBox(textColor, subtitleColor, isLending),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatBox(
    String label,
    String value,
    Color textColor,
    Color subtitleColor,
    bool isLending, {
    String? sub,
  }) {
    return Container(
      width: double.infinity,
      height: sub != null ? 110 : 90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFE2E8F0).withOpacity(0.5)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLending
              ? const Color(0xFFCBD5E1)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(
              sub,
              style: GoogleFonts.inter(fontSize: 12, color: subtitleColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBox(
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFE2E8F0).withOpacity(0.5)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLending
              ? const Color(0xFFCBD5E1)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PROGRESS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '5/24',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: 0.21,
              backgroundColor: isLending
                  ? const Color(0xFFCBD5E1)
                  : Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3b82f6),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentStatusCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OFTF Consent Status',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  SizedBox(
                    width: constraints.maxWidth > 600
                        ? 200
                        : constraints.maxWidth,
                    child: _buildConsentItem(
                      'Consent ID',
                      'CONS-2025-001847',
                      textColor,
                      subtitleColor,
                      isLending,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth > 600
                        ? 200
                        : constraints.maxWidth,
                    child: _buildConsentItem(
                      'Authenticated',
                      '✓ Verified',
                      textColor,
                      subtitleColor,
                      isLending,
                      sub: '(3-factor)',
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth > 600
                        ? 200
                        : constraints.maxWidth,
                    child: _buildConsentItem(
                      'Bank',
                      'FAB',
                      textColor,
                      subtitleColor,
                      isLending,
                      sub: 'First Abu Dhabi Bank',
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth > 600
                        ? 200
                        : constraints.maxWidth,
                    child: _buildConsentItem(
                      'Valid Until',
                      'Dec 31, 2026',
                      textColor,
                      subtitleColor,
                      isLending,
                      sub: '⚠ in 6 months',
                      isWarning: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONSENT PURPOSE & LIMITS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildConsentHighlightItem(
                      'EMI Auto-Debit',
                      'Purpose',
                      textColor,
                      subtitleColor,
                    ),
                    _buildConsentHighlightItem(
                      'AED 500',
                      'Max Amount',
                      textColor,
                      subtitleColor,
                    ),
                    _buildConsentHighlightItem(
                      'Monthly',
                      'Frequency',
                      textColor,
                      subtitleColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem(
    String label,
    String value,
    Color textColor,
    Color subtitleColor,
    bool isLending, {
    String? sub,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFE2E8F0).withOpacity(0.5)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLending
              ? const Color(0xFFCBD5E1)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(
              sub,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isWarning ? const Color(0xFFfbbf24) : subtitleColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConsentHighlightItem(
    String value,
    String label,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildTimelineCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '12-Month EMI Timeline',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(12, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildTimelineItem(index + 1, 24, isLending),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildLegendItem(
                const Color(0xFF22c55e),
                'Paid (4)',
                subtitleColor,
              ),
              _buildLegendItem(
                const Color(0xFF3b82f6),
                'Current(1)',
                subtitleColor,
              ),
              _buildLegendItem(Colors.amber, 'Upcoming (6)', subtitleColor),
              _buildLegendItem(Colors.red, 'Deferred (0)', subtitleColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(int month, int totalMonths, bool isLending) {
    final isPaid =
        month == 1 ||
        month == 2 ||
        month == 4 ||
        month == 5 ||
        month == 3; // Paid months
    final isDeferred = false; // Deferred month
    final isCurrent = month == 6; // Current month
    final isUpcoming = month > 6; // Upcoming months

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // Paid → Green gradient
            gradient: isPaid
                ? const LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  )
                // Current → Blue/Purple gradient
                : isCurrent
                ? const LinearGradient(
                    colors: [Color(0xFF3b82f6), Color(0xFFa855f7)],
                  )
                : null,

            // Deferred → Red
            color: isDeferred
                ? Colors.red
                // Upcoming → Amber
                : isUpcoming
                ? Colors.amber
                // Default gray
                : (!isPaid && !isCurrent && !isDeferred
                      ? (isLending
                            ? const Color(0xFFE2E8F0)
                            : Colors.white.withOpacity(0.2))
                      : null),

            shape: BoxShape.circle,

            // Current glow + border
            border: isCurrent
                ? Border.all(
                    color: isLending
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFFd8b4fe),
                    width: 2,
                  )
                : null,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: const Color(0xFFa855f7).withOpacity(0.5),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              isPaid
                  ? '✓'
                  : isCurrent
                  ? '⏱'
                  : isDeferred
                  ? 'D'
                  : month.toString(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isPaid || isCurrent
                    ? Colors.white
                    : isDeferred
                    ? Colors.white
                    : isUpcoming
                    ? Colors.black
                    : (isLending
                          ? const Color(0xFF64748B)
                          : const Color(0xFFa78bfa)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'M$month',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDeferred
                ? Colors.red
                : isUpcoming
                ? Colors.amber
                : (isLending
                      ? const Color(0xFF64748B)
                      : const Color(0xFFa78bfa)),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: color == const Color(0xFF22c55e)
                ? const LinearGradient(
                    colors: [Color(0xFF22c55e), Color(0xFF10b981)],
                  )
                : color == const Color(0xFF3b82f6)
                ? const LinearGradient(
                    colors: [Color(0xFF3b82f6), Color(0xFFa855f7)],
                  )
                : null,
            color:
                color != const Color(0xFF22c55e) &&
                    color != const Color(0xFF3b82f6)
                ? color
                : null,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: textColor)),
      ],
    );
  }

  Widget _buildFOIRCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      padding: const EdgeInsets.all(24),
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FOIR / DSR Insights',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildFOIRItem(
            'Current FOIR',
            '12% • Low Risk',
            0.12,
            const Color(0xFF22c55e),
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 16),
          _buildFOIRItem(
            'Current DSR',
            '25%',
            0.25,
            const Color(0xFF10b981),
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isLending
                      ? const Color(0xFFE2E8F0)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SCENARIO ANALYSIS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _buildScenarioBox(
                  '+ AED 10,000 loan',
                  '21% FOIR',
                  0.21,
                  const Color(0xFFf59e0b),
                  textColor,
                  subtitleColor,
                  isLending,
                ),
                const SizedBox(height: 12),
                _buildScenarioBox(
                  '+ AED 25,000 loan',
                  '43% FOIR ⚠',
                  0.43,
                  const Color(0xFFef4444),
                  textColor,
                  subtitleColor,
                  isLending,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10b981).withOpacity(0.1),
                  primaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF10b981).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✓ Recommended Range',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF86efac),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AED 10,000 – AED 20,000',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFOIRItem(
    String label,
    String value,
    double progress,
    Color color,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: subtitleColor,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildScenarioBox(
    String label,
    String value,
    double progress,
    Color color,
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFF8FAFC)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLending
              ? const Color(0xFFE2E8F0)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, color: subtitleColor),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isLending
                  ? const Color(0xFFE2E8F0)
                  : Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      padding: const EdgeInsets.all(24),
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month Collections',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildCollectionStat(
            'Total Collected',
            'AED 525',
            '↑ 5 EMIs',
            const Color(0xFF22c55e),
            textColor,
            subtitleColor,
            isLending,
          ),
          const SizedBox(height: 12),
          _buildCollectionStat(
            'Outstanding',
            'AED 1,225',
            '7 EMIs pending',
            const Color(0xFFfbbf24),
            textColor,
            subtitleColor,
            isLending,
          ),
          const SizedBox(height: 12),
          _buildCollectionStatWithProgress(textColor, subtitleColor, isLending),
          const SizedBox(height: 12),
          _buildCollectionStatWithRetry(textColor, isLending),
        ],
      ),
    );
  }

  Widget _buildCollectionStat(
    String label,
    String value,
    String sub,
    Color subColor,
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFF8FAFC)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLending
              ? const Color(0xFFE2E8F0)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.inter(fontSize: 12, color: subColor)),
        ],
      ),
    );
  }

  Widget _buildCollectionStatWithProgress(
    Color textColor,
    Color subtitleColor,
    bool isLending,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFF8FAFC)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLending
              ? const Color(0xFFE2E8F0)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUCCESS RATE',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '96.5%',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: 0.965,
              backgroundColor: isLending
                  ? const Color(0xFFE2E8F0)
                  : Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF22c55e),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionStatWithRetry(Color textColor, bool isLending) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLending
            ? const Color(0xFFF8FAFC)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLending
              ? const Color(0xFFE2E8F0)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAILED DEBITS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isLending
                  ? const Color(0xFF64748B)
                  : const Color(0xFFa78bfa),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '0',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xFFef4444),
          //       foregroundColor: Colors.white,
          //       padding: const EdgeInsets.symmetric(vertical: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         side: BorderSide(
          //           color: const Color(0xFFef4444).withOpacity(0.4),
          //         ),
          //       ),
          //     ),
          //     child: Text(
          //       'RETRY DEBIT',
          //       style: GoogleFonts.inter(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildAlertsCard(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color dividerColor,
    bool isLending,
  ) {
    return _buildCard(
      padding: const EdgeInsets.all(24),
      bgColor: cardBgColor,
      borderColor: dividerColor,
      isLending: isLending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alerts & Notifications',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildAlert(
            icon: '⚠',
            title: 'Consent Expiry On',
            message: 'in 6 months',
            bgColor: const Color(0xFFf59e0b),
            borderColor: const Color(0xFFfbbf24),
            textColor: isLending
                ? const Color(0xFF92400e)
                : const Color(0xFFfef3c7),
            isLending: isLending,
          ),
          const SizedBox(height: 12),
          // _buildAlert(
          //   icon: '✕',
          //   title: 'Debit Retry Needed',
          //   message: '2 failed payments',
          //   bgColor: const Color(0xFFef4444),
          //   borderColor: const Color(0xFFef4444),
          //   textColor: isLending ? const Color(0xFF7f1d1d) : const Color(0xFFfee2e2),
          //   isLending: isLending,
          // ),
          // const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: const Color(0xFF1E3A8A)),
                ),
              ),
              child: Text(
                '💬 Contact Customer',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlert({
    required String icon,
    required String title,
    required String message,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required bool isLending,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.inter(fontSize: 12, color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
