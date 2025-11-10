import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: 'demo@finaxis.com');
  final passwordController = TextEditingController(text: 'demo123');
  final formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - accept any valid email/password
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = false;
      Get.offNamed('/ai-chat');
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
