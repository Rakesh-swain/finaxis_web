import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

/// 🚀 Futuristic 2050 Theme Extensions for AI-First Platform
class FuturisticThemes {
  
  // ==================== THEME 1: CLASSIC LIGHT ====================
  static ThemeData get classicLightTheme {
    return _buildFuturisticTheme(
      brightness: Brightness.light,
      primary: AppTheme.classicLightPrimary,
      secondary: AppTheme.classicLightSecondary,
      tertiary: AppTheme.classicLightAccent,
      background: AppTheme.classicLightBackground,
      surface: AppTheme.classicLightSurface,
      cardBg: AppTheme.classicLightCardBg,
      textColor: const Color(0xFF1E293B),
      textSecondary: const Color(0xFF64748B),
      gradient: AppTheme.classicLightGradient,
    );
  }

  // ==================== THEME 2: DEEP NAVY DARK ====================
  /// Deep Navy background (#0f172a) with Electric Blue accents (#0066cc)
  /// Matches the HTML dashboard design exactly
  static ThemeData get deepNavyTheme {
    return _buildFuturisticTheme(
      brightness: Brightness.dark,
      primary: AppTheme.deepNavyPrimary, // #0066CC Electric Blue
      secondary: AppTheme.deepNavySecondary, // #0052A3 Deep Blue
      tertiary: AppTheme.deepNavyAccent, // #3B82F6 Bright Blue
      background: AppTheme.deepNavyBackground, // #0F172A Deep Navy
      surface: AppTheme.deepNavySurface, // #1E293B Slate
      cardBg: AppTheme.deepNavyCardBg, // #1E2A3A Navy Card
      textColor: AppTheme.deepNavyTextPrimary, // #CBD5E1 Light slate text
      textSecondary: AppTheme.deepNavyTextSecondary, // #94A3B8 Slate secondary text
      gradient: AppTheme.deepNavyGradient,
    );
  }

  // Legacy: CYBER VIOLET (maps to Deep Navy for backward compatibility)
  static ThemeData get cyberVioletTheme => deepNavyTheme;

  // ==================== THEME 3: EMERALD LUXE ====================
  static ThemeData get emeraldLuxeTheme {
    return _buildFuturisticTheme(
      brightness: Brightness.light,
      primary: AppTheme.emeraldLuxePrimary,
      secondary: AppTheme.emeraldLuxeSecondary,
      tertiary: AppTheme.emeraldLuxeAccent,
      background: AppTheme.emeraldLuxeBackground,
      surface: AppTheme.emeraldLuxeSurface,
      cardBg: AppTheme.emeraldLuxeCardBg,
      textColor: const Color(0xFF064E3B),
      textSecondary: const Color(0xFF047857),
      gradient: AppTheme.emeraldLuxeGradient,
    );
  }

  // ==================== THEME 4: ROYAL GOLD ====================
  static ThemeData get royalGoldTheme {
    return _buildFuturisticTheme(
      brightness: Brightness.light,
      primary: AppTheme.royalGoldPrimary,
      secondary: AppTheme.royalGoldSecondary,
      tertiary: AppTheme.royalGoldAccent,
      background: AppTheme.royalGoldBackground,
      surface: AppTheme.royalGoldSurface,
      cardBg: AppTheme.royalGoldCardBg,
      textColor: const Color(0xFF92400E),
      textSecondary: const Color(0xFFA16207),
      gradient: AppTheme.royalGoldGradient,
    );
  }

  // ==================== THEME 5: AURORA GREEN ====================
  static ThemeData get auroraGreenTheme {
    return _buildFuturisticTheme(
      brightness: Brightness.light,
      primary: AppTheme.auroraGreenPrimary,
      secondary: AppTheme.auroraGreenSecondary,
      tertiary: AppTheme.auroraGreenAccent,
      background: AppTheme.auroraGreenBackground,
      surface: AppTheme.auroraGreenSurface,
      cardBg: AppTheme.auroraGreenCardBg,
      textColor: const Color(0xFF0D9488),
      textSecondary: const Color(0xFF0891B2),
      gradient: AppTheme.auroraGreenGradient,
    );
  }

