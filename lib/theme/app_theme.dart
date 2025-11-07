import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium 5-Theme System for Dubai/Oman Fintech Platform
/// Themes: Light, Dark, Gold, Emerald, Royal
class AppTheme {
  // ==================== THEME 1: LIGHT (Arabic Fintech) ====================
  static const Color lightPrimary = Color(0xFF0A5C4F); // Deep Emerald
  static const Color lightSecondary = Color(0xFFD4AF37); // Gold
  static const Color lightAccent = Color(0xFF14B8A6); // Turquoise
  static const Color lightBackground = Color(0xFFFAF8F5); // Warm Cream
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color lightCardBg = Color(0xFFFFFBF5); // Soft Cream
  
  // ==================== THEME 2: DARK ====================
  static const Color darkPrimary = Color(0xFF0A1F3D); // Dark Navy
  static const Color darkSecondary = Color(0xFFB87333); // Copper
  static const Color darkAccent = Color(0xFF06B6D4); // Cyan/Turquoise
  static const Color darkBackground = Color(0xFF0F172A); // Deep Navy
  static const Color darkSurface = Color(0xFF1E293B); // Slate
  static const Color darkCardBg = Color(0xFF1E2A3A); // Navy Card

  // ==================== THEME 3: GOLD ====================
  static const Color goldPrimary = Color(0xFFC8A951); // Rich Gold
  static const Color goldSecondary = Color(0xFFE4C590); // Light Gold
  static const Color goldAccent = Color(0xFFB8860B); // Dark Gold
  static const Color goldBackground = Color(0xFFFFFDF6); // Cream
  static const Color goldSurface = Color(0xFFFAF3E0); // Light Beige
  static const Color goldCardBg = Color(0xFFFAF3E0); // Beige Card

  // ==================== THEME 4: EMERALD ====================
  static const Color emeraldPrimary = Color(0xFF1C6758); // Deep Emerald
  static const Color emeraldSecondary = Color(0xFF3D8361); // Medium Green
  static const Color emeraldAccent = Color(0xFF10B981); // Bright Green
  static const Color emeraldBackground = Color(0xFFEEF2E6); // Soft Gray-Green
  static const Color emeraldSurface = Color(0xFFE0E6DA); // Light Green-Gray
  static const Color emeraldCardBg = Color(0xFFE0E6DA); // Card Green-Gray

  // ==================== THEME 5: ROYAL ====================
  static const Color royalPrimary = Color(0xFF14213D); // Deep Navy Blue
  static const Color royalSecondary = Color(0xFF1F2A44); // Dark Blue
  static const Color royalAccent = Color(0xFF5B7BB4); // Royal Blue
  static const Color royalBackground = Color(0xFFE5E5E5); // Light Gray
  static const Color royalSurface = Color(0xFFF5F6FA); // Almost White
  static const Color royalCardBg = Color(0xFFF5F6FA); // White Card
  
  // ==================== RAG STATUS COLORS ====================
  static const Color ragRed = Color(0xFFDC2626); // High Risk
  static const Color ragAmber = Color(0xFFF59E0B); // Medium Risk
  static const Color ragGreen = Color(0xFF10B981); // Low Risk
  
  // ==================== GRADIENT DEFINITIONS ====================
  static const LinearGradient lightPrimaryGradient = LinearGradient(
    colors: [Color.fromARGB(255, 159, 161, 202), Color.fromARGB(255, 153, 182, 178)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF0A1F3D), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC8A951), Color(0xFFF4E4C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF1C6758), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalGradient = LinearGradient(
    colors: [Color(0xFF14213D), Color(0xFF5B7BB4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient copperGradient = LinearGradient(
    colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== TEXT COLORS ====================
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  // ==================== ANIMATION DURATIONS ====================
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  // ==================== ELEVATION & SHADOWS ====================
  static List<BoxShadow> get lightCardShadow => [
    BoxShadow(
      color: lightPrimary.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: lightSecondary.withOpacity(0.04),
      blurRadius: 40,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get darkCardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: darkAccent.withOpacity(0.1),
      blurRadius: 40,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get hoverGlowLight => [
    BoxShadow(
      color: lightAccent.withOpacity(0.3),
      blurRadius: 30,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get hoverGlowDark => [
    BoxShadow(
      color: darkAccent.withOpacity(0.4),
      blurRadius: 30,
      spreadRadius: 2,
    ),
  ];

  // ==================== THEME BUILDERS ====================

  /// Get theme by name
  static ThemeData getThemeByName(String themeName) {
    switch (themeName) {
      case 'Light':
        return lightTheme;
      case 'Dark':
        return darkTheme;
      case 'Gold':
        return goldTheme;
      case 'Emerald':
        return emeraldTheme;
      case 'Royal':
        return royalTheme;
      default:
        return lightTheme;
    }
  }

  /// Get gradient by theme name
  static LinearGradient getGradientByTheme(String themeName) {
    switch (themeName) {
      case 'Light':
        return lightPrimaryGradient;
      case 'Dark':
        return darkPrimaryGradient;
      case 'Gold':
        return goldGradient;
      case 'Emerald':
        return emeraldGradient;
      case 'Royal':
        return royalGradient;
      default:
        return lightPrimaryGradient;
    }
  }

  /// Get chart colors by theme name
  static List<Color> getChartColorsByTheme(String themeName) {
    switch (themeName) {
      case 'Light':
        return [lightPrimary, lightAccent, Color(0xFF059669), Color(0xFF0891B2)];
      case 'Dark':
        return [darkAccent, Color(0xFF0EA5E9), Color(0xFF3B82F6), Color(0xFF6366F1)];
      case 'Gold':
        return [goldPrimary, goldSecondary, goldAccent, Color(0xFFD4AF37)];
      case 'Emerald':
        return [emeraldPrimary, emeraldSecondary, emeraldAccent, Color(0xFF059669)];
      case 'Royal':
        return [royalPrimary, royalAccent, Color(0xFF3B5998), Color(0xFF8E9AAF)];
      default:
        return [lightPrimary, lightAccent];
    }
  }

  // ==================== THEME 1: LIGHT ====================
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: lightPrimary,
      secondary: lightSecondary,
      tertiary: lightAccent,
      background: lightBackground,
      surface: lightSurface,
      cardBg: lightCardBg,
      textColor: textDark,
      textSecondary: textSecondaryLight,
    );
  }

  // ==================== THEME 2: DARK ====================
  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: darkAccent,
      secondary: darkSecondary,
      tertiary: darkAccent,
      background: darkBackground,
      surface: darkSurface,
      cardBg: darkCardBg,
      textColor: textLight,
      textSecondary: textSecondaryDark,
    );
  }

  // ==================== THEME 3: GOLD ====================
  static ThemeData get goldTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: goldPrimary,
      secondary: goldSecondary,
      tertiary: goldAccent,
      background: goldBackground,
      surface: goldSurface,
      cardBg: goldCardBg,
      textColor: Color(0xFF5A4A2A),
      textSecondary: Color(0xFF8B7355),
    );
  }

  // ==================== THEME 4: EMERALD ====================
  static ThemeData get emeraldTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: emeraldPrimary,
      secondary: emeraldSecondary,
      tertiary: emeraldAccent,
      background: emeraldBackground,
      surface: emeraldSurface,
      cardBg: emeraldCardBg,
      textColor: Color(0xFF1C4532),
      textSecondary: Color(0xFF5A7C6A),
    );
  }

