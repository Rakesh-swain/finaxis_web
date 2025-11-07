import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

/// Global Theme Controller with 5 Premium Themes
class ThemeController extends GetxController {
  // Available themes
  static const List<String> availableThemes = [
    'Light',
    'Dark',
    'Gold',
    'Emerald',
    'Royal',
  ];

  // Current theme index
  final RxInt _currentThemeIndex = 0.obs;
  
  // Getter for current theme index
  int get currentThemeIndex => _currentThemeIndex.value;
  
  // Reactive theme name
  String get currentThemeName => availableThemes[_currentThemeIndex.value];
  
  // Quick access for dark mode check
  bool get isDarkMode => _currentThemeIndex.value == 1;

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    // In production, load from SharedPreferences
    // final savedIndex = GetStorage().read('theme_index') ?? 0;
    // _currentThemeIndex.value = savedIndex;
    _currentThemeIndex.value = 0;
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

  /// Toggle between Light and Dark (legacy support)
  void toggleTheme() {
    _currentThemeIndex.value = isDarkMode ? 0 : 1;
    _applyTheme();
    _saveTheme();
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
    return AppTheme.getThemeByName(currentThemeName);
  }

  /// Get chart colors for current theme
  List<Color> getChartColors() {
    return AppTheme.getChartColorsByTheme(currentThemeName);
  }

  /// Get gradient for current theme
  LinearGradient getPrimaryGradient() {
    return AppTheme.getGradientByTheme(currentThemeName);
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
  bool get isLightTheme => _currentThemeIndex.value == 0 || 
                           _currentThemeIndex.value == 2 || 
                           _currentThemeIndex.value == 3 || 
                           _currentThemeIndex.value == 4;
}