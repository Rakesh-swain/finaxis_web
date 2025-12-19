import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Exact from HTML
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryPurple = Color(0xFFA855F7);
  static const Color accentBlue = Color(0xFF0066CC);
  
  // Background Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color gradientMid = Color(0xFF4C1D95);
  static const Color cardBg = Color(0xFF1E293B);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD8B4FE);
  static const Color textTertiary = Color(0xFFA78BFA);
  static const Color textMuted = Color(0xFF7C3AED);
  
  // Status Colors
  static const Color statusActive = Color(0xFF22C55E);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusApproved = Color(0xFF3B82F6);
  static const Color statusFailed = Color(0xFFEF4444);
  static const Color statusEligible = Color(0xFF10B981);
   static const Color sidebarBg = Color(0x14FFFFFF);
  // Border Colors
  static const Color borderLight = Color(0x1AFFFFFF);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBg, gradientMid, darkBg],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: primaryBlue,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: _textStyle(size: 28, weight: FontWeight.w900),
        displayMedium: _textStyle(size: 22, weight: FontWeight.w700),
        titleLarge: _textStyle(size: 18, weight: FontWeight.w700),
        titleMedium: _textStyle(size: 16, weight: FontWeight.w700),
        bodyLarge: _textStyle(size: 14, weight: FontWeight.w500),
        bodyMedium: _textStyle(size: 13, weight: FontWeight.w400),
        labelSmall: _textStyle(size: 11, weight: FontWeight.w600),
      ),
    );
  }

  static TextStyle _textStyle({
    required double size,
    required FontWeight weight,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: textPrimary,
      letterSpacing: size <= 11 ? 0.5 : 0,
    );
  }
}

// lib/theme/color_config.dart
class ColorConfig {
  static const Map<String, Color> statusColors = {
    'active': AppTheme.statusActive,
    'pending': AppTheme.statusPending,
    'approved': AppTheme.statusApproved,
    'failed': AppTheme.statusFailed,
    'eligible': AppTheme.statusEligible,
  };

  static const Map<String, String> statusLabels = {
    'active': '✓ Active',
    'pending': 'Pending',
    'approved': 'Approved',
    'failed': '✕ Failed',
    'eligible': 'Eligible',
  };
}
