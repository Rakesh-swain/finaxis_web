import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../controllers/theme_controller.dart';

/// 🚀 Futuristic Sidebar - 2050 Design Language
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Responsive width calculations
    final sidebarWidth = widget.isCollapsed
        ? 80.0
        : isMobile
            ? screenWidth * 0.75 // 75% on mobile when expanded
            : isTablet
                ? 240.0 // Fixed width on tablet
                : 280.0; // Fixed width on desktop

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      width: sidebarWidth,
      child: Stack(
        children: [
          // 🌌 Particle Background
          _buildParticleBackground(themeController),
          
          // 💎 Glassmorphic Container
          _buildGlassmorphicSidebar(themeController),
          
          // ✨ Glow Effects
          _buildGlowEffects(themeController),
        ],
      ),
    );
  }

  /// Build particle background animation
  Widget _buildParticleBackground(ThemeController themeController) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              animationValue: _particleController.value,
              primaryColor: themeController.getThemeData().primaryColor,
            ),
          );
        },
      ),
    );
  }

  /// Build glassmorphic sidebar container
  Widget _buildGlassmorphicSidebar(ThemeController themeController) {
    return Positioned.fill(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 0,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeController.getThemeData().primaryColor.withOpacity(0.1),
            themeController.getThemeData().primaryColor.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeController.getThemeData().primaryColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        child: _buildSidebarContent(themeController),
      ),
    );
  }

  /// Build glow effects
  Widget _buildGlowEffects(ThemeController themeController) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.5),
                radius: 1.5,
                colors: [
                  themeController.getThemeData().primaryColor.withOpacity(
                    0.1 * (0.5 + 0.5 * _glowController.value),
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build sidebar content
  Widget _buildSidebarContent(ThemeController themeController) {
    return Column(
      children: [
        // 🎯 Header Section
        _buildHeader(themeController),
        
        const SizedBox(height: 32),
        
        // 📋 Navigation Items
        Expanded(
          child: _buildNavigationItems(themeController),
        ),
        
        // 👤 Profile Section
        _buildProfileSection(themeController),
        
        const SizedBox(height: 24),
      ],
    );
  }

  /// Build header with logo and collapse button
  Widget _buildHeader(ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 16, 0),
      child: Row(
        children: [
          // 🎨 Logo with glow effect
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: themeController.getPrimaryGradient(),
              boxShadow: [
                BoxShadow(
                  color: themeController.getThemeData().primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 24,
            ),
          ).animate()
            .shimmer(duration: 2000.ms, delay: 500.ms)
            .then()
            .shake(hz: 1, curve: Curves.easeInOutCubic),
          
          if (!widget.isCollapsed) ...[
            const SizedBox(width: 16),
            
            // 📝 Brand Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finaxis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = themeController.getPrimaryGradient()
                        .createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.3, end: 0),
                  
                  Text(
                    'AI Financial Platform',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      letterSpacing: 1.2,
                    ),
                  ).animate()
                    .fadeIn(duration: 800.ms, delay: 500.ms)
                    .slideX(begin: -0.3, end: 0),
                ],
              ),
            ),
          ],
          
          // 🔄 Collapse Toggle
          if (widget.onToggleCollapse != null)
            IconButton(
              onPressed: widget.onToggleCollapse,
              icon: AnimatedRotation(
                turns: widget.isCollapsed ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              tooltip: widget.isCollapsed ? 'Expand' : 'Collapse',
            ),
        ],
      ),
    );
  }

  /// Build navigation items
  Widget _buildNavigationItems(ThemeController themeController) {
    final items = _getNavigationItems();
    
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
        ).animate(delay: (index * 100).ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.5, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }

  /// Build individual navigation item
  Widget _buildNavigationItem(
    NavigationItem item,
    int index,
    bool isSelected,
    ThemeController themeController,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemSelected(index),
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
                  ? themeController.getPrimaryGradient().withOpacity(0.15)
                  : null,
              border: isSelected
                  ? Border.all(
                      color: themeController.getThemeData().primaryColor.withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: themeController.getThemeData().primaryColor.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // 🎯 Icon with glow effect
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected
                        ? themeController.getThemeData().primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: isSelected
                        ? themeController.getThemeData().primaryColor
                        : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: 16),
                  
                  // 📝 Label
                  Expanded(
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? themeController.getThemeData().primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  
                  // 🔔 Notification badge (if any)
                  if (item.notificationCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.notificationCount.toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
  }

  /// Build profile section
  Widget _buildProfileSection(ThemeController themeController) {
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
              themeController.getThemeData().primaryColor.withOpacity(0.1),
              themeController.getThemeData().primaryColor.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: themeController.getThemeData().primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 👤 Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: themeController.getPrimaryGradient(),
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
              
              // 📊 User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RAKESH SWAIN',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate(delay: 1200.ms)
                      .fadeIn(duration: 400.ms),
                    
                    // Text(
                    //   'Senior Analyst',
                    //   style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    //     color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    //   ),
                    // ).animate(delay: 1400.ms)
                    //   .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
              
              // ⚙️ Settings Icon
              Icon(
                Icons.settings_rounded,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
              ).animate(delay: 1600.ms)
                .fadeIn(duration: 400.ms)
                .then()
                .rotate(begin: 0, end: 1, duration: 2000.ms),
            ],
          ],
        ),
      ),
    );
  }

  /// Get navigation items
  List<NavigationItem> _getNavigationItems() {
    return [
      NavigationItem(
        icon: Icons.smart_toy_rounded,
        label: 'AI Chat Hub',
        route: '/ai-chat',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.dashboard_rounded,
        label: 'Dashboard',
        route: '/dashboard',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.people_alt_rounded,
        label: 'Applicants',
        route: '/applicants',
        notificationCount: 3, // Example notification
      ),
      NavigationItem(
        icon: Icons.verified_user_rounded,
        label: 'Consents',
        route: '/consent',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.analytics_rounded,
        label: 'Analytics',
        route: '/analytics',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.assessment_rounded,
        label: 'Reports',
        route: '/reports',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.history_rounded,
        label: 'Audit Log',
        route: '/audit-log',
        notificationCount: 0,
      ),
      NavigationItem(
        icon: Icons.settings_rounded,
        label: 'Settings',
        route: '/settings',
        notificationCount: 0,
      ),
    ];
  }
}

/// 🎯 Navigation Item Model
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

/// 🌟 Custom Particle Painter for Background Effects
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

    // Create floating particles
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

/// Extension to add opacity to gradients
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