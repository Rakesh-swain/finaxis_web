import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;

class PaymentAuthorizationPage extends StatefulWidget {
  const PaymentAuthorizationPage({Key? key}) : super(key: key);

  @override
  State<PaymentAuthorizationPage> createState() => _PaymentAuthorizationPageState();
}

class _PaymentAuthorizationPageState extends State<PaymentAuthorizationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emiratesIdCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController(text: '+971 ');
  final _emailCtrl = TextEditingController();
  final _loanAmountCtrl = TextEditingController();
  final _maxDebitCtrl = TextEditingController();
  final _monthlyLimitCtrl = TextEditingController();
  
  String? _loanPurpose;
  String? _tenure;
  String? _consentValidity;
  bool _consentChecked = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _mobileCtrl.addListener(_formatMobileNumber);
  }

  void _formatMobileNumber() {
    String text = _mobileCtrl.text;
    if (!text.startsWith('+971 ')) {
      _mobileCtrl.value = TextEditingValue(
        text: '+971 ',
        selection: TextSelection.collapsed(offset: 5),
      );
      return;
    }
    String digits = text.substring(5).replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }
    String formatted = '+971 $digits';
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
    _nameCtrl.dispose();
    _emiratesIdCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _loanAmountCtrl.dispose();
    _maxDebitCtrl.dispose();
    _monthlyLimitCtrl.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Animated Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F172A),
                  const Color(0xFF1E3A8A).withOpacity(0.5),
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
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.2),
                    const Color(0xFF1E40AF).withOpacity(0.1),
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
                  colors: [
                    const Color(0xFF0EA5E9).withOpacity(0.15),
                    const Color(0xFF06B6D4).withOpacity(0.05),
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
                  // Header
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
                        Text(
                          "Payment Authorization",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      "Complete your payment authorization for loan processing",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
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
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFFFFFFF).withOpacity(0.95),
                                const Color(0xFFF8FAFC).withOpacity(0.98),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer Information Section
                                _buildSectionHeader("Customer Information"),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Full Name",
                                        controller: _nameCtrl,
                                        placeholder: "John Doe",
                                        icon: Icons.person_outline,
                                        validator: (v) => v?.isEmpty ?? true
                                            ? "Full name is required"
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Emirates ID",
                                        controller: _emiratesIdCtrl,
                                        placeholder: "784-1234-5678901-2",
                                        icon: Icons.credit_card_outlined,
                                        validator: (v) => v?.isEmpty ?? true
                                            ? "Emirates ID is required"
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
                                        validator: (v) {
                                          if (v == null || v.isEmpty || v == '+971 ')
                                            return "Mobile is required";
                                          String digits = v.substring(5).replaceAll(RegExp(r'[^\d]'), '');
                                          if (digits.length != 8)
                                            return "Invalid mobile";
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Email Address",
                                        controller: _emailCtrl,
                                        placeholder: "john.doe@email.com",
                                        icon: Icons.mail_outline,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (v) {
                                          if (v?.isEmpty ?? true)
                                            return "Email is required";
                                          if (!v!.contains('@'))
                                            return "Enter a valid email";
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Loan Request Details Section
                                _buildSectionHeader("Loan Request Details"),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Loan Amount (AED)",
                                        controller: _loanAmountCtrl,
                                        placeholder: "50,000",
                                        icon: Icons.attach_money_outlined,
                                        keyboardType: TextInputType.number,
                                        validator: (v) {
                                          if (v?.isEmpty ?? true)
                                            return "Amount required";
                                          if (double.tryParse(v!.replaceAll(',', '')) == null)
                                            return "Invalid amount";
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGlassomorphicDropdown(
                                        label: "Loan Purpose",
                                        value: _loanPurpose,
                                        icon: Icons.category_outlined,
                                        items: const [
                                          "Personal Needs",
                                          "Home Improvement",
                                          "Education",
                                          "Business",
                                          "Medical",
                                          "Debt Consolidation"
                                        ],
                                        onChanged: (v) => setState(() => _loanPurpose = v),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGlassomorphicDropdown(
                                        label: "Tenure",
                                        value: _tenure,
                                        icon: Icons.calendar_month_outlined,
                                        items: const ["12 Months", "24 Months", "36 Months", "48 Months", "60 Months"],
                                        onChanged: (v) => setState(() => _tenure = v),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Payment Authorization Details Section
                                _buildSectionHeader("Payment Authorization Details"),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Max Debit Amount Allowed(AED)",
                                        controller: _maxDebitCtrl,
                                        placeholder: "10,000",
                                        icon: Icons.account_balance_wallet_outlined,
                                        keyboardType: TextInputType.number,
                                        validator: (v) => v?.isEmpty ?? true
                                            ? "Debit amount required"
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGlassomorphicField(
                                        label: "Monthly Debit Limit (AED)",
                                        controller: _monthlyLimitCtrl,
                                        placeholder: "5,000",
                                        icon: Icons.trending_up_outlined,
                                        keyboardType: TextInputType.number,
                                        validator: (v) => v?.isEmpty ?? true
                                            ? "Monthly limit required"
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(child: Container())
                                    // Expanded(
                                    //   child: _buildGlassomorphicDropdown(
                                    //     label: "Consent Validity",
                                    //     value: _consentValidity,
                                    //     icon: Icons.schedule_outlined,
                                    //     items: const ["3 Months", "6 Months", "12 Months"],
                                    //     onChanged: (v) => setState(() => _consentValidity = v),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Consent Checkbox
                                // Container(
                                //   padding: const EdgeInsets.all(14),
                                //   decoration: BoxDecoration(
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         const Color(0xFF0EA5E9).withOpacity(0.1),
                                //         const Color(0xFF3B82F6).withOpacity(0.05),
                                //       ],
                                //     ),
                                //     borderRadius: BorderRadius.circular(12),
                                //     border: Border.all(
                                //       color: const Color(0xFF0EA5E9).withOpacity(0.2),
                                //     ),
                                //   ),
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       SizedBox(
                                //         width: 24,
                                //         height: 24,
                                //         child: Checkbox(
                                //           value: _consentChecked,
                                //           onChanged: (v) => setState(() => _consentChecked = v ?? false),
                                //           activeColor: const Color(0xFF3B82F6),
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(6),
                                //           ),
                                //         ),
                                //       ),
                                //       const SizedBox(width: 12),
                                //       Expanded(
                                //         child: Text(
                                //           "I authorize this lender to access my financial data via Open Finance and set up payment instructions as per the details above.",
                                //           style: GoogleFonts.poppins(
                                //             fontSize: 12,
                                //             fontWeight: FontWeight.w500,
                                //             color: const Color(0xFF475569),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(height: 24),

                                // Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: const Color(0xFF3B82F6),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _formKey.currentState?.reset(),
                                            borderRadius: BorderRadius.circular(14),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              child: Text(
                                                "Clear Form",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF3B82F6),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: _buildGradientButton(
                                        label: "Initiate Payment Consent",
                                        onPressed: _isSubmitting ? null : _onSubmit,
                                        isLoading: _isSubmitting,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildGlassomorphicField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 27, 34, 44),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.08),
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
                color: const Color(0xFF3B82F6),
                size: 20,
              ),
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB0B9C3),
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
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassomorphicDropdown({
    required String label,
    required String? value,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 27, 34, 44),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF3B82F6),
                size: 20,
              ),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0F172A),
              ),
              hint: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Select $label",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB0B9C3),
                  ),
                ),
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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

  try {
    _showLoadingDialog();

    /// 1️⃣ Call login API
    // final loginResponse = await _callSingleApi();

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
      body: "Consent Redirect Link:\n https://sandbox-finaxis.bancify.me/#/customer-transaction",
    );

    // Navigator.pop(context); // close loader

    if (emailResponse == null || emailResponse['status'] != 200) {
      _showErrorDialog("Email sending failed: ${emailResponse?['message']}",);
      return;
    }
    Navigator.pop(context); 
    /// SUCCESS
    // _showSuccessDialog();

  } catch (e) {
    Navigator.pop(context); // ensure loader closes
    _showErrorDialog(e.toString());
  } finally {
 
  }
}

