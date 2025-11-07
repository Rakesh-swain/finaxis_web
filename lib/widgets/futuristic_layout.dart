import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/theme_controller.dart';
import 'futuristic_sidebar.dart';

/// 🌟 Unified Futuristic Layout - 2050 Design System
/// Used across all pages to maintain consistent design language
class FuturisticLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String pageTitle;
  final List<Widget>? headerActions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  const FuturisticLayout({
    Key? key,
    required this.child,
    required this.selectedIndex,
    required this.pageTitle,
    this.headerActions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: _buildBackgroundGradient(themeController),
        ),
        child: Row(
          children: [
            // 🎯 Futuristic Sidebar
            FuturisticSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: _handleNavigation,
              isCollapsed: isMobile ? false : Get.width < 1200,
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
      ),
    );
  }

  /// Build page header with title and actions
  Widget _buildHeader(BuildContext context, ThemeController themeController, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, isMobile ? 16 : 24, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeController.getThemeData().scaffoldBackgroundColor,
            themeController.getThemeData().primaryColor.withOpacity(0.02),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: themeController.getThemeData().primaryColor.withOpacity(0.1),
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
                color: themeController.getThemeData().primaryColor,
              ),
              tooltip: 'Go Back',
            ).animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.3, end: 0),
            const SizedBox(width: 8),
          ],
          
          // 🎯 Page Title with Gradient
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => themeController.getPrimaryGradient()
                  .createShader(bounds),
              child: Text(
                pageTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ).animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: -0.3, end: 0),
          ),
          
          // ⚡ Header Actions
          if (headerActions != null) ...[
            const SizedBox(width: 16),
            ...headerActions!.map((action) => 
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: action,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build background gradient based on current theme
  LinearGradient _buildBackgroundGradient(ThemeController themeController) {
    final themeName = themeController.currentThemeName; // Updated to match ThemeController
    
    switch (themeName) {
      case 'Classic Light':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC), // Pure White
            Color(0xFFF8FAFC), // Soft White
            Color(0xFFF1F5F9), // Light Gray
          ],
          stops: [0.0, 0.6, 1.0],
        );
      case 'Emerald Luxe':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0FDF4), // Mint White
            Color(0xFFECFDF5), // Light Mint
            Color(0xFFD1FAE5), // Jade Tint
          ],
          stops: [0.0, 0.6, 1.0],
        );
      case 'Royal Gold':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEFCF3), // Cream
            Color(0xFFFEF3C7), // Light Cream
            Color(0xFFFEF08A), // Gold Tint
          ],
          stops: [0.0, 0.6, 1.0],
        );
      case 'Aurora Green':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFECFEFF), // Ice White
            Color(0xFFCFFAFE), // Light Ice Blue
            Color(0xFFA7F3D0), // Aurora Tint
          ],
          stops: [0.0, 0.6, 1.0],
        );
      case 'Cyber Violet':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF5FF), // Lilac White
            Color(0xFFF3E8FF), // Light Lilac
            Color(0xFFE9D5FF), // Violet Tint
          ],
          stops: [0.0, 0.6, 1.0],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC), // Pure White
            Color(0xFFF8FAFC), // Soft White
            Color(0xFFF1F5F9), // Light Gray
          ],
          stops: [0.0, 0.6, 1.0],
        );
    }
  }

  /// Handle navigation from sidebar
  void _handleNavigation(int index) {
    final routes = [
      '/ai-chat',     // 0: AI Chat Hub
      '/dashboard',   // 1: Dashboard
      '/applicants',  // 2: Applicants
      '/consent',     // 3: Consents
      '/analytics',   // 4: Analytics
      '/reports',     // 5: Reports
      '/audit-log',   // 6: Audit Log
      '/settings',    // 7: Settings
    ];
    
    if (index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }
}

/// 🎨 Futuristic Card - Reusable card component
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
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.isElevated ? 8.0 : 4.0,
      end: widget.isElevated ? 16.0 : 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: GestureDetector(
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
                  gradient: widget.gradient ?? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).cardColor,
                      Theme.of(context).cardColor.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.getThemeData().primaryColor
                          .withOpacity(_isHovered ? 0.15 : 0.08),
                      blurRadius: _elevationAnimation.value * 2,
                      spreadRadius: _elevationAnimation.value / 4,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 3),
                    ),
                  ],
                  border: Border.all(
                    color: themeController.getThemeData().primaryColor
                        .withOpacity(_isHovered ? 0.3 : 0.1),
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
  }
}