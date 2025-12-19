import 'package:finaxis_web/views/dashboard/assessment_dashboard_view.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
class AssessmentDashboardBinding extends Bindings {
  @override
  void dependencies() {
    final caseId = Get.parameters['caseId'] ?? 'LMS-2024-45892';
    Get.lazyPut<AssessmentDashboardController>(
      () => AssessmentDashboardController(),
    );
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }
  }
}