  // ==================== THEME 5: ROYAL ====================
  static ThemeData get royalTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: royalPrimary,
      secondary: royalSecondary,
      tertiary: royalAccent,
      background: royalBackground,
      surface: royalSurface,
      cardBg: royalCardBg,
      textColor: royalPrimary,
      textSecondary: Color(0xFF64748B),
    );
  }

  // ==================== THEME BUILDER HELPER ====================
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color background,
    required Color surface,
    required Color cardBg,
    required Color textColor,
    required Color textSecondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: brightness == Brightness.light ? Colors.white : textColor,
        secondary: secondary,
        onSecondary: brightness == Brightness.light ? Colors.white : textColor,
        tertiary: tertiary,
        onTertiary: Colors.white,
        error: ragRed,
        onError: Colors.white,
        background: background,
        onBackground: textColor,
        surface: surface,
        onSurface: textColor,
      ),
      
      // Typography
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textColor,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          color: textSecondary,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shadowColor: primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tertiary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ragRed),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: tertiary.withOpacity(0.1),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Data Table Theme
      dataTableTheme: DataTableThemeData(
        headingTextStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
        dataTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textColor,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: textColor,
        size: 24,
      ),
    );
  }

  // ==================== UTILITY FUNCTIONS ====================
  
  /// Get RAG Color based on status
  static Color getRagColor(String status) {
    switch (status.toLowerCase()) {
      case 'red':
      case 'high':
        return ragRed;
      case 'amber':
      case 'medium':
      case 'yellow':
        return ragAmber;
      case 'green':
      case 'low':
        return ragGreen;
      default:
        return Colors.grey;
    }
  }

  /// Get Status Color
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'INITIATED':
        return Colors.blue.shade400;
      case 'FETCHED':
      case 'COMPLETED':
      case 'ACTIVE':
        return ragGreen;
      case 'FAILED':
      case 'REJECTED':
        return ragRed;
      case 'PENDING':
        return ragAmber;
      default:
        return Colors.grey;
    }
  }
  
  /// Get Gradient for Risk Score
  static LinearGradient getRiskGradient(double riskScore) {
    if (riskScore <= 0.33) {
      return const LinearGradient(
        colors: [ragGreen, Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (riskScore <= 0.66) {
      return const LinearGradient(
        colors: [ragAmber, Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [ragRed, Color(0xFFB91C1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  // Inside AppTheme class
static Color getIconColorByTheme(String themeName) {
  switch (themeName) {
    case 'Dark':
      return Colors.white;
    case 'Gold':
      return const Color(0xFF5A4A00);
    case 'Emerald':
      return const Color(0xFF064E3B);
    case 'Royal':
      return const Color(0xFF1A237E);
    default: // Light
      return Colors.black87;
  }
}

static Color getAccentColorByTheme(String themeName) {
  switch (themeName) {
    case 'Gold':
      return const Color(0xFFFFC107);
    case 'Emerald':
      return const Color(0xFF00C853);
    case 'Royal':
      return const Color(0xFF3D5AFE);
    case 'Dark':
      return const Color(0xFF80CBC4);
    default: // Light
      return const Color(0xFF1976D2);
  }
}

static Color getHoverColorByTheme(String themeName) {
  switch (themeName) {
    case 'Gold':
      return const Color(0xFFFFD54F);
    case 'Emerald':
      return const Color(0xFF26A69A);
    case 'Royal':
      return const Color(0xFF5C6BC0);
    case 'Dark':
      return const Color(0xFF90A4AE);
    default: // Light
      return const Color(0xFF64B5F6);
  }
}

}