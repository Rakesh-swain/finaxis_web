import 'package:finaxis_web/billings/screens/main_screen.dart';
import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:finaxis_web/views/applicant/applicants_view.dart';
import 'package:finaxis_web/views/dashboard/assessment_dashboard_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'theme/futuristic_themes.dart';
import 'routes/app_pages.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage for persistent data
  await GetStorage.init();
  runApp(const FinaxisApp());
}

class FinaxisApp extends StatelessWidget {
  const FinaxisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Theme Controller globally
    final themeController = Get.put(ThemeController(), permanent: true);
    Get.put(ApplicantsController());
    Get.put(PlatformController());
    Get.put(AssessmentDashboardController());
    
    // Determine initial route based on URL
    String initialRoute = _getInitialRoute();
    
    return Obx(() => GetMaterialApp(
      title: 'Finaxis - Financial Analytics Platform',
      debugShowCheckedModeBanner: false,
      theme: themeController.getThemeData(),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ));
  }
  
  /// Determine initial route based on the current URL
  String _getInitialRoute() {
    final uri = Uri.base;
    final path = uri.path;
    
    // Check if customer-auth is in the URL path
    if (path.contains('customer-auth')) {
      return '/customer-auth';
    }
    else if (path.contains('customer-transaction')) {
      return '/customer-transaction';
    }
    
    // Default to login
    return AppPages.initial;
  }
}