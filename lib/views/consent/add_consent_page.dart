import 'dart:convert';
import 'package:finaxis_web/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;

class AddConsentPage extends StatefulWidget {
  const AddConsentPage({Key? key}) : super(key: key);

  @override
  State<AddConsentPage> createState() => _AddConsentPageState();
}

class _AddConsentPageState extends State<AddConsentPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController(text: '+971 ');
  final _emailCtrl = TextEditingController();
  final _emiratesIdCtrl = TextEditingController();
  final _loanAmountCtrl = TextEditingController();
  final _loanTenureCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _mobileCtrl.addListener(_formatMobileNumber);
  }

  void _formatMobileNumber() {
    String text = _mobileCtrl.text;
    
    // If user tries to delete the prefix, restore it
    if (!text.startsWith('+971 ')) {
      _mobileCtrl.value = TextEditingValue(
        text: '+971 ',
        selection: TextSelection.collapsed(offset: 5),
      );
      return;
    }
    
    // Extract only digits after +971
    String digits = text.substring(5).replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 8 digits
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }
    
    // Format the number
    String formatted = '+971 $digits';
    
    // Only update if different to avoid infinite loop
    if (formatted != text) {
      _mobileCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void dispose() {
    _mobileCtrl.removeListener(_formatMobileNumber);
    _fullNameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _emiratesIdCtrl.dispose();
    _loanAmountCtrl.dispose();
    _loanTenureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;

      // Theme-aware colors
      final bgColor = isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF5F7FA);

      final formCardBg = isDarkMode
          ? const Color(0xFF1E293B)
          : const Color(0xFFFFFFFF);

      final textColor = isDarkMode
          ? const Color(0xFFCBD5E1)
          : const Color(0xFF0F172A);

      final labelColor = isDarkMode
          ? const Color(0xFF94A3B8)
          : const Color(0xFF1B222C);

      final inputBgStart = isDarkMode
          ? Colors.white.withOpacity(0.05)
          : Colors.white.withOpacity(0.6);

      final inputBgEnd = isDarkMode
          ? Colors.white.withOpacity(0.02)
          : Colors.white.withOpacity(0.3);

      final inputTextColor = isDarkMode
          ? const Color(0xFFCBD5E1)
          : const Color(0xFF0F172A);

      final inputIconColor = isDarkMode
          ? const Color(0xFF0066CC)
          : const Color(0xFF3B82F6);

      final inputHintColor = isDarkMode
          ? const Color(0xFF64748B)
          : const Color(0xFFB0B9C3);

      final gradientStart = isDarkMode
          ? const Color(0xFF1E293B).withOpacity(0.5)
          : const Color(0xFF1E3A8A).withOpacity(0.5);

      final infoBg = isDarkMode
          ? const Color(0xFF0EA5E9).withOpacity(0.1)
          : const Color(0xFF0EA5E9).withOpacity(0.1);

      final infoText = isDarkMode
          ? const Color(0xFF94A3B8)
          : const Color(0xFF475569);

      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Animated Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E3A8A).withOpacity(0.5),
                        ]
                      : [
                          const Color(0xFFF5F7FA),
                          const Color(0xFFE0E7FF).withOpacity(0.5),
                        ],
                ),
              ),
            ),
            // Floating elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            const Color(0xFF3B82F6).withOpacity(0.2),
                            const Color(0xFF1E40AF).withOpacity(0.1),
                          ]
                        : [
                            const Color(0xFF3B82F6).withOpacity(0.1),
                            const Color(0xFF1E40AF).withOpacity(0.05),
                          ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            const Color(0xFF0EA5E9).withOpacity(0.15),
                            const Color(0xFF06B6D4).withOpacity(0.05),
                          ]
                        : [
                            const Color(0xFF0EA5E9).withOpacity(0.1),
                            const Color(0xFF06B6D4).withOpacity(0.02),
                          ],
                  ),
                ),
              ),
            ),
            // Main Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // Header with Back Button and Title in same row
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Centered Title
                          Text(
                            "Consent Verification",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          // Back button on the left
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back,
                                color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                size: 24,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.15),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "Complete your verification to proceed with the loan request",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: 650,
                            child: Column(
                              children: [
                                // Form Card
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 1000),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, 40 * (1 - value)),
                                      child: Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isDarkMode
                                            ? [
                                                formCardBg.withOpacity(0.95),
                                                const Color(0xFF334155).withOpacity(0.98),
                                              ]
                                            : [
                                                const Color(0xFFFFFFFF).withOpacity(0.95),
                                                const Color(0xFFF8FAFC).withOpacity(0.98),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isDarkMode
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3B82F6).withOpacity(isDarkMode ? 0.1 : 0.15),
                                          blurRadius: 40,
                                          offset: const Offset(0, 20),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Loan Application Details",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Row 1: Full Name & Mobile
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Full Name",
                                                  controller: _fullNameCtrl,
                                                  placeholder: "John Doe",
                                                  icon: Icons.person_outline,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) => v?.isEmpty ?? true
                                                      ? "Full name is required"
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Mobile Number",
                                                  controller: _mobileCtrl,
                                                  placeholder: "+971 12345678",
                                                  icon: Icons.phone_in_talk_outlined,
                                                  keyboardType: TextInputType.phone,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) {
                                                    if (v == null || v.isEmpty || v == '+971 ')
                                                      return "Mobile number is required";
                                                    String digits = v.substring(5).replaceAll(RegExp(r'[^\d]'), '');
                                                    if (digits.length != 8)
                                                      return "Enter 8 digits after +971";
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          // Row 2: Email & Emirates ID
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Email Address",
                                                  controller: _emailCtrl,
                                                  placeholder: "john.doe@email.com",
                                                  icon: Icons.mail_outline,
                                                  keyboardType: TextInputType.emailAddress,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) {
                                                    if (v?.isEmpty ?? true)
                                                      return "Email is required";
                                                    if (!v!.contains('@'))
                                                      return "Enter a valid email";
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Emirates ID",
                                                  controller: _emiratesIdCtrl,
                                                  placeholder: "784-1234-5678901-2",
                                                  icon: Icons.credit_card_outlined,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) =>
                                                      v?.isEmpty ?? true
                                                          ? "Emirates ID is required"
                                                          : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          // Row 3: Loan Amount & Tenure
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Loan Amount (AED)",
                                                  controller: _loanAmountCtrl,
                                                  placeholder: "50,000",
                                                  icon: Icons.attach_money_outlined,
                                                  keyboardType: TextInputType.number,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) {
                                                    if (v?.isEmpty ?? true)
                                                      return "Amount required";
                                                    if (double.tryParse(
                                                            v!.replaceAll(',', '')) ==
                                                        null) return "Invalid amount";
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildGlassomorphicField(
                                                  label: "Tenure (months)",
                                                  controller: _loanTenureCtrl,
                                                  placeholder: "24",
                                                  icon: Icons.calendar_month_outlined,
                                                  keyboardType: TextInputType.number,
                                                  isDarkMode: isDarkMode,
                                                  labelColor: labelColor,
                                                  inputBgStart: inputBgStart,
                                                  inputBgEnd: inputBgEnd,
                                                  inputTextColor: inputTextColor,
                                                  inputIconColor: inputIconColor,
                                                  inputHintColor: inputHintColor,
                                                  validator: (v) {
                                                    if (v?.isEmpty ?? true)
                                                      return "Tenure required";
                                                    if (int.tryParse(v!) == null)
                                                      return "Invalid tenure";
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFF0EA5E9).withOpacity(0.1),
                                                  const Color(0xFF3B82F6).withOpacity(0.05),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFF0EA5E9)
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF0EA5E9)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.info_outline,
                                                    color: Color(0xFF0EA5E9),
                                                    size: 18,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    "Your information is secure and will only be used for consent verification.",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: infoText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Submit Button
                                          SizedBox(
                                            width: double.infinity,
                                            child: _buildGradientButton(
                                              label: "Generate Consent",
                                              onPressed: _isSubmitting ? null : _onSubmit,
                                              isLoading: _isSubmitting,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGlassomorphicField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required bool isDarkMode,
    required Color labelColor,
    required Color inputBgStart,
    required Color inputBgEnd,
    required Color inputTextColor,
    required Color inputIconColor,
    required Color inputHintColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: labelColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [inputBgStart, inputBgEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(isDarkMode ? 0.05 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: inputIconColor,
                size: 20,
              ),
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: inputHintColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: inputTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  try {
    _showLoadingDialog();

    /// 1️⃣ Call login API
    // final loginResponse = await _callLoginApi();

    Navigator.pop(context); // close loader

    // if (loginResponse == null || loginResponse['status'] != 200) {
    //   _showErrorDialog("Login failed: ${loginResponse?['message']}");
    //   return;
    // }

    // /// Extract URL from response
    // final String redirectUrl =
    //     loginResponse["moreInfo"]?["data"] ?? "";

    // if (redirectUrl.isEmpty) {
    //   _showErrorDialog("Invalid redirect URL received.");
    //   return;
    // }

    // /// 2️⃣ Call email API with body containing redirect URL
    // _showLoadingDialog();

    final emailResponse = await _callEmailApi(
      subject: "Consent Registration",
      to: _emailCtrl.text,
      body: "Consent Redirect Link:\n https://sandbox-finaxis.bancify.me/#/customer-auth",
    );

    // Navigator.pop(context); // close loader

    if (emailResponse == null || emailResponse['status'] != 200) {
      _showErrorDialog("Email sending failed: ${emailResponse?['message']}");
      return;
    }

    /// SUCCESS
    _showSuccessDialog();

  } catch (e) {
    _showErrorDialog(e.toString());
  } finally {
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}
Future<Map<String, dynamic>?> _callLoginApi() async {
  final url = Uri.parse(
    "https://sandbox-finaxis.bancify.me/finaxis/auth/v1/login",
  );

  final payload = {
    "organisationId": "233bcd1d-4216-4b3c-a362-9e4a9282bba7",
    "baseConsentId": "ravi",
  };

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "x-clientId": "testClient",
    },
    body: jsonEncode(payload),
  );
print(response.body);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Login failed: ${response.body}");
}
Future<Map<String, dynamic>?> _callEmailApi({
  required String subject,
  required String to,
  required String body,
}) async {
  final url = Uri.parse(
    "https://sandbox-finaxis.bancify.me/finaxis/email/v1/send",
  );

  final payload = {
    "subject": subject,
    "to": to,
    "body": body,
  };

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "x-clientId": "testClient",
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Email API failed: ${response.body}");
}


  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UnconstrainedBox(
        child: SizedBox(
          width: 420,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF3B82F6).withOpacity(0.1),
                                const Color(0xFF0EA5E9).withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF3B82F6),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        const Icon(
                          Icons.shield_rounded,
                          size: 32,
                          color: Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Processing Your Request",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait while we verify your information",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UnconstrainedBox(
        child: SizedBox(
          width: 420,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF16A34A),
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Consent Generated Successfully",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "A consent request has been sent to ${_emailCtrl.text}. The customer can now review and approve the request.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF0EA5E9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                          _fullNameCtrl.clear();
                          _mobileCtrl.clear();
                          _emailCtrl.clear();
                          _emiratesIdCtrl.clear();
                          _loanAmountCtrl.clear();
                          _loanTenureCtrl.clear();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Done",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (_) => UnconstrainedBox(
        child: SizedBox(
          width: 380,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Color(0xFFDC2626),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Something Went Wrong",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF0EA5E9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Retry",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}