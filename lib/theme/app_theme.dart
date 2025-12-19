import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Updated Theme System with HTML-Inspired Dark Theme
/// New Dark Theme: Deep Navy (#0f172a) + Electric Blue (#0066cc)
class AppTheme {
  // ==================== EXISTING LIGHT THEME (Classic Light) ====================
  static const Color classicLightPrimary = Color(0xFF1E3A8A); // Deep Navy Blue
  static const Color classicLightSecondary = Color(0xFF64748B); // Mist Gray
  static const Color classicLightAccent = Color(0xFF3B82F6); // Electric Blue
  static const Color classicLightBackground = Color(0xFFFAFBFC); // Pure White
  static const Color classicLightSurface = Color(0xFFFFFFFF); // Clean White
  static const Color classicLightCardBg = Color(0xFFF8FAFC); // Soft White

  // ==================== NEW DARK THEME (HTML-Inspired) ====================
  // Background: Deep Navy (#0f172a)
  // Cards/Surface: Slate (#1e293b)
  // Accents: Electric Blue (#0066cc, #0052a3)
  // Borders: #334155
  
  static const Color deepNavyPrimary = Color(0xFF0066CC); // Electric Blue (Primary)
  static const Color deepNavySecondary = Color(0xFF0052A3); // Deep Blue
  static const Color deepNavyAccent = Color(0xFF3B82F6); // Bright Blue
  static const Color deepNavyBackground = Color(0xFF0F172A); // Deep Navy (Main BG)
  static const Color deepNavySurface = Color(0xFF1E293B); // Slate (Card BG)
  static const Color deepNavyCardBg = Color(0xFF1E2A3A); // Navy Card (Darker)
  static const Color deepNavyBorder = Color(0xFF334155); // Border Color
  
  // Text colors for dark theme
  static const Color deepNavyTextPrimary = Color(0xFFCBD5E1); // Light slate text
  static const Color deepNavyTextSecondary = Color(0xFF94A3B8); // Slate secondary text
  
  // ==================== OTHER EXISTING THEMES ====================
  static const Color emeraldLuxePrimary = Color(0xFF0F766E);
  static const Color emeraldLuxeSecondary = Color(0xFF14B8A6);
  static const Color emeraldLuxeAccent = Color(0xFF10B981);
  static const Color emeraldLuxeBackground = Color(0xFFF0FDF4);
  static const Color emeraldLuxeSurface = Color(0xFFECFDF5);
  static const Color emeraldLuxeCardBg = Color(0xFFD1FAE5);

  static const Color royalGoldPrimary = Color(0xFFD97706);
  static const Color royalGoldSecondary = Color(0xFFEAB308);
  static const Color royalGoldAccent = Color(0xFFFBBF24);
  static const Color royalGoldBackground = Color(0xFFFEFCF3);
  static const Color royalGoldSurface = Color(0xFFFEF3C7);
  static const Color royalGoldCardBg = Color(0xFFFEF3C7);

  static const Color auroraGreenPrimary = Color(0xFF059669);
  static const Color auroraGreenSecondary = Color(0xFF06B6D4);
  static const Color auroraGreenAccent = Color(0xFF10B981);
  static const Color auroraGreenBackground = Color(0xFFECFEFF);
  static const Color auroraGreenSurface = Color(0xFFCFFAFE);
  static const Color auroraGreenCardBg = Color(0xFFA7F3D0);

  // ==================== RAG STATUS COLORS ====================
  static const Color ragRed = Color(0xFFDC2626);
  static const Color ragAmber = Color(0xFFF59E0B);
  static const Color ragGreen = Color(0xFF10B981);
  
  // ==================== BACKWARD COMPATIBILITY ====================
  static const Color lightPrimary = classicLightPrimary;
  static const Color lightSecondary = classicLightSecondary;
  static const Color lightAccent = classicLightAccent;
  static const Color lightBackground = classicLightBackground;
  static const Color lightSurface = classicLightSurface;
  static const Color lightCardBg = classicLightCardBg;
  
  // Updated: Dark theme now uses Deep Navy colors
  static const Color darkPrimary = deepNavyPrimary;
  static const Color darkSecondary = deepNavySecondary;
  static const Color darkAccent = deepNavyAccent;
  static const Color darkBackground = deepNavyBackground;
  static const Color darkSurface = deepNavySurface;
  static const Color darkCardBg = deepNavyCardBg;
  
  // ==================== GRADIENT DEFINITIONS ====================
  static const LinearGradient classicLightGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // New: Deep Navy Dark Gradient
  static const LinearGradient deepNavyGradient = LinearGradient(
    colors: [Color(0xFF0066CC), Color(0xFF0052A3)], // Electric Blue to Deep Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient emeraldLuxeGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient royalGoldGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGreenGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy gradient names
  static const LinearGradient lightPrimaryGradient = classicLightGradient;
  static const LinearGradient darkPrimaryGradient = deepNavyGradient; // Updated
  
  // ==================== TEXT COLORS ====================
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFCBD5E1);
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

