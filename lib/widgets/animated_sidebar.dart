import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../controllers/theme_controller.dart';

/// Animated Sidebar that adapts to the selected Theme (Light, Dark, Gold, Emerald, Royal)
class AnimatedSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AnimatedSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final currentTheme = themeController.currentThemeName;
      final gradient = themeController.getPrimaryGradient();
      final isDark = currentTheme == 'Dark';
      final isLight = themeController.isLightTheme;

      // Core theme colors
      final iconColor = AppTheme.getIconColorByTheme(currentTheme);
      final selectedColor = AppTheme.getAccentColorByTheme(currentTheme);
      final hoverColor = AppTheme.getHoverColorByTheme(currentTheme);

      return Container(
        width: 80,
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.1),
              blurRadius: 20,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Logo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.05))
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 48),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _SidebarItem(
                    icon: Icons.dashboard_rounded,
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                    selectedColor: selectedColor,
                    iconColor: iconColor,
                    hoverColor: hoverColor,
                  ),
                  _SidebarItem(
                    icon: Icons.verified_user_rounded,
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                    selectedColor: selectedColor,
                    iconColor: iconColor,
                    hoverColor: hoverColor,
                  ),
                  _SidebarItem(
                    icon: Icons.analytics_rounded,
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                    selectedColor: selectedColor,
                    iconColor: iconColor,
                    hoverColor: hoverColor,
                  ),
                  // _SidebarItem(
                  //   icon: Icons.history_rounded,
                  //   isSelected: selectedIndex == 3,
                  //   onTap: () => onItemSelected(3),
                  //   selectedColor: selectedColor,
                  //   iconColor: iconColor,
                  //   hoverColor: hoverColor,
                  // ),
                  // _SidebarItem(
                  //   icon: Icons.settings_rounded,
                  //   isSelected: selectedIndex == 4,
                  //   onTap: () => onItemSelected(4),
                  //   selectedColor: selectedColor,
                  //   iconColor: iconColor,
                  //   hoverColor: hoverColor,
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color iconColor;
  final Color hoverColor;

  const _SidebarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.iconColor,
    required this.hoverColor,
  });

  @override
  State<_SidebarItem> createState() => __SidebarItemState();
}

class __SidebarItemState extends State<_SidebarItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.normalAnimation,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.selectedColor.withOpacity(0.25)
                : (_isHovered
                    ? widget.hoverColor.withOpacity(0.15)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected || _isHovered
                  ? widget.selectedColor.withOpacity(0.4)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? widget.selectedColor
                      : (_isHovered
                          ? widget.hoverColor
                          : widget.iconColor),
                  size: 28,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
