import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../theme/app_theme.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:  [
                    // Logo/Title
                    const Icon(
                      Icons.account_balance,
                      size: 64,
                      color: AppTheme.lightAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Finaxis',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Financial Analytics Platform',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Field
                    Obx(() => TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: controller.obscurePassword.value,
                      validator: controller.validatePassword,
                    )),
                    const SizedBox(height: 8),
                    
                    // Remember Me
                    Obx(() => CheckboxListTile(
                      title: const Text('Remember Me'),
                      value: controller.rememberMe.value,
                      onChanged: controller.toggleRememberMe,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    )),
                    const SizedBox(height: 24),
                    
                    // Login Button
                    Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Login'),
                    )),
                    const SizedBox(height: 16),
                    
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
