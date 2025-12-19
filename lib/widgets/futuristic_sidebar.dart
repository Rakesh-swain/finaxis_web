import 'package:finaxis_web/billings/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../controllers/theme_controller.dart';
import '../controllers/platform_controller.dart';

/// 🚀 Futuristic Sidebar - 2050 Design Language
/// Platform-aware: Light theme for Lending, Dark theme for Billing
class FuturisticSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCollapsed;
  final Function()? onToggleCollapse;

  const FuturisticSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
    this.onToggleCollapse,
  }) : super(key: key);

  @override
  State<FuturisticSidebar> createState() => _FuturisticSidebarState();
}

class _FuturisticSidebarState extends State<FuturisticSidebar>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final sidebarWidth = widget.isCollapsed
        ? 80.0
        : isMobile
            ? screenWidth * 0.75
            : isTablet
                ? 240.0
                : 280.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      width: sidebarWidth,
      child: Stack(
        children: [
          Obx(() => _buildGlassmorphicSidebar(
            themeController,
            platformController,
            platformController.currentPlatform.value,
          )),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicSidebar(
    ThemeController themeController,
    PlatformController platformController,
    PlatformType platform,
  ) {
    // Determine colors based on theme controller
    final isDark = themeController.isDarkMode;
    
    // Light colors for Light theme, Dark colors for Dark theme
    final topColor = isDark
        ? const Color(0xFF1E293B)  // Slate
        : const Color(0xFFFFFFFF); // White
    
    final bottomColor = isDark
        ? const Color(0xFF0F172A)  // Deep Navy
        : const Color(0xFFF8FAFC); // Soft White
    
    final borderColor = isDark
        ? const Color(0xFF334155)  // Dark border
        : const Color(0xFFE2E8F0); // Light border

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [topColor, bottomColor],
          ),
          border: Border(
            right: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
        ),
        child: _buildSidebarContent(themeController, platformController),
      ),
    );
  }

  Widget _buildSidebarContent(
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Column(
      children: [
        _buildHeader(themeController, platformController),
        const SizedBox(height: 32),
        Expanded(
          child: _buildNavigationItems(themeController, platformController),
        ),
        _buildProfileSection(themeController, platformController),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Obx(() {
      final platform = platformController.currentPlatform.value;
      final isLending = platform == PlatformType.lending;
      final isDark = themeController.isDarkMode;
      
      // Text colors based on theme
      final primaryTextColor = isDark
          ? Colors.white              // White for dark theme
          : const Color(0xFF1E3A8A);  // Dark Navy for light theme
      
      final secondaryTextColor = isDark
          ? const Color(0xFF94A3B8)   // Slate for dark theme
          : const Color(0xFF64748B);  // Mist Gray for light theme
      
      // Primary color based on theme
      final primaryGradientStart = isDark
          ? const Color(0xFF0066CC)   // Blue for dark
          : const Color(0xFF1E3A8A);  // Navy for light
      
      final primaryGradientEnd = isDark
          ? const Color(0xFF0052A3)   // Deep blue for dark
          : const Color(0xFF3B82F6);  // Blue for light

      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 16, 0),
        child: Row(
          children: [
            // Platform Switcher Button
            InkWell(
              onTap: () {
                Get.to(MainScreen());
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryGradientStart,
                      primaryGradientEnd,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGradientStart.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isLending
                      ? Icons.people_alt_rounded
                      : Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ).animate()
                .shimmer(duration: 2000.ms, delay: 500.ms)
                .then()
                .shake(hz: 1, curve: Curves.easeInOutCubic),
            ),
            
            if (!widget.isCollapsed) ...[
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platformController.sidebarTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: primaryTextColor,
                        fontSize: 20,
                      ),
                    ).animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .slideX(begin: -0.3, end: 0),
                    
                    Text(
                      platformController.sidebarSubtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: secondaryTextColor,
                        letterSpacing: 1.2,
                        fontSize: 10,
                      ),
                    ).animate()
                      .fadeIn(duration: 800.ms, delay: 500.ms)
                      .slideX(begin: -0.3, end: 0),
                  ],
                ),
              ),
            ],
            
            if (widget.onToggleCollapse != null)
              IconButton(
                onPressed: widget.onToggleCollapse,
                icon: AnimatedRotation(
                  turns: widget.isCollapsed ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: primaryTextColor,
                  ),
                ),
                tooltip: widget.isCollapsed ? 'Expand' : 'Collapse',
              ),
            ],
        ),
      );
    });
  }

  Widget _buildNavigationItems(
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Obx(() {
      final platform = platformController.currentPlatform.value;
      final items = _getNavigationItems(platformController);
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = widget.selectedIndex == index;
          return _buildNavigationItem(
            item,
            index,
            isSelected,
            themeController,
            platform,
          ).animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.5, end: 0, curve: Curves.easeOutCubic);
        },
      );
    });
  }

  Widget _buildNavigationItem(
    NavigationItem item,
    int index,
    bool isSelected,
    ThemeController themeController,
    PlatformType platform,
  ) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      // Colors based on theme
      final primaryColor = isDark
          ? const Color(0xFF0066CC)  // Blue for dark
          : const Color(0xFF1E3A8A); // Navy for light
      
      final primaryColorLight = isDark
          ? const Color(0xFF0052A3)  // Deep blue for dark
          : const Color(0xFF3B82F6); // Light blue for light
      
      final textColor = isDark
          ? const Color(0xFFCBD5E1)  // Light for dark theme
          : const Color(0xFF0F172A); // Dark for light theme
      
      final selectedBgStart = isDark
          ? const Color(0xFF0066CC).withOpacity(0.15)
          : const Color(0xFF1E3A8A).withOpacity(0.1);
      
      final selectedBgEnd = isDark
          ? const Color(0xFF0052A3).withOpacity(0.1)
          : const Color(0xFF3B82F6).withOpacity(0.05);

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.onItemSelected(index);
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 16 : 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [selectedBgStart, selectedBgEnd],
                      )
                    : null,
                border: isSelected
                    ? Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1.5,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? primaryColor : textColor,
                    ),
                  ),
                  
                  if (!widget.isCollapsed) ...[
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? primaryColor : textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    if (item.notificationCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.notificationCount.toString(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ).animate(delay: 800.ms)
                        .scale(begin: const Offset(0, 0), duration: 300.ms)
                        .then()
                        .shake(hz: 2, curve: Curves.easeInOutCubic),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileSection(
    ThemeController themeController,
    PlatformController platformController,
  ) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      final primaryColor = isDark
          ? const Color(0xFF0066CC)
          : const Color(0xFF1E3A8A);
      
      final primaryColorLight = isDark
          ? const Color(0xFF0052A3)
          : const Color(0xFF3B82F6);
      
      final textColor = isDark
          ? Colors.white
          : const Color(0xFF0F172A);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.1),
                primaryColorLight.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, primaryColorLight],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ).animate()
                .scale(delay: 1000.ms, duration: 400.ms)
                .then()
                .shimmer(duration: 2000.ms),
              
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AHMED FALASI',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontSize: 12,
                        ),
                      ).animate(delay: 1200.ms)
                        .fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
                
                // Menu Button - Opens Popup
                _buildProfileMenu(themeController, primaryColor, isDark),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileMenu(
    ThemeController themeController,
    Color primaryColor,
    bool isDark,
  ) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      elevation: 12,
      offset: const Offset(0, -140),
      onSelected: (value) {
        if (value == 'theme') {
          themeController.toggleLightDark();
        } else if (value == 'logout') {
          // Handle logout
          _showLogoutDialog();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'theme',
          height: 60,
          child: _buildPopupMenuItemContent(
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            label: isDark ? 'Light Mode' : 'Dark Mode',
            primaryColor: primaryColor,
            isDark: isDark,
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          height: 60,
          child: _buildPopupMenuItemContent(
            icon: Icons.logout_rounded,
            label: 'Logout',
            primaryColor: const Color(0xFFDC2626),
            isDark: isDark,
            isLogout: true,
          ),
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: primaryColor,
          ),
        ),
      ),
    ).animate(delay: 1600.ms)
      .fadeIn(duration: 400.ms)
      .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildPopupMenuItemContent({
    required IconData icon,
    required String label,
    required Color primaryColor,
    required bool isDark,
    bool isLogout = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryColor.withOpacity(0.15),
          ),
          child: Icon(
            icon,
            size: 18,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }
  List<NavigationItem> _getNavigationItems(PlatformController platformController) {
    return [
      NavigationItem(
        icon: Icons.smart_toy_rounded,
        label: 'Finaxis AI',
        route: platformController.getRoute(0),
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.dashboard_rounded,
        label: 'Dashboard',
        route: platformController.getRoute(1),
        notificationCount: 0,
      ),
       NavigationItem(
        icon: Icons.verified_user_rounded,
        label: platformController.getLabel('consents'),
        route: platformController.getRoute(3),
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.people_alt_rounded,
        label: platformController.getLabel('applicants'),
        route: platformController.getRoute(2),
        notificationCount: 0,
      ),
       NavigationItem(
        icon: Icons.verified_user_rounded,
        label: 'Transactions',
        route: '/transactions',
        notificationCount: 0,
      ),
    ];
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;
  final int notificationCount;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
    this.notificationCount = 0,
  });
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  
  ParticlePainter({
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final progress = (animationValue + i * 0.1) % 1.0;
      final x = (i * 47) % size.width;
      final y = size.height * (0.1 + 0.8 * progress);
      final radius = 2 + 3 * (0.5 + 0.5 * ((animationValue + i * 0.3) % 1.0));
      
      paint.color = primaryColor.withOpacity(0.05 * (1 - progress));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.primaryColor != primaryColor;
  }
}

extension LinearGradientOpacity on LinearGradient {
  LinearGradient withOpacity(double opacity) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
      stops: stops,
      transform: transform,
      tileMode: tileMode,
    );
  }
}