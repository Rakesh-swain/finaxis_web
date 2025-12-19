import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../theme/app_theme.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
    
    // Responsive values
    final cardWidth = isMobile 
        ? MediaQuery.of(context).size.width * 0.9
        : isTablet 
            ? MediaQuery.of(context).size.width * 0.6
            : 450.0;
    
    final cardPadding = isMobile ? 24.0 : 40.0;
    final containerPadding = isMobile ? 16.0 : 32.0;
    final iconSize = isMobile ? 56.0 : 64.0;
    final spacingLarge = isMobile ? 24.0 : 40.0;
    final spacingMedium = isMobile ? 11.0 : 13.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     AppTheme.classicLightPrimary.withOpacity(0.1),
          //     AppTheme.classicLightPrimary.withOpacity(0.05),
          //   ],
          // ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height-40,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(containerPadding),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: cardWidth,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.classicLightPrimary.withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.95),
                                Colors.white.withOpacity(0.85),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(cardPadding),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Decorative Top Line
                                  // Container(
                                  //   height: 4,
                                  //   width: 60,
                                  //   decoration: BoxDecoration(
                                  //     gradient: LinearGradient(
                                  //       colors: [
                                  //         AppTheme.classicLightPrimary,
                                  //         AppTheme.classicLightPrimary.withOpacity(0.3),
                                  //       ],
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(2),
                                  //   ),
                                  //   margin: const EdgeInsets.only(bottom: 20),
                                  // ),
                                  
                                  // Logo/Title
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.classicLightPrimary,
                                          AppTheme.classicLightPrimary.withOpacity(0.7),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                                    child: Icon(
                                      Icons.account_balance,
                                      size: iconSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: spacingMedium),
                                  Text(
                                    'Finaxis',
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: isMobile ? 32 : 36,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.classicLightPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Financial Analytics Platform',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondaryLight,
                                      fontSize: isMobile ? 12 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: spacingLarge),
                                  
                                  // Email Field
                                  TextFormField(
                                    controller: controller.emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: AppTheme.classicLightPrimary,
                                      ),
                                      isDense: isMobile,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 12 : 16,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary.withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: AppTheme.classicLightPrimary.withOpacity(0.7),
                                        fontSize: isMobile ? 13 : 14,
                                      ),
                                      filled: true,
                                      fillColor: AppTheme.classicLightPrimary.withOpacity(0.03),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: controller.validateEmail,
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                  ),
                                  SizedBox(height: spacingMedium),
                                  
                                  // Password Field
                                  Obx(() => TextFormField(
                                    controller: controller.passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: AppTheme.classicLightPrimary,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.obscurePassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppTheme.classicLightPrimary,
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                        iconSize: isMobile ? 20 : 24,
                                      ),
                                      isDense: isMobile,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 12 : 16,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary.withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.classicLightPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: AppTheme.classicLightPrimary.withOpacity(0.7),
                                        fontSize: isMobile ? 13 : 14,
                                      ),
                                      filled: true,
                                      fillColor: AppTheme.classicLightPrimary.withOpacity(0.03),
                                    ),
                                    obscureText: controller.obscurePassword.value,
                                    validator: controller.validatePassword,
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                  )),
                                  SizedBox(height: 8),
                                  
                                  // Remember Me
                                  Obx(() => CheckboxListTile(
                                    title: Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        fontSize: isMobile ? 13 : 14,
                                        color: AppTheme.textSecondaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    value: controller.rememberMe.value,
                                    onChanged: controller.toggleRememberMe,
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    dense: isMobile,
                                    activeColor: AppTheme.lightAccent,
                                  )),
                                  SizedBox(height: spacingMedium),
                                  
                                  // Login Button
                                  Obx(() => Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: controller.isLoading.value
                                            ? [
                                                AppTheme.lightAccent.withOpacity(0.6),
                                                AppTheme.lightAccent.withOpacity(0.5),
                                              ]
                                            : [
                                                AppTheme.lightAccent,
                                                AppTheme.lightAccent.withOpacity(0.85),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.lightAccent.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value ? null : controller.login,
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: isMobile ? 12 : 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              height: isMobile ? 18 : 18,
                                              width: isMobile ? 18 : 20,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: isMobile ? 15 : 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
