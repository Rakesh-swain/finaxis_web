import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// 🎨 Branding Model
class BrandingData {
  final String brandName;
  final String tagline;
  final IconData icon;
  final List<String> navigationLabels;

  BrandingData({
    required this.brandName,
    required this.tagline,
    required this.icon,
    required this.navigationLabels,
  });
}

/// 🎯 Branding Controller with Auto-Swap
class BrandingController extends GetxController {
  late Rx<BrandingData> currentBranding;
  late Rx<String> currentBrandKey;

  // Predefined branding options
  static final Map<String, BrandingData> brandingOptions = {
    'finaxis': BrandingData(
      brandName: 'Finaxis',
      tagline: 'Smart Lending Platform',
      icon: Icons.switch_right,
      navigationLabels: [
        'Finaxis AI',
        'Dashboard',
        'Applicants',
        'Consents',
      ],
    ),
    'billing': BrandingData(
      brandName: 'Finaxis',
      tagline: 'Smart Billing Platform',
      icon: Icons.switch_left,
      navigationLabels: [
        'Finaxis AI',
        'Dashboard',
        'Requests',
        'Payments',
      ],
    ),
  };

  @override
  void onInit() {
    super.onInit();
    // Initialize with default branding
    currentBrandKey = 'finaxis'.obs;
    currentBranding = brandingOptions['finaxis']!.obs;
  }

  /// Toggle between two branding options automatically
  void toggleBranding() {
    final newKey = currentBrandKey.value == 'finaxis' ? 'billing' : 'finaxis';
    changeBranding(newKey);
  }

  /// Change branding by key
  void changeBranding(String brandKey) {
    if (brandingOptions.containsKey(brandKey)) {
      currentBrandKey.value = brandKey;
      currentBranding.value = brandingOptions[brandKey]!;
    }
  }

  /// Add custom branding
  void addCustomBranding(String key, BrandingData branding) {
    brandingOptions[key] = branding;
  }

  /// Get all available brandings
  List<String> getAvailableBrandings() {
    return brandingOptions.keys.toList();
  }

  /// Get current branding key
  String getCurrentBrandKey() {
    return currentBrandKey.value;
  }
}