import 'dart:math' as Math;
import 'dart:ui';

import 'package:finaxis_web/a.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/applicant_detail_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_theme.dart';

/// 🌟 2050 Book-Open Applicant Detail View
/// Features floating tabs, glassmorphic design, and interactive animations
class ApplicantDetailView extends GetView<ApplicantDetailController> {
  const ApplicantDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: _buildBackgroundGradient(themeController),
        ),
        child: Column(
          children: [
            // 📱 Custom Header (no sidebar)
            _buildCustomHeader(context, themeController),

            // 📖 Main Book Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: _buildLoadingSpinner(themeController));
                }

                final detail = controller.applicantDetail.value;
                if (detail == null) {
                  return Center(child: _buildEmptyState(themeController));
                }

                return _buildBookOpenLayout(context, detail, themeController);
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the main book-open layout with floating tabs and enhanced scrolling
  Widget _buildBookOpenLayout(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 🎯 Hero Profile Card with Glassmorphic Design
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildHeroProfileCard(context, detail, themeController)
                .animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack),
          ),
        ),

        // 📑 Main Content Area with Right-Side Vertical Tabs
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📖 Left Side: Content Area (75% width)
                Expanded(
                  flex: 3,
                  child: _buildEnhancedTabContent(detail, themeController)
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 400.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOutBack),
                ),

                const SizedBox(width: 24),

                // 🎯 Right Side: Vertical Spinning Tabs (25% width)
                Expanded(
                  flex: 1,
                  child: _buildVerticalSpinableTabs(themeController)
                      .animate()
                      .fadeIn(duration: 1200.ms, delay: 600.ms)
                      .slideX(begin: 0.5, end: 0, curve: Curves.easeOutBack)
                      .scale(duration: 800.ms, delay: 800.ms),
                ),
              ],
            ),
          ),
        ),

        // Extra padding at bottom for smooth scrolling
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  /// Build futuristic hero profile card
  Widget _buildHeroProfileCard(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
  ) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: _buildProfileGradient(themeController),
        boxShadow: [
          BoxShadow(
            color: themeController.getThemeData().primaryColor.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                // 🎭 Animated Avatar Section
                _buildAnimatedAvatar(detail, themeController),

                const SizedBox(width: 32),

                // 📄 Profile Information
                Expanded(
                  child: _buildProfileInfo(context, detail, themeController),
                ),

                // 📊 Floating Score Cards
                _buildFloatingScoreCards(detail, themeController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🎭 Build futuristic animated avatar
  Widget _buildAnimatedAvatar(dynamic detail, ThemeController themeController) {
    return Stack(
      children: [
        // Glow effect
        Container(
          width: 120,
          height: 120,
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
        // Main avatar
        Container(
              width: 120,
              height: 120,
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

  /// 📄 Build profile information section
  Widget _buildProfileInfo(
    BuildContext context,
    dynamic detail,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name with gradient text
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

        const SizedBox(height: 16),

        // Pills with enhanced styling
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children:
              [
                    _pillChip(Icons.badge_outlined, detail.applicant.cif),
                    _pillChip(
                      Icons.shield_outlined,
                      'Risk: ${detail.applicant.ragStatus.toUpperCase() == "AMBER" ? "Medium" : detail.applicant.ragStatus.toUpperCase()}',
                    ),
                    _pillChip(
                      Icons.score_rounded,
                      'Score: ${detail.applicant.creditScore}',
                    ),
                  ]
                  .map(
                    (pill) => pill
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .scale(),
                  )
                  .toList(),
        ),
        const SizedBox(height: 25),
        _buildQuickChatBar(context, themeController)
      ],
    );
  }
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
  /// 📊 Build floating score cards
  Widget _buildFloatingScoreCards(
    dynamic detail,
    ThemeController themeController,
  ) {
    return Row(
      children: [
        _buildFloatingScoreCard(
          'Credit Score',
          detail.applicant.creditScore.toString(),
          Colors.green,
          themeController,
        ),
        const SizedBox(width: 16),
        _buildFloatingScoreCard(
          'Risk Score',
          detail.applicant.riskScore.toStringAsFixed(1),
          Colors.amber,
          themeController,
        ),
      ],
    );
  }

  /// Build individual floating score card
  Widget _buildFloatingScoreCard(
    String title,
    String value,
    MaterialColor color,
    ThemeController themeController,
  ) {
    return Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 3, 3, 3).withOpacity(0.15),
                const Color.fromARGB(255, 20, 20, 20).withOpacity(0.05),
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
              padding: const EdgeInsets.all(16),
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
                      fontSize: 12,
                      color: Colors.white70,
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

  /// 📋 Build normal rectangular tabs on right side
  Widget _buildVerticalSpinableTabs(ThemeController themeController) {
    final tabs = [
      {'icon': Icons.person_outline, 'label': 'General', 'color': Colors.blue},
      {
        'icon': Icons.trending_up,
        'label': 'Balance Trends',
        'color': Colors.green,
      },
      {'icon': Icons.payments, 'label': 'Spend Trends', 'color': Colors.purple},
      {
        'icon': Icons.star_outline,
        'label': 'Key Features',
        'color': Colors.orange,
      },
      {
        'icon': Icons.account_balance,
        'label': 'Other Loans',
        'color': Colors.red,
      },
      {
        'icon': Icons.credit_card,
        'label': 'Credit Cards',
        'color': Colors.indigo,
      },
      {'icon': Icons.search, 'label': 'Inquiry History', 'color': Colors.teal},
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Balance Enquiry',
        'color': Colors.pink,
      },
    ];

    return Container(
      height: 600,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = controller.selectedTabIndex.value == index;

          return _buildNormalTabItem(index, tab, isSelected, themeController);
        }).toList(),
      ),
    );
  }

  /// 🎨 Build modern stylish tab item
  Widget _buildNormalTabItem(
    int index,
    Map<String, dynamic> tab,
    bool isSelected,
    ThemeController themeController,
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
                      colors: [Colors.white, const Color(0xFFF8F9FA)],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: (tab['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Modern Icon Container
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

                  // Modern Label text
                  Expanded(
                    child: Text(
                      tab['label'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Selection Indicator
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

  /// 📑 Build tab content pages with book-open styling & smooth transitions
  Widget _buildTabContentPages(
    dynamic detail,
    ThemeController themeController,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(minHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.88),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Obx(() {
          return _buildAnimatedPageTransition(detail, themeController);
        }),
      ),
    );
  }

  /// 📖 Build animated page transition with book-opening effects
  Widget _buildAnimatedPageTransition(
    dynamic detail,
    ThemeController themeController,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(
                  1.0,
                  0.0,
                ), // Slide from right like opening a book page
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
        child: _buildTabContent(detail, themeController),
      ),
    );
  }

  /// 📄 Build content for current tab with enhanced styling
  Widget _buildTabContent(dynamic detail, ThemeController themeController) {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return _buildGeneralTab(detail);
      case 1:
        return _buildBalanceTrendTab(detail);
      case 2:
        return _buildSpendTrendTab(detail);
      case 3:
        return _buildKeyFeaturesTab(detail);
      case 4:
        return _buildOtherLoansTab(detail);
      case 5:
        return _buildCreditCardTab(detail);
      case 6:
        return _buildInquiryHistoryTab(detail);
      case 7:
        return _buildBalanceEnquiryTab(detail);
      default:
        return _buildGeneralTab(detail);
    }
  }

  /// 🎨 Enhanced tab content with upward perspective design
  Widget _buildEnhancedTabContent(
    dynamic detail,
    ThemeController themeController,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.98),
            Colors.white.withOpacity(0.92),
            Colors.white.withOpacity(0.88),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
          return _buildAnimatedPageTransition(detail, themeController);
        }),
      ),
    );
  }

  /// 🎨 Build profile gradient based on theme
  LinearGradient _buildProfileGradient(ThemeController themeController) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        themeController.getThemeData().primaryColor,
        themeController.getThemeData().primaryColor.withOpacity(0.8),
        themeController.getThemeData().colorScheme.secondary.withOpacity(0.6),
      ],
      stops: const [0.0, 0.7, 1.0],
    );
  }

  /// 🔄 Build loading spinner with futuristic design
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

  /// 🚫 Build empty state with futuristic design
  Widget _buildEmptyState(ThemeController themeController) {
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
            color: themeController.getThemeData().primaryColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).scale();
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
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  // Header helpers
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

  Widget _glassScore(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Tabs header
  Widget _buildTabs(BuildContext context) {
    final tabs = [
      'General',
      'Balance Trends',
      'Spend Trends',
      'Key Features',
      'Other Loans',
      'Credit Cards',
      'Inquiry History',
      'Balance Enquiry',
    ];

    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = controller.selectedTabIndex.value == index;
              return InkWell(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? AppTheme.lightAccent
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppTheme.lightAccent : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, {bool emphasize = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.4,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab: General
  Widget _buildGeneralTab(detail) {
    final cif = (detail.applicant.cif ?? '').toString();
    final name = (detail.applicant.name ?? '').toString().toUpperCase();
    // Some models may not have customerType; derive or fallback to UNKNOWN
    final custType = 'UNKNOWN';
    final rag = (detail.applicant.ragStatus ?? 'LOW').toString();
    final risk = (detail.applicant.riskScore ?? 0).toDouble().clamp(0, 100);
    final credit = (detail.applicant.creditScore ?? 0).toDouble().clamp(
      300,
      900,
    );

    String riskCategoryFromRag(String r) {
      switch (r.toUpperCase()) {
        case 'HIGH':
          return 'High';
        case 'MEDIUM':
          return 'Medium';
        default:
          return 'Low';
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top info cards row
          Row(
            children: [
              Expanded(child: _infoCard('CIF Number', cif)),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard('Customer Name', name, emphasize: true),
              ),
              const SizedBox(width: 16),
              Expanded(child: _infoCard('Customer Type', custType)),
            ],
          ),
          const SizedBox(height: 16),
          // Gauges row
          Row(
            children: [
              Expanded(
                child: _needleGaugeCard(
                  title: 'Risk Score',
                  value: risk,
                  min: 0,
                  max: 100,
                  segments: const [
                    Colors.green,
                    Colors.green,
                    Colors.green,
                    Colors.amber,
                    Colors.orange,
                    Colors.red,
                  ],
                  valueColor: Colors.orange,
                  footer: null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _needleGaugeCard(
                  title: 'Credit Score',
                  value: credit,
                  min: 300,
                  max: 900,
                  segments: const [
                    Colors.red,
                    Colors.red,
                    Colors.orange,
                    Colors.amber,
                    Colors.green,
                    Colors.green,
                  ],
                  valueColor: Colors.orange,
                  footer: 'Risk category : ${riskCategoryFromRag(rag)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab: Balance Trends
  Widget _buildBalanceTrendTab(detail) {
    final series = _extractMonthlyBalances(detail);
    final quarterly = _computeQuarterlyAverage(series);
    final avgSeries = _computeMonthlyAggregate(series, agg: 'avg');
    final minSeries = _computeMonthlyAggregate(series, agg: 'min');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Average Balance Trend',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: _SmallLineChart(
                            data: avgSeries,
                            xLabelEvery: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Minimum Balance Trend',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: _SmallLineChart(
                            data: minSeries,
                            xLabelEvery: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quarterly Average Balance Trend',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: _BarChartWithLabels(data: quarterly),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Running Balance Trend',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 320, child: _RunningAreaChart(data: series)),
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
    final channelTotals = _aggregateChannels(detail); // label->value
    final sicTotals = _aggregateSic(detail); // label->value
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spend Pattern - Channel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: _SingleSeriesBarChartWithLabels(
                      data: channelTotals,
                      highlightLabel: 'CASH',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spend Pattern - SIC',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: _SingleSeriesBarChartWithLabels(data: sicTotals),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
         PowerBIEmbedPage()
        ],
      ),
    );
  }

  // Tab: Key Features
  Widget _buildKeyFeaturesTab(detail) {
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
          );
        },
      ),
    );
  }

  // Tab: Credit Card
  Widget _buildCreditCardTab(detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Card Provider')),
            DataColumn(label: Text('Credit Limit')),
            DataColumn(label: Text('Outstanding')),
            DataColumn(label: Text('Utilization')),
            DataColumn(label: Text('Status')),
          ],
          rows: detail.creditCards.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final card = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? Colors.black.withOpacity(0.02)
                    : Colors.transparent,
              ),
              cells: [
                DataCell(Text(card.cardProvider)),
                DataCell(Text('₹${card.creditLimit.toStringAsFixed(0)}')),
                DataCell(Text('₹${card.outstandingAmount.toStringAsFixed(0)}')),
                DataCell(Text('${card.utilizationRate.toStringAsFixed(1)}%')),
                DataCell(_buildStatusChip(card.status)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Tab: Inquiry History
  Widget _buildInquiryHistoryTab(detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Inquiry Type')),
            DataColumn(label: Text('Lender')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Purpose')),
          ],
          rows: detail.inquiries.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final inquiry = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? Colors.black.withOpacity(0.02)
                    : Colors.transparent,
              ),
              cells: [
                DataCell(Text(inquiry.inquiryType)),
                DataCell(Text(inquiry.lender)),
                DataCell(Text(inquiry.date.toString().substring(0, 10))),
                DataCell(Text(inquiry.purpose)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Tab: Balance Enquiry
  Widget _buildBalanceEnquiryTab(detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Access ID')),
            DataColumn(label: Text('Consent ID')),
            DataColumn(label: Text('Loan Number')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Requested At')),
            DataColumn(label: Text('Action')),
          ],
          rows: detail.accessRequests.asMap().entries.map<DataRow>((e) {
            final idx = e.key;
            final request = e.value;
            return DataRow(
              color: MaterialStateProperty.all(
                idx % 2 == 0
                    ? Colors.black.withOpacity(0.02)
                    : Colors.transparent,
              ),
              cells: [
                DataCell(Text(request.accessId)),
                DataCell(Text(request.consentId)),
                DataCell(Text(request.loanNumber)),
                DataCell(_buildAccessChip(request.status)),
                DataCell(Text(request.requestedAt.toString().substring(0, 16))),
                DataCell(
                  TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Access Request Details'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Access ID: ${request.accessId}'),
                              Text('Consent ID: ${request.consentId}'),
                              Text('Loan Number: ${request.loanNumber}'),
                              Text('Status: ${request.status}'),
                              if (request.balanceUrl != null)
                                Text('URL: ${request.balanceUrl}'),
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

  // Chips
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

  /// 🌈 Build background gradient for the scaffold
  LinearGradient _buildBackgroundGradient(ThemeController themeController) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        themeController.getThemeData().scaffoldBackgroundColor,
        themeController.getThemeData().scaffoldBackgroundColor.withOpacity(
          0.95,
        ),
        themeController.getThemeData().cardColor.withOpacity(0.9),
      ],
      stops: const [0.0, 0.4, 1.0],
    );
  }

  /// 📱 Build custom header without sidebar
  Widget _buildCustomHeader(
    BuildContext context,
    ThemeController themeController,
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
          // Back Button with glassmorphic design
          GestureDetector(
                onTap: () => Get.back(),
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

          // Title with gradient text
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

          // Action Buttons
          Row(
            children: [
              // Export Action Button
              _buildHeaderActionButton(
                    icon: Icons.download_rounded,
                    label: 'Export',
                    onTap: () => Get.snackbar(
                      'Export',
                      'PDF export not yet implemented',
                    ),
                    color: Colors.green,
                  )
                  .animate()
                  .scale(duration: 600.ms, delay: 400.ms)
                  .fadeIn(duration: 400.ms, delay: 400.ms),

              const SizedBox(width: 12),

              // Share Action Button
              _buildHeaderActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    onTap: () => Get.snackbar(
                      'Share',
                      'Share functionality coming soon',
                    ),
                    color: Colors.blue,
                  )
                  .animate()
                  .scale(duration: 600.ms, delay: 500.ms)
                  .fadeIn(duration: 400.ms, delay: 500.ms),
            ],
          ),
        ],
      ),
    );
  }

  /// 🎯 Build header action button with glassmorphic design
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

  Widget _buildAccessChip(String status) {
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
}

// Lightweight visual placeholders
class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  _GaugePainter(this.value, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;
    canvas.drawArc(rect.deflate(8), 3.14, 3.14, false, bg);
    canvas.drawArc(
      rect.deflate(8),
      3.14,
      3.14 * (value.clamp(0, 100) / 100),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.value != value || old.color != color;
}

Widget _gaugeCard(String title, double value, Color color) {
  final maxVal = title.contains('Credit') ? 850.0 : 100.0;
  final pct = (value.clamp(0, maxVal) / maxVal * 100);
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: CustomPaint(painter: _GaugePainter(pct, color)),
          ),
          const SizedBox(height: 4),
          Text(
            title.contains('Credit')
                ? value.toStringAsFixed(0)
                : '${value.toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

Widget _metricCard(String title, String value) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}

// Real charts and data adapters
class _AreaChart extends StatelessWidget {
  final List<_Point> data;
  const _AreaChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _AreaPainter(data), child: Container());
  }
}

class _BarChart extends StatelessWidget {
  final List<_Bar> data;
  const _BarChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BarPainter(data), child: Container());
  }
}

class _BarChartWithLabels extends StatelessWidget {
  final List<_Bar> data;
  const _BarChartWithLabels({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarWithLabelsPainter(data),
      child: Container(),
    );
  }
}

class _RadialRingChart extends StatelessWidget {
  final List<_Slice> data;
  const _RadialRingChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RadialRingPainter(data), child: Container());
  }
}

class _SingleSeriesBarChartWithLabels extends StatelessWidget {
  final Map<String, double> data;
  final String? highlightLabel;
  const _SingleSeriesBarChartWithLabels({
    required this.data,
    this.highlightLabel,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SingleSeriesBarPainter(data, highlightLabel: highlightLabel),
      child: Container(),
    );
  }
}

// Data models for charts
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

class _Slice {
  final String label;
  final double value;
  final Color color;
  _Slice(this.label, this.value, this.color);
}

class _ChannelSlice {
  final String label;
  final Map<String, double> parts;
  _ChannelSlice(this.label, this.parts);
}

// Painters
class _AreaPainter extends CustomPainter {
  final List<_Point> data;
  _AreaPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minX = data.first.x.millisecondsSinceEpoch.toDouble();
    final maxX = data.last.x.millisecondsSinceEpoch.toDouble();
    double sx(DateTime d) =>
        ((d.millisecondsSinceEpoch - minX) / (maxX - minX) * size.width).clamp(
          0,
          size.width,
        );
    double sy(double v) {
      if (maxY == minY) return size.height / 2;
      return size.height - ((v - minY) / (maxY - minY) * size.height);
    }

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final p = data[i];
      final x = sx(p.x);
      final y = sy(p.y);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.indigo.withOpacity(0.35),
          Colors.indigo.withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    final stroke = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, stroke);

    // Markers
    final salaryPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    final emiPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    for (final p in data) {
      final x = sx(p.x);
      final y = sy(p.y);
      if (p.salary) canvas.drawCircle(Offset(x, y), 4, salaryPaint);
      if (p.emi)
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 8, height: 8),
          emiPaint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _AreaPainter old) => old.data != data;
}

