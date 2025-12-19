import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/theme_controller.dart';
import 'futuristic_sidebar.dart';

/// Enum for background style selection
enum BackgroundStyle {
  platformBased,      // Adapts to theme (Light/Dark)
  addConsentStyle,    // Dark with floating elements like AddConsentPage
}

/// 🌟 Unified Futuristic Layout - 2050 Design System
/// Theme-aware: Adapts to Light/Dark theme from ThemeController
class FuturisticLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String pageTitle;
  final String pagesubTitle;
  final List<Widget>? headerActions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final BackgroundStyle backgroundStyle;

  const FuturisticLayout({
    Key? key,
    required this.child,
    required this.selectedIndex,
    required this.pageTitle,
    this.pagesubTitle = '',
    this.headerActions,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundStyle = BackgroundStyle.platformBased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        return Container(
          decoration: BoxDecoration(
            gradient: _buildBackgroundGradient(themeController),
          ),
          child: Stack(
            children: [
              // 🎨 Background floating elements (for AddConsentStyle)
              if (backgroundStyle == BackgroundStyle.addConsentStyle) ...[
                _buildFloatingElements(),
              ],
              
              // Main Layout
              Row(
                children: [
                  // 🎯 Futuristic Sidebar
                  FuturisticSidebar(
                    selectedIndex: selectedIndex,
                    onItemSelected: _handleNavigation,
                  ),

                  // 📱 Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // ✨ Header Section
                        _buildHeader(context, themeController, isMobile),

                        // 📄 Page Content
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build floating background elements like AddConsentPage
  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Top-right floating element
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.2),
                  const Color(0xFF1E40AF).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        // Bottom-left floating element
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0EA5E9).withOpacity(0.15),
                  const Color(0xFF06B6D4).withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build page header with title and actions
  /// Theme-aware: Adapts to Light/Dark theme
  Widget _buildHeader(
    BuildContext context,
    ThemeController themeController,
    bool isMobile,
  ) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      // Determine header colors based on background style and theme
      Color headerBgStart;
      Color headerBgEnd;
      Color textColor;
      Color subtitleColor;
      Color accentColor;
      Color accentColorLight;
      Color borderColor;

      if (backgroundStyle == BackgroundStyle.addConsentStyle) {
        // AddConsentPage style (Lighter, clearer)
        headerBgStart = const Color(0xFFFFFFFF);
        headerBgEnd = const Color(0xFFF8FAFC);
        textColor = const Color(0xFF0F172A);
        subtitleColor = const Color(0xFF64748B);
        accentColor = const Color(0xFF1E40AF);
        accentColorLight = const Color(0xFF3B82F6);
        borderColor = const Color(0xFFE2E8F0);
      } else {
        // Theme-based style (Light or Dark)
        if (isDark) {
          // Dark theme header
          headerBgStart = const Color(0xFF1E293B);
          headerBgEnd = const Color(0xFF0F172A);
          textColor = const Color(0xFFFFFFFF);
          subtitleColor = const Color(0xFF94A3B8);
          accentColor = const Color(0xFF0066CC);
          accentColorLight = const Color(0xFF3B82F6);
          borderColor = const Color(0xFF334155);
        } else {
          // Light theme header
          headerBgStart = const Color(0xFFFFFFFF);
          headerBgEnd = const Color(0xFFF8FAFC);
          textColor = const Color(0xFF0F172A);
          subtitleColor = const Color(0xFF64748B);
          accentColor = const Color(0xFF1E40AF);
          accentColorLight = const Color(0xFF3B82F6);
          borderColor = const Color(0xFFE2E8F0);
        }
      }

      return Container(
        padding: EdgeInsets.fromLTRB(24, isMobile ? 16 : 24, 24, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [headerBgStart, headerBgEnd],
          ),
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // 🔙 Back Button (if needed)
            if (showBackButton) ...[
              IconButton(
                onPressed: onBackPressed ?? () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: accentColor,
                ),
                tooltip: 'Go Back',
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.3, end: 0),
              const SizedBox(width: 8),
            ],

            // 🎯 Page Title with Gradient
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor, accentColorLight],
                    ).createShader(bounds),
                    child: Text(
                      pageTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        fontSize: 26,
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: -0.3, end: 0),
                  
                  // LMS Case ID Subtitle
                  if (pagesubTitle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'LMS Case ID: ',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: subtitleColor,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: pagesubTitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ).animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .slideY(begin: -0.2, end: 0),
                  ],
                ],
              ),
            ),

            // ⚡ Header Actions
            if (headerActions != null) ...[
              const SizedBox(width: 16),
              ...headerActions!.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: action,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Build background gradient based on current theme
  LinearGradient _buildBackgroundGradient(ThemeController themeController) {
    if (backgroundStyle == BackgroundStyle.addConsentStyle) {
      // AddConsentPage style background
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0F172A),
          const Color(0xFF1E3A8A).withOpacity(0.5),
        ],
      );
    } else {
      // Theme-based style
      final isDark = themeController.isDarkMode;

      if (isDark) {
        // Dark theme background
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),  // Deep Navy
            Color(0xFF1E293B),  // Slate
            Color(0xFF0F172A),  // Deep Navy
          ],
          stops: [0.0, 0.5, 1.0],
        );
      } else {
        // Light theme background
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC),  // Pure White
            Color(0xFFF8FAFC),  // Soft White
            Color(0xFFF1F5F9),  // Light Gray
          ],
          stops: [0.0, 0.6, 1.0],
        );
      }
    }
  }

  /// Handle navigation from sidebar
  void _handleNavigation(int index) {
    final platformController = Get.find<PlatformController>();
    final route = platformController.getRoute(index);
    Get.offNamed(route);
  }
}

/// 🎨 Futuristic Card - Reusable card component
/// Theme-aware styling
class FuturisticCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isElevated;
  final LinearGradient? gradient;

  const FuturisticCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.isElevated = false,
    this.gradient,
  }) : super(key: key);

  @override
  State<FuturisticCard> createState() => _FuturisticCardState();
}

class _FuturisticCardState extends State<FuturisticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(
      begin: widget.isElevated ? 8.0 : 4.0,
      end: widget.isElevated ? 16.0 : 8.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      // Card colors based on theme
      final cardBgStart = isDark
          ? const Color(0xFF1E2A3A)  // Navy Card (Dark)
          : const Color(0xFFF8FAFC); // Soft White (Light)
      
      final cardBgEnd = isDark
          ? const Color(0xFF1E293B).withOpacity(0.8)  // Slate (Dark)
          : const Color(0xFFFFFFFF).withOpacity(0.8); // White (Light)
      
      final accentColor = isDark
          ? const Color(0xFF0066CC)  // Electric Blue (Dark)
          : const Color(0xFF1E3A8A); // Navy (Light)
      
      final borderColor = isDark
          ? const Color(0xFF334155)  // Dark border
          : const Color(0xFFE2E8F0); // Light border

      return MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  margin: widget.margin,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: widget.gradient ??
                        LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [cardBgStart, cardBgEnd],
                        ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(
                          _isHovered ? 0.15 : 0.08,
                        ),
                        blurRadius: _elevationAnimation.value * 2,
                        spreadRadius: _elevationAnimation.value / 4,
                        offset: Offset(0, _elevationAnimation.value / 2),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: _elevationAnimation.value,
                        offset: Offset(0, _elevationAnimation.value / 3),
                      ),
                    ],
                    border: Border.all(
                      color: _isHovered
                          ? accentColor.withOpacity(0.3)
                          : borderColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    padding: widget.padding,
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}