  // ==================== THEME BUILDERS ====================

  /// Get theme by name
  static ThemeData getThemeByName(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'classic light':
      case 'light':
        return lightTheme;
      case 'deep navy':
      case 'dark':
        return deepNavyTheme; // NEW
      case 'emerald luxe':
      case 'emerald':
        return emeraldTheme;
      case 'royal gold':
      case 'gold':
        return goldTheme;
      case 'aurora green':
        return auroraTheme;
      default:
        return lightTheme;
    }
  }

  /// Get gradient by theme name
  static LinearGradient getGradientByTheme(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
      case 'classic light':
        return lightPrimaryGradient;
      case 'dark':
      case 'deep navy':
        return deepNavyGradient; // NEW
      case 'gold':
      case 'royal gold':
        return royalGoldGradient;
      case 'emerald':
      case 'emerald luxe':
        return emeraldLuxeGradient;
      case 'aurora green':
        return auroraGreenGradient;
      default:
        return lightPrimaryGradient;
    }
  }

  /// Get chart colors by theme name
  static List<Color> getChartColorsByTheme(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
      case 'classic light':
        return [lightPrimary, lightAccent, Color(0xFF059669), Color(0xFF0891B2)];
      case 'dark':
      case 'deep navy':
        return [deepNavyPrimary, deepNavyAccent, Color(0xFF0EA5E9), Color(0xFF6366F1)];
      case 'gold':
      case 'royal gold':
        return [royalGoldPrimary, royalGoldSecondary, royalGoldAccent, Color(0xFFD4AF37)];
      case 'emerald':
      case 'emerald luxe':
        return [emeraldLuxePrimary, emeraldLuxeSecondary, emeraldLuxeAccent, Color(0xFF059669)];
      case 'aurora green':
        return [auroraGreenPrimary, auroraGreenSecondary, auroraGreenAccent, Color(0xFF06B6D4)];
      default:
        return [lightPrimary, lightAccent];
    }
  }

  // ==================== THEME 1: CLASSIC LIGHT ====================
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

  // ==================== THEME 2: DEEP NAVY (NEW DARK THEME) ====================
  static ThemeData get deepNavyTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: deepNavyPrimary,
      secondary: deepNavySecondary,
      tertiary: deepNavyAccent,
      background: deepNavyBackground,
      surface: deepNavySurface,
      cardBg: deepNavyCardBg,
      textColor: deepNavyTextPrimary,
      textSecondary: deepNavyTextSecondary,
      borderColor: deepNavyBorder,
    );
  }

  // Legacy: DARK (maps to Deep Navy)
  static ThemeData get darkTheme => deepNavyTheme;

  // ==================== THEME 3: EMERALD ====================
  static ThemeData get emeraldTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: emeraldLuxePrimary,
      secondary: emeraldLuxeSecondary,
      tertiary: emeraldLuxeAccent,
      background: emeraldLuxeBackground,
      surface: emeraldLuxeSurface,
      cardBg: emeraldLuxeCardBg,
      textColor: Color(0xFF1C4532),
      textSecondary: Color(0xFF5A7C6A),
    );
  }

  // ==================== THEME 4: GOLD ====================
  static ThemeData get goldTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: royalGoldPrimary,
      secondary: royalGoldSecondary,
      tertiary: royalGoldAccent,
      background: royalGoldBackground,
      surface: royalGoldSurface,
      cardBg: royalGoldCardBg,
      textColor: Color(0xFF5A4A2A),
      textSecondary: Color(0xFF8B7355),
    );
  }

  // ==================== THEME 5: AURORA GREEN ====================
  static ThemeData get auroraTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: auroraGreenPrimary,
      secondary: auroraGreenSecondary,
      tertiary: auroraGreenAccent,
      background: auroraGreenBackground,
      surface: auroraGreenSurface,
      cardBg: auroraGreenCardBg,
      textColor: Color(0xFF0D9488),
      textSecondary: Color(0xFF0891B2),
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
    Color? borderColor,
  }) {
    final effectiveBorderColor = borderColor ?? textSecondary.withOpacity(0.3);
    
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
        error: ragRed,
        onError: Colors.white,
        background: background,
        onBackground: textColor,
        surface: surface,
        onSurface: textColor,
        outline: effectiveBorderColor,
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
          side: BorderSide(
            color: effectiveBorderColor,
            width: 1,
          ),
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
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: effectiveBorderColor),
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
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: effectiveBorderColor,
        thickness: 1,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: textColor,
        size: 24,
      ),
    );
  }

  // ==================== UTILITY FUNCTIONS ====================
  
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
}