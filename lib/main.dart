import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'controllers/theme_controller.dart';

void main() {
  runApp(const FinaxisApp());
}

class FinaxisApp extends StatelessWidget {
  const FinaxisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Theme Controller globally
    final themeController = Get.put(ThemeController(), permanent: true);

    return Obx(() => GetMaterialApp(
      title: 'Finaxis - Financial Analytics Platform',
      debugShowCheckedModeBanner: false,
      theme: themeController.getThemeData(),
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ));
  }
}