Future<Map<String, dynamic>?> _callSingleApi() async {
  final url = Uri.parse(
    "https://sandbox-finaxis.bancify.me/finaxis/payment-consent/v1/sip",
  );

  final payload = {
     "organisationId": "233bcd1d-4216-4b3c-a362-9e4a9282bba7",  
     "baseConsentId": "sam",
     "drAccountNo": "10000109010105",
     "crAccountNo": "10000109010101",
     "crBankCode": "10000109010101",
     "drAccountName": "Spectrum",
     "crAccountName": "bankicy",
     "drCurrencyCode": "AED",
     "naration": _loanPurpose??"Apple Phone purchase",
     "paymentPurposeCode": "ACM",
       "amount": "110.00"
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
                          Icons.lock_outline_rounded,
                          size: 32,
                          color: Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Initiating Payment Consent",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait while we process your authorization",
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
  void _showConsentErrorDialog() {
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
                      Icons.info_outline,
                      color: Color(0xFFDC2626),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Consent Required",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please accept the consent terms to proceed with payment authorization.",
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
                            "Understood",
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
                    "Authorization Successful",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Payment consent initiated for ${_nameCtrl.text}. Loan Amount: AED ${_loanAmountCtrl.text}",
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
                          setState(() {
                            _nameCtrl.clear();
                            _emiratesIdCtrl.clear();
                            _mobileCtrl.clear();
                            _emailCtrl.clear();
                            _loanAmountCtrl.clear();
                            _maxDebitCtrl.clear();
                            _monthlyLimitCtrl.clear();
                            _loanPurpose = null;
                            _tenure = null;
                            _consentValidity = null;
                            _consentChecked = false;
                          });
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