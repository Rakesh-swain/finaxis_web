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
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1E3A8A);
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: Colors.white,
     appBar:AppBar(
  automaticallyImplyLeading: true,
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.transparent, // make AppBar transparent
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          themeController.getThemeData().scaffoldBackgroundColor,
          themeController.getThemeData().primaryColor.withOpacity(0.02),
        ],
      ),
      border: Border(
        bottom: BorderSide(
          color: themeController.getThemeData().primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
    ),
  ),
  title: const Text(
    "Add Consent",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  ),
),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create New Consent",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: "Customer Name",
                    controller: _nameCtrl,
                    icon: Icons.person,
                    validator: (v) =>
                        v!.isEmpty ? "Please enter customer name" : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: "Mobile Number",
                    controller: _mobileCtrl,
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter mobile number";
                      if (v.length != 8) return "Enter valid 8-digit number";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildField(
                    label: "Bank Name",
                    controller: _bankCtrl,
                    icon: Icons.account_balance,
                    validator: (v) =>
                        v!.isEmpty ? "Please enter bank name" : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onSubmit,
                      icon: const Icon(Icons.send),
                      label: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool isMobileField = label == "Mobile Number";

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: isMobileField ? 8 : null,
      decoration: InputDecoration(
        counterText: "", // hide counter
        prefixIcon: Icon(icon, color: const Color(0xFF1E3A8A)),
        prefixText: isMobileField ? '+971 ' : null,
        prefixStyle: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

 Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  // 🔹 Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
                  strokeWidth: 6,
                ),
                const Icon(Icons.link, size: 40, color: Color(0xFF1E3A8A)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Sending consent link...',
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            repeatForever: true,
          ),
        ],
      ),
    ),
  );

  try {
    // 🔹 Prepare API data
    final url = Uri.parse('https://sandbox-finaxis.bancify.me/auth/v1/login');
    final headers = {
      'x-clientId': 'testClient',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    final body = jsonEncode({
      "organisationId": "233bcd1d-4216-4b3c-a362-9e4a9282bba7",
      "baseConsentId": 'ravi', // using name as consent ID
    });

    // 🔹 Send POST request
    final response = await http.post(url, headers: headers, body: body);

    Navigator.pop(context); // close loading

    if (response.statusCode == 200) {
      // Success
      final data = jsonDecode(response.body);
      debugPrint('✅ API Response: $data');
      _showSuccessDialog();
    } else {
      // Error response
      debugPrint('❌ API Error: ${response.statusCode} - ${response.body}');
      Get.snackbar(
        'Error',
        'Failed to send consent. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red.shade800,
      );
    }
  } catch (e) {
    Navigator.pop(context); // close loading dialog if error
    debugPrint('❌ Exception: $e');
    Get.snackbar(
      'Error',
      'Something went wrong: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.1),
      colorText: Colors.red.shade800,
    );
  }
}


  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Consent Link Sent',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Consent link sent to +971 ${_mobileCtrl.text}. The customer can now review and approve the request.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close success dialog
                  Get.back(); // return to consent list page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
