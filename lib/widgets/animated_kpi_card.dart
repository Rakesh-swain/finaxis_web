import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'dart:math' as math;

/// Premium Animated KPI Card with 3D Tilt Effect & Hover Animation
class AnimatedKpiCard extends StatefulWidget {
  final String title;
  final String value;
  final double percentage;
  final IconData icon;
  final LinearGradient? gradient;
  final bool isCompact;

  const AnimatedKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.icon,
    this.gradient,
    this.isCompact = false,
  });

  @override
  State<AnimatedKpiCard> createState() => _AnimatedKpiCardState();
}

class _AnimatedKpiCardState extends State<AnimatedKpiCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.normalAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevationAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isPositive = widget.percentage >= 0;
    final Color trendColor = isPositive ? AppTheme.ragGreen : AppTheme.ragRed;
    final cardShadow = isDark ? AppTheme.darkCardShadow : AppTheme.lightCardShadow;
    final hoverGlow = isDark ? AppTheme.hoverGlowDark : AppTheme.hoverGlowLight;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_isHovered ? -0.05 : 0)
                ..rotateY(_isHovered ? 0.05 : 0),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _isHovered ? [...cardShadow, ...hoverGlow] : cardShadow,
                  border: Border.all(
                    color: _isHovered
                        ? (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
                            .withOpacity(0.3)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background Pattern
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.03,
                          child: CustomPaint(
                            painter: GeometricPatternPainter(isDark: isDark),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Icon with gradient background
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: widget.gradient ??
                                        (isDark
                                            ? AppTheme.darkPrimaryGradient
                                            : AppTheme.lightPrimaryGradient),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDark
                                                ? AppTheme.darkAccent
                                                : AppTheme.lightAccent)
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    color: Colors.white,
                                    size: widget.isCompact ? 20 : 28,
                                  ),
                                ),
                                // Trend Badge
                                AnimatedContainer(
                                  duration: AppTheme.normalAnimation,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                   decoration: BoxDecoration(
                                    gradient: widget.gradient ??
                                        (isDark
                                            ? AppTheme.darkPrimaryGradient
                                            : AppTheme.lightPrimaryGradient),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDark
                                                ? AppTheme.darkAccent
                                                : AppTheme.lightAccent)
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isPositive
                                            ? Icons.trending_up
                                            : Icons.trending_down,
                                        size: 14,
                                        color: trendColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.percentage.abs().toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Value
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1500),
                              tween: Tween(begin: 0, end: 1),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Text(
                                      widget.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: widget.isCompact ? 24 : 32,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            // Title
                            Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Geometric Pattern Painter for Card Backgrounds
class GeometricPatternPainter extends CustomPainter {
  final bool isDark;

  GeometricPatternPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw geometric pattern
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        final x = (size.width / 5) * i;
        final y = (size.height / 5) * j;
        canvas.drawCircle(Offset(x, y), 20, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