  // ==================== FUTURISTIC THEME BUILDER ====================
  static ThemeData _buildFuturisticTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color background,
    required Color surface,
    required Color cardBg,
    required Color textColor,
    required Color textSecondary,
    required LinearGradient gradient,
  }) {
    // Determine border color based on theme
    final borderColor = brightness == Brightness.dark
        ? AppTheme.deepNavyBorder // #334155 for dark theme
        : textSecondary.withOpacity(0.3);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        tertiary: tertiary,
        onTertiary: Colors.white,
        error: AppTheme.ragRed,
        onError: Colors.white,
        background: background,
        onBackground: textColor,
        surface: surface,
        onSurface: textColor,
        outline: borderColor,
        shadow: textColor.withOpacity(0.1),
      ),

      // 🔤 FUTURISTIC TYPOGRAPHY - Inter Font with Perfect Spacing
      textTheme: GoogleFonts.interTextTheme().copyWith(
        // Glowing Headers for AI Chat & Dashboard
        displayLarge: GoogleFonts.inter(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -1.2,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.8,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: -0.4,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textColor,
          letterSpacing: 0.1,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.15,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
          letterSpacing: 0.1,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.1,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.25,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
      ),

      // 🎴 GLASSMORPHIC CARDS - 3D Depth + Soft Glow
      cardTheme: CardThemeData(
        color: cardBg.withOpacity(brightness == Brightness.dark ? 0.9 : 0.7),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // 🔥 FLOATING ACTION BUTTONS - Gradient + Glow
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 12,
        highlightElevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      // ⚡ ELEVATED BUTTONS - Futuristic Glow Effect
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: primary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),

      // 🔘 OUTLINED BUTTONS - Neon Border Effect
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // 🏷️ CHIPS - Floating Pills with Glow
      chipTheme: ChipThemeData(
        backgroundColor: tertiary.withOpacity(0.1),
        disabledColor: textSecondary.withOpacity(0.1),
        selectedColor: tertiary.withOpacity(0.2),
        secondarySelectedColor: secondary.withOpacity(0.15),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: tertiary,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: secondary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: tertiary.withOpacity(0.3)),
        ),
        brightness: brightness,
      ),

      // 📝 INPUT FIELDS - Glassmorphic with Floating Labels
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withOpacity(brightness == Brightness.dark ? 0.8 : 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: tertiary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.ragRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.ragRed, width: 2.5),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 15,
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary.withOpacity(0.7),
        ),
        helperStyle: GoogleFonts.inter(
          fontSize: 12,
          color: textSecondary,
        ),
      ),

      // 🎚️ SLIDERS & SWITCHES - Smooth Animations
      sliderTheme: SliderThemeData(
        activeTrackColor: tertiary,
        inactiveTrackColor: textSecondary.withOpacity(0.2),
        thumbColor: tertiary,
        overlayColor: tertiary.withOpacity(0.2),
        valueIndicatorColor: tertiary,
        valueIndicatorTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tertiary;
          return textSecondary.withOpacity(0.5);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tertiary.withOpacity(0.3);
          return textSecondary.withOpacity(0.1);
        }),
      ),

      // 🏠 APP BAR - Glassmorphic Top Bar
      appBarTheme: AppBarTheme(
        backgroundColor: surface.withOpacity(0.8),
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 8,
        shadowColor: primary.withOpacity(0.1),
        centerTitle: false,
        titleSpacing: 24,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.2,
        ),
        toolbarTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: textColor,
        ),
      ),

      // 📊 DATA TABLES - Clean & Modern
      dataTableTheme: DataTableThemeData(
        headingTextStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.8,
        ),
        dataTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
        columnSpacing: 24,
        horizontalMargin: 20,
        headingRowHeight: 52,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 64,
        decoration: BoxDecoration(
          color: surface.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
      ),

      // 🎯 ICON THEME - Perfect Sizing
      iconTheme: IconThemeData(
        color: textColor,
        size: 24,
        opacity: 0.9,
      ),
      primaryIconTheme: IconThemeData(
        color: primary,
        size: 24,
        opacity: 1.0,
      ),

      // 🎨 DIVIDER THEME - Subtle Separators
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 16,
      ),

      // 📝 LIST TILE THEME - Modern Cards
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: surface.withOpacity(0.5),
        selectedTileColor: tertiary.withOpacity(0.1),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 13,
          color: textSecondary,
        ),
        leadingAndTrailingTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
        ),
      ),

      // 🛡️ TOOLTIP THEME - Informative Overlays
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // ==================== THEME GETTERS ====================
  
  /// Get theme by name
  static ThemeData getThemeByName(String themeName) {
    switch (themeName) {
      case 'Classic Light':
        return classicLightTheme;
      case 'Deep Navy':
      case 'Deep Navy Dark':
        return deepNavyTheme;
      case 'Emerald Luxe':
        return emeraldLuxeTheme;
      case 'Royal Gold':
        return royalGoldTheme;
      case 'Aurora Green':
        return auroraGreenTheme;
      // Legacy theme names
      case 'Cyber Violet':
      case 'Dark':
        return cyberVioletTheme; // Maps to deepNavyTheme
      default:
        return classicLightTheme;
    }
  }

  /// Get gradient by theme name
  static LinearGradient getGradientByTheme(String themeName) {
    switch (themeName) {
      case 'Classic Light':
        return AppTheme.classicLightGradient;
      case 'Deep Navy':
      case 'Deep Navy Dark':
      case 'Dark':
        return AppTheme.deepNavyGradient;
      case 'Emerald Luxe':
        return AppTheme.emeraldLuxeGradient;
      case 'Royal Gold':
        return AppTheme.royalGoldGradient;
      case 'Aurora Green':
        return AppTheme.auroraGreenGradient;
      // Legacy
      case 'Cyber Violet':
        return AppTheme.deepNavyGradient;
      default:
        return AppTheme.classicLightGradient;
    }
  }

  /// Get chart colors by theme name
  static List<Color> getChartColorsByTheme(String themeName) {
    switch (themeName) {
      case 'Classic Light':
        return [
          AppTheme.classicLightPrimary,
          AppTheme.classicLightAccent,
          const Color(0xFF059669),
          const Color(0xFF0891B2),
        ];
      case 'Deep Navy':
      case 'Deep Navy Dark':
      case 'Dark':
      case 'Cyber Violet':
        return [
          AppTheme.deepNavyPrimary,
          AppTheme.deepNavyAccent,
          const Color(0xFF0EA5E9),
          const Color(0xFF6366F1),
        ];
      case 'Emerald Luxe':
        return [
          AppTheme.emeraldLuxePrimary,
          AppTheme.emeraldLuxeSecondary,
          AppTheme.emeraldLuxeAccent,
          const Color(0xFF059669),
        ];
      case 'Royal Gold':
        return [
          AppTheme.royalGoldPrimary,
          AppTheme.royalGoldSecondary,
          AppTheme.royalGoldAccent,
          const Color(0xFFD4AF37),
        ];
      case 'Aurora Green':
        return [
          AppTheme.auroraGreenPrimary,
          AppTheme.auroraGreenSecondary,
          AppTheme.auroraGreenAccent,
          const Color(0xFF06B6D4),
        ];
      default:
        return [AppTheme.classicLightPrimary, AppTheme.classicLightAccent];
    }
  }
}