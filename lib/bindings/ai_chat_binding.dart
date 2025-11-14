import 'package:finaxis_web/controllers/ai_controller.dart';
import 'package:get/get.dart';
import '../controllers/ai_chat_controller.dart';
import '../controllers/theme_controller.dart';

/// 🤖 AI Chat Binding - Dependency Injection for AI Chat Hub
class AiChatBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize Theme Controller if not already present
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }
    
    // Initialize AI Chat Controller
    Get.lazyPut<AiChatController>(() => AiChatController());
    Get.lazyPut<AiController>(() => AiController());
  }
}