class _BarPainter extends CustomPainter {
  final List<_Bar> data;
  _BarPainter(this.data);
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
    final labelStyle = const TextStyle(fontSize: 10, color: Colors.black87);
    for (final b in data) {
      final double h = maxV == 0 ? 0.0 : (b.value / maxV) * (size.height * 0.8);
      final rect = Rect.fromLTWH(x, size.height - h, barW, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
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
  bool shouldRepaint(covariant _BarPainter old) => old.data != data;
}

class _BarWithLabelsPainter extends CustomPainter {
  final List<_Bar> data;
  _BarWithLabelsPainter(this.data);
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
    final labelStyle = const TextStyle(fontSize: 10, color: Colors.black87);
    final valStyle = const TextStyle(
      fontSize: 11,
      color: Colors.black87,
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
      // value label
      final vt = TextPainter(
        text: TextSpan(text: b.value.toStringAsFixed(0), style: valStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      vt.paint(
        canvas,
        Offset(x + barW / 2 - vt.width / 2, size.height - h - vt.height - 2),
      );
      // x label
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

class _SingleSeriesBarPainter extends CustomPainter {
  final Map<String, double> data;
  final String? highlightLabel;
  _SingleSeriesBarPainter(this.data, {this.highlightLabel});
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final entries = data.entries.toList();
    final double maxV = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final double barW = size.width / (entries.length * 1.8);
    final double gap = barW * 0.8;
    double x = gap / 2;
    final labelStyle = const TextStyle(fontSize: 10, color: Colors.black87);
    final valStyle = const TextStyle(
      fontSize: 11,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    );
    for (final e in entries) {
      final bool isHighlight =
          highlightLabel != null &&
          e.key.toUpperCase() == highlightLabel!.toUpperCase();
      final paint = Paint()..color = isHighlight ? Colors.red : Colors.indigo;
      final double h = maxV == 0
          ? 0.0
          : (e.value / maxV) * (size.height * 0.75);
      final rect = Rect.fromLTWH(x, size.height - h, barW, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      final vt = TextPainter(
        text: TextSpan(text: e.value.toStringAsFixed(0), style: valStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      vt.paint(
        canvas,
        Offset(x + barW / 2 - vt.width / 2, size.height - h - vt.height - 2),
      );
      final tp = TextPainter(
        text: TextSpan(text: e.key, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: barW + gap);
      tp.paint(canvas, Offset(x - 4, size.height - tp.height));
      x += barW + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _SingleSeriesBarPainter old) =>
      old.data != data || old.highlightLabel != highlightLabel;
}

class _SmallLineChart extends StatelessWidget {
  final List<_Point> data;
  final int xLabelEvery;
  const _SmallLineChart({required this.data, this.xLabelEvery = 2});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SmallLinePainter(data, xLabelEvery: xLabelEvery),
      child: Container(),
    );
  }
}

class _SmallLinePainter extends CustomPainter {
  final List<_Point> data;
  final int xLabelEvery;
  _SmallLinePainter(this.data, {required this.xLabelEvery});
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
    // axes grid
    final grid = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // line
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
    // x labels
    final style = const TextStyle(fontSize: 10, color: Colors.black87);
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

class _RunningAreaChart extends StatelessWidget {
  final List<_Point> data;
  const _RunningAreaChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RunningAreaPainter(data), child: Container());
  }
}

class _RunningAreaPainter extends CustomPainter {
  final List<_Point> data;
  _RunningAreaPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minX = data.first.x.millisecondsSinceEpoch.toDouble();
    final maxX = data.last.x.millisecondsSinceEpoch.toDouble();
    double sx(DateTime d) =>
        ((d.millisecondsSinceEpoch - minX) / (maxX - minX)) * size.width;
    double sy(double v) => maxY == minY
        ? size.height / 2
        : size.height - ((v - minY) / (maxY - minY)) * (size.height * 0.85);
    // grid
    final grid = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // path
    final p = Path();
    for (int i = 0; i < data.length; i++) {
      final x = sx(data[i].x);
      final y = sy(data[i].y);
      if (i == 0)
        p.moveTo(x, y);
      else
        p.lineTo(x, y);
    }
    final fill = Path.from(p)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()..color = Colors.indigo.withOpacity(0.25);
    final stroke = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(p, stroke);
    // dots
    final dot = Paint()..color = Colors.indigo;
    for (final pt in data) {
      final x = sx(pt.x);
      final y = sy(pt.y);
      canvas.drawCircle(Offset(x, y), 3, dot);
    }
    // x labels every ~N points
    final style = const TextStyle(fontSize: 10, color: Colors.black87);
    final step = (data.length / 6).ceil().clamp(1, data.length);
    for (int i = 0; i < data.length; i += step) {
      final d = data[i].x;
      final lbl = '${d.day}/${d.month}/${d.year}';
      final tp = TextPainter(
        text: TextSpan(text: lbl, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = sx(d);
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant _RunningAreaPainter old) => old.data != data;
}

class _RadialRingPainter extends CustomPainter {
  final List<_Slice> data;
  _RadialRingPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final total = data.fold<double>(0, (s, e) => s + e.value);
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 8;
    double start = -3.14159 / 2; // top
    for (final s in data) {
      final double sweep = total == 0 ? 0.0 : ((s.value) / total) * 6.28318;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.35
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
    // Center label
    final tp = TextPainter(
      text: TextSpan(
        text: total == 0 ? '0' : '${total.toStringAsFixed(0)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RadialRingPainter old) => old.data != data;
}

class _StackedCompPainter extends CustomPainter {
  final List<_ChannelSlice> data;
  _StackedCompPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final keys = data.first.parts.keys.toList();
    final colors = <String, Color>{
      for (final k in keys)
        k: (k.toLowerCase() == 'cash'
            ? Colors.red
            : Colors.blueGrey[(keys.indexOf(k) + 4) * 100] ?? Colors.blueGrey),
    };
    final barW = size.width / (data.length * 1.6);
    final gap = barW * 0.6;
    double x = gap / 2;
    for (final s in data) {
      final double total = s.parts.values.fold<double>(
        0.0,
        (a, b) => a + (b as double),
      );
      double y = size.height;
      for (final k in keys) {
        final double v = (s.parts[k] ?? 0.0).toDouble();
        final double h = total == 0.0 ? 0.0 : (v / total) * (size.height * 0.9);
        final rect = Rect.fromLTWH(x, y - h, barW, h);
        final paint = Paint()..color = colors[k]!;
        canvas.drawRect(rect, paint);
        y -= h;
      }
      // label
      final tp = TextPainter(
        text: TextSpan(
          text: s.label,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: barW + gap);
      tp.paint(canvas, Offset(x - 4, size.height - tp.height));
      x += barW + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _StackedCompPainter old) => old.data != data;
}

// General gauges (needle style)
Widget _needleGaugeCard({
  required String title,
  required double value,
  required double min,
  required double max,
  required List<Color> segments,
  required Color valueColor,
  String? footer,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _NeedleGaugePainter(
                value: value,
                min: min,
                max: max,
                segments: segments,
                needleColor: valueColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(footer, style: const TextStyle(color: Colors.black54)),
          ],
        ],
      ),
    ),
  );
}

class _NeedleGaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final List<Color> segments;
  final Color needleColor;
  _NeedleGaugePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.segments,
    required this.needleColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.42;
    // segments
    final segCount = segments.length;
    double startAngle = 3.14159;
    final sweep = 3.14159 / segCount;
    for (int i = 0; i < segCount; i++) {
      final paint = Paint()
        ..color = segments[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + i * sweep,
        sweep * 0.95,
        false,
        paint,
      );
    }
    // needle
    final t = ((value - min) / (max - min)).clamp(0, 1);
    final angle = 3.14159 + t * 3.14159;
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 3;
    final tip = Offset(
      center.dx + radius * 0.9 * Math.cos(angle),
      center.dy + radius * 0.9 * Math.sin(angle),
    );
    canvas.drawLine(center, tip, needlePaint);
    canvas.drawCircle(center, 4, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _NeedleGaugePainter old) =>
      old.value != value || old.segments != segments;
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

List<_Slice> _extractCategorySpend(detail) {
  try {
    final raw =
        (detail.spend?.categories ??
                detail.sicCategories ??
                detail.spendCategories ??
                [])
            as List;
    if (raw.isEmpty) return [];
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    return List.generate(raw.length, (i) {
      final e = raw[i];
      final label = (e.name ?? e['name'] ?? 'Cat ${i + 1}').toString();
      final val = (e.value ?? e['value'] ?? e['amount'] ?? 0).toDouble();
      return _Slice(label, val, colors[i % colors.length]);
    });
  } catch (_) {
    return [];
  }
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
        'CHEQUE': 0,
        'EFT': 3259,
        'RTGS': 4500,
        'IMPS': 0,
        'UPI': 1018,
        'CASH': 0,
        'OTHERS': 21194,
      }.map((k, v) => MapEntry(k, v.toDouble()));
    }
    return acc;
  } catch (_) {
    return {
      'CHEQUE': 0,
      'EFT': 3200,
      'RTGS': 4400,
      'IMPS': 0,
      'UPI': 900,
      'CASH': 0,
      'OTHERS': 20000,
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

List<_ChannelSlice> _extractChannelSpend(detail) {
  try {
    final raw = (detail.spend?.channels ?? detail.channels ?? []) as List;
    if (raw.isEmpty) return [];
    return raw.map<_ChannelSlice>((e) {
      final label = (e.month ?? e['month'] ?? 'M').toString();
      final parts = (e.parts ?? e['parts'] ?? e['values'] ?? {}) as Map;
      return _ChannelSlice(
        label,
        parts.map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
      );
    }).toList();
  } catch (_) {
    return [];
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final double value;
  final Color ragColor;
  final String trend;
  final String chipText;
  const _FeatureCard({
    required this.title,
    required this.value,
    required this.ragColor,
    required this.trend,
    required this.chipText,
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
            elevation: _elev.value,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.ragColor.withOpacity(0.12),
                            border: Border.all(color: widget.ragColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.ragColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.chipText,
                                style: TextStyle(
                                  color: widget.ragColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          widget.trend == 'up'
                              ? Icons.trending_up
                              : widget.trend == 'down'
                              ? Icons.trending_down
                              : Icons.trending_flat,
                          size: 18,
                          color: widget.ragColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _valAnim.value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 24,
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: CustomPaint(
                        painter: _MiniSparklinePainter(widget.ragColor),
                      ),
                    ),
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

class _MiniSparklinePainter extends CustomPainter {
  final Color color;
  _MiniSparklinePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()..color = color.withOpacity(0.12);
    for (int i = 0; i < 12; i++) {
      final x = size.width * (i / 11);
      final y = size.height * (0.6 - 0.3 * Math.sin(i / 2));
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _MiniSparklinePainter old) => old.color != color;
}

/// 📱 Custom SliverPersistentHeaderDelegate for pinned tab bar
class _BookTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _BookTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

// Tab: Other Loans
Widget _buildOtherLoansTab(detail) {
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
                DataCell(Text('₹${loan.sanctionedAmount.toStringAsFixed(0)}')),
                DataCell(Text('₹${loan.outstandingAmount.toStringAsFixed(0)}')),
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
