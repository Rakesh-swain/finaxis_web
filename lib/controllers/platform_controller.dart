import 'package:get/get.dart';

enum PlatformType { lending, billing }

/// 🚀 Platform Controller - Manages platform switching & routing
class PlatformController extends GetxController {
  final currentPlatform = PlatformType.lending.obs;

  // Platform-specific labels
  Map<String, String> get navigationLabels {
    if (currentPlatform.value == PlatformType.lending) {
      return {
        'applicants': 'Applicants',
        'consents': 'Consents',
      };
    } else {
      return {
        'applicants': 'Requests',
        'consents': 'Payment',
      };
    }
  }

  // Sidebar title
  String get sidebarTitle {
    return currentPlatform.value == PlatformType.lending
        ? 'Finaxis'
        : 'FinAxis';
  }

  // Sidebar subtitle
  String get sidebarSubtitle {
    return currentPlatform.value == PlatformType.lending
        ? 'Smart Lending Platform'
        : 'Smart Billing Platform';
  }

  // Platform-specific routes - NEW ADDITION
  Map<int, String> get platformRoutes {
    if (currentPlatform.value == PlatformType.lending) {
      return {
        0: '/ai-chat',      // AI Chat Hub
        1: '/dashboard',    // Dashboard
        2: '/consent',      // Consents (Lending)
        3: '/applicants',   // Applicants
        4: '/transactions'
      };
    } else {
      return {
        0: '/ai-chat',      // AI Chat Hub
        1: '/dashboard',    // Dashboard
        2: '/applicants',     // Requests (Billing - different from Applicants)
        3: '/transactions',        // Bills/Payment (Billing - different from Consents)
      };
    }
  }

  // Get route by index
  String getRoute(int index) {
    return platformRoutes[index] ?? '/dashboard';
  }

  // Dashboard metrics labels - LENDING PLATFORM
  Map<String, String> get lendingMetrics {
    return {
      'metric1': 'Total Consent Requests',
      'metric2': 'Consents Granted',
      'metric3': 'Consents Pending',
      'metric1_today': 'Total Consent Requests (Today)',
      'metric2_today': 'Consents Granted (Today)',
      'metric3_today': 'Consents Pending (Today)',
      'metric1_week': 'Total Consent Requests (Week)',
      'metric2_week': 'Consents Granted (Week)',
      'metric3_week': 'Consents Pending (Week)',
      'metric1_month': 'Total Consent Requests (30 Days)',
      'metric2_month': 'Consents Granted (Total Active)',
      'metric3_month': 'Consents Pending Action',
    };
  }

  // Dashboard metrics labels - BILLING PLATFORM (EMI)
  Map<String, String> get billingMetrics {
    return {
      'metric1': 'Total EMIs',
      'metric2': 'Active EMIs',
      'metric3': 'Pending EMIs',
      'metric1_today': 'Total EMIs (Today)',
      'metric2_today': 'Active EMIs (Today)',
      'metric3_today': 'Pending EMIs (Today)',
      'metric1_week': 'Total EMIs (Week)',
      'metric2_week': 'Active EMIs (Week)',
      'metric3_week': 'Pending EMIs (Week)',
      'metric1_month': 'Total EMIs (30 Days)',
      'metric2_month': 'Active EMIs (Total Active)',
      'metric3_month': 'Pending EMIs Action',
    };
  }

  /// Switch platform
  void switchPlatform(PlatformType platform) {
    currentPlatform.value = platform;
    print('Platform switched to: ${platform.name}');
  }

  /// Get label by key
  String getLabel(String key) {
    return navigationLabels[key] ?? key;
  }

  /// Get metric by key
  String getMetric(String key) {
    if (currentPlatform.value == PlatformType.billing) {
      return billingMetrics[key] ?? key;
    }
    return lendingMetrics[key] ?? key;
  }

  /// Check if lending platform
  bool get isLending => currentPlatform.value == PlatformType.lending;

  /// Check if billing platform
  bool get isBilling => currentPlatform.value == PlatformType.billing;
}