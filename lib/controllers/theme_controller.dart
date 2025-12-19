import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/futuristic_themes.dart';

/// Global Theme Controller with Light/Dark Toggle Support
class ThemeController extends GetxController {
  // Available themes - Gen-Z 2050 Design Language
  static const List<String> availableThemes = [
    'Classic Light',     // White + Mist Gray / Navy Blue + Deep Blue
    'Deep Navy',         // Dark theme - Deep Navy + Electric Blue (HTML-inspired)
    'Emerald Luxe',      // Mint + Emerald / Teal + Black Jade
    'Royal Gold',        // Cream + Gold / Charcoal + Amber
    'Aurora Green',      // Ice Blue + Jade / Deep Teal + Green Glow
  ];

  // Current theme index
  final RxInt _currentThemeIndex = 0.obs;
  
  // Getter for current theme index
  int get currentThemeIndex => _currentThemeIndex.value;
  
  // Reactive theme name
  String get currentThemeName => availableThemes[_currentThemeIndex.value];
  
  // Quick access for dark mode check
  bool get isDarkMode => _currentThemeIndex.value == 1; // Deep Navy is dark

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    // In production, load from SharedPreferences
    // final savedIndex = GetStorage().read('theme_index') ?? 0;
    // _currentThemeIndex.value = savedIndex;
    _currentThemeIndex.value = 0; // Default to Classic Light
  }

  /// Switch to a specific theme by name
  void switchTheme(String themeName) {
    final index = availableThemes.indexOf(themeName);
    if (index != -1) {
      _currentThemeIndex.value = index;
      _applyTheme();
      _saveTheme();
    }
  }

  /// Switch to a specific theme by index
  void switchThemeByIndex(int index) {
    if (index >= 0 && index < availableThemes.length) {
      _currentThemeIndex.value = index;
      _applyTheme();
      _saveTheme();
    }
  }

  /// Toggle between Light and Dark themes
  /// Light = Classic Light (index 0)
  /// Dark = Deep Navy (index 1)
  void toggleTheme([bool? forceDark]) {
    if (forceDark != null) {
      _currentThemeIndex.value = forceDark ? 1 : 0;
    } else {
      // Toggle: if currently dark (1), switch to light (0), otherwise switch to dark (1)
      _currentThemeIndex.value = (_currentThemeIndex.value == 1) ? 0 : 1;
    }
    _applyTheme();
    _saveTheme();
  }

  /// Quick toggle for settings icon
  void toggleLightDark() {
    toggleTheme();
  }

  void _applyTheme() {
    Get.changeTheme(getThemeData());
  }

  void _saveTheme() {
    // In production, save to SharedPreferences
    // GetStorage().write('theme_index', _currentThemeIndex.value);
  }

  /// Get current theme data
  ThemeData getThemeData() {
    return FuturisticThemes.getThemeByName(currentThemeName);
  }

  /// Get chart colors for current theme
  List<Color> getChartColors() {
    return FuturisticThemes.getChartColorsByTheme(currentThemeName);
  }

  /// Get gradient for current theme
  LinearGradient getPrimaryGradient() {
    return FuturisticThemes.getGradientByTheme(currentThemeName);
  }

  /// Get background gradient with opacity for pages
  LinearGradient getBackgroundGradient() {
    final baseGradient = getPrimaryGradient();
    return LinearGradient(
      colors: baseGradient.colors.map((c) => c.withOpacity(0.05)).toList(),
      begin: baseGradient.begin,
      end: baseGradient.end,
    );
  }

  /// Get card gradient for current theme
  LinearGradient getCardGradient() {
    final baseGradient = getPrimaryGradient();
    return LinearGradient(
      colors: baseGradient.colors.map((c) => c.withOpacity(0.1)).toList(),
      begin: baseGradient.begin,
      end: baseGradient.end,
    );
  }

  /// Check if current theme is light
  bool get isLightTheme => _currentThemeIndex.value != 1; // All except Deep Navy
}