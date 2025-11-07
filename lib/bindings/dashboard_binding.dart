import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/theme_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
