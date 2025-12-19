import 'package:finaxis_web/controllers/platform_controller.dart';
import 'package:finaxis_web/models/branding_data_model.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    // Get.lazyPut<PlatformController>(() => PlatformController());
  }
}
