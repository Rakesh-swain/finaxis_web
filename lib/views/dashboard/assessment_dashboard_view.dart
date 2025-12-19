import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../controllers/theme_controller.dart';
import '../../widgets/futuristic_layout.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// Assessment Dashboard Controller
class AssessmentDashboardController extends GetxController {
  AssessmentDashboardController();
  var editableEmail = 'sultan07@gmail.com'.obs;

  // LMS Data
  final lmsSource = 'Emirates NBD Digital Lending Platform'.obs;
  final customerId = 'CUST-892-4521'.obs;
  final appReference = 'ENBD-APP-87365'.obs;
  final dataReceived = '2024-12-15 14:32'.obs;
  final dataCompleteness = '100%'.obs;

  // Customer Profile
  final customerName = 'Mohammed Al Mansoori'.obs;
  final emiratesId = '784199XXXXXX'.obs;
  final nationality = 'Indian'.obs;
  final employmentStatus = 'Employed'.obs;
  final employmentSector = 'Private Sector'.obs;
  final primaryBank = 'Emirates NBD'.obs;
  final accountAge = '4.8 Years'.obs;

  // Financial Data
  final monthlyIncome = 34395.0.obs;
  final currentObligations = 15000.0.obs;
  final loanAmount = 150000.0.obs;
  final tenure = 60.obs;
  final interestRate = 0.0425; // 4.25% annual

  // Credit Score
  final aecbScore = 741.obs;

  // Calculated Metrics
  final foir = 0.0.obs;
  final dsr = 0.0.obs;
  final emi = 0.0.obs;

  // Decision
  final decisionStatus = ''.obs;
  final decisionClass = ''.obs;
  final riskAssessment = ''.obs;

  @override
  void onInit() {
    super.onInit();
    calculateMetrics();
    determineDecision();
  }

  void calculateMetrics() {
    final monthlyRate = interestRate / 12;
    final numPayments = tenure.value;

    // Calculate EMI using loan amortization formula
    final emiValue =
        (loanAmount.value *
            monthlyRate *
            math.pow(1 + monthlyRate, numPayments)) /
        (math.pow(1 + monthlyRate, numPayments) - 1);

    emi.value = 10000.00;

    // Calculate FOIR and DSR
    foir.value = 13.71;
    dsr.value =
        14.00;
  }

  void determineDecision() {
    if (aecbScore.value >= 700 && foir.value <= 40 && dsr.value <= 50) {
      decisionStatus.value = '✓ APPROVED';
      decisionClass.value = 'approved';
      riskAssessment.value = 'Low Risk Profile';
    } else if (aecbScore.value >= 600 || foir.value <= 50 || dsr.value <= 60) {
      decisionStatus.value = '⚠ UNDER REVIEW';
      decisionClass.value = 'review';
      riskAssessment.value = 'Medium Risk - Needs Manual Review';
    } else {
      decisionStatus.value = '✗ REJECTED';
      decisionClass.value = 'rejected';
      riskAssessment.value = 'High Risk Profile';
    }
  }

  Color getDecisionColor() {
    switch (decisionClass.value) {
      case 'approved':
        return Colors.green;
      case 'review':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getProgressColor(double value, double threshold1, double threshold2) {
    if (value <= threshold1) return Colors.green;
    if (value <= threshold2) return Colors.orange;
    return Colors.red;
  }

  void approveAndSync() {
    Get.snackbar(
      'Success',
      'Application approved and synced to LMS',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void requestMoreInfo() {
    Get.snackbar(
      'Info Request',
      'Additional information requested from applicant',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  void rejectCase() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Rejection'),
        content: const Text(
          'Are you sure you want to reject this application?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Rejected',
                'Application has been rejected',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                icon: const Icon(Icons.cancel, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

/// Assessment Dashboard View
class AssessmentDashboardView extends GetView<AssessmentDashboardController> {
  final String name;

  const AssessmentDashboardView({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataSourceCard(context, themeController, isDarkMode,name),
            const SizedBox(height: 24),
            _buildCustomerProfileCard(context, themeController, isDarkMode,name),
            const SizedBox(height: 24),
           name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container(): _buildFinancialDataCard(context, themeController, isDarkMode),
            name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container():const SizedBox(height: 24),
           name == "Saeed Marri" || name == "Sultan Al Harthi" ? Container():  _buildCalculationsCard(context, themeController, isDarkMode),
           name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container(): const SizedBox(height: 24),
           name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container():  _buildCreditScoreCard(context, themeController, isDarkMode),
           name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container():   const SizedBox(height: 24),
            name == "Saeed Marri" || name == "Sultan Al Harthi" || name == "Abdul Harthi" ? Container(): _buildDecisionCard(context, themeController, isDarkMode),
     
                  name == "Saeed Marri"  ?ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B7FFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.info_outline, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Awaiting for Customer Consent Confirmation',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ):Container(),
      name == "Abdul Harthi" ? Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeController
                      .getThemeData()
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.cancel,
                  color: themeController.getThemeData().primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Rejected",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              

            ],
          ),
          const SizedBox(height: 15),
           Text(
                "Application flagged due to Finaxis credit score of 520",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
        ],
      ),
    ):Container(),
          SizedBox(height: 100),
          ],
        ),
      );
    });
  }
Future<void> _onSubmit(BuildContext context,String email) async {

  try {
    _showLoadingDialog(context);

    /// 1️⃣ Call login API
    final loginResponse = await _callLoginApi();

    Navigator.pop(context); // close loader

    if (loginResponse == null || loginResponse['status'] != 200) {
      _showErrorDialog("Login failed: ${loginResponse?['message']}",context);
      return;
    }

    /// Extract URL from response
    final String redirectUrl =
        loginResponse["moreInfo"]?["data"] ?? "";

    if (redirectUrl.isEmpty) {
      _showErrorDialog("Invalid redirect URL received.",context);
      return;
    }

    /// 2️⃣ Call email API with body containing redirect URL
    _showLoadingDialog(context);

    final emailResponse = await _callEmailApi(
      subject: "Consent Registration",
      to: email,
      body: "Consent Redirect Link:\n$redirectUrl",
    );

    Navigator.pop(context); // close loader

    if (emailResponse == null || emailResponse['status'] != 200) {
      _showErrorDialog("Email sending failed: ${emailResponse?['message']}",context);
      return;
    }

    /// SUCCESS
    _showSuccessDialog(context);

  } catch (e) {
    Navigator.pop(context); // ensure loader closes
    _showErrorDialog(e.toString(),context);
  } finally {
 
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


  void _showLoadingDialog(BuildContext context) {
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

  void _showSuccessDialog(BuildContext context) {
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
                    "A consent request has been sent to ${controller.editableEmail.value}. The customer can now review and approve the request.",
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

  void _showErrorDialog(String error,BuildContext context) {
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

  Widget _buildStatusBadge(String statusClass) {
    Color bgColor;
    String text;

    switch (statusClass) {
      case 'approved':
        bgColor = Colors.green;
        text = 'APPROVED';
        break;
      case 'review':
        bgColor = Colors.orange;
        text = 'UNDER REVIEW';
        break;
      case 'rejected':
        bgColor = Colors.red;
        text = 'REJECTED';
        break;
      default:
        bgColor = Colors.blue;
        text = 'PROCESSING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }

  Widget _buildDataSourceCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    String name,
  ) {
    return _buildCard2(
      context,
      themeController,
      isDarkMode,
      title: name,
      subtitle: 'CUST-892-4521',
      icon: Icons.cloud_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.getThemeData().primaryColor.withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeController.getThemeData().primaryColor.withOpacity(
                  0.3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LMS INTEGRATION',
                  style: TextStyle(
                    color: themeController.getThemeData().primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    'Connected from: ${controller.lmsSource.value}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDataGrid([
            Obx(
              () => _buildDataCell(
                'Loan Amount',
                NumberFormat('#,###,##0.00').format(controller.loanAmount.value),
                isHighlighted: true,
                editIcon: Icons.edit_outlined,
                isDarkMode: isDarkMode,
                onEdit: () {},
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Application Reference',
                controller.appReference.value,
                isDarkMode: isDarkMode,
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Data Received',
                controller.dataReceived.value,
                isDarkMode: isDarkMode,
              ),
            ),
            Obx(
              () => _buildDataCell(
                'Data Completeness',
                controller.dataCompleteness.value,
                subtext: 'All required fields verified',
                isDarkMode: isDarkMode,
              ),
            ),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildCustomerProfileCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    String name
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      isDarkMode,
      title: 'Customer Profile',
      icon: Icons.person_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         name == "Sultan Al Harthi"? _buildDataGrid([
          _buildDataCell('Full Name', name, isDarkMode: isDarkMode),
            Obx(() => _buildDataCell('Emirates ID', controller.emiratesId.value, isDarkMode: isDarkMode)),
            Obx(() => _buildDataCell('Nationality', controller.nationality.value, isDarkMode: isDarkMode)),
            Obx(
              () => _buildDataCell(
                'Employment Status',
                controller.employmentStatus.value,
                subtext: controller.employmentSector.value,
                isDarkMode: isDarkMode,
              ),
            ),
            // Obx(() => _buildDataCell('Primary Bank', controller.primaryBank.value, isDarkMode: isDarkMode)),
            // Obx(() => _buildDataCell('Account Age', controller.accountAge.value, isDarkMode: isDarkMode)),
            name == "Sultan Al Harthi"
              ? Obx(()=>_buildDataCell(
           'Email',
            controller.editableEmail.value,
            isDarkMode: isDarkMode,
            editIcon: Icons.edit_outlined,
            onEdit: () {},
            onSave: (updatedEmail) {
              controller.editableEmail.value = updatedEmail;
              print("Updated Email: $updatedEmail");
            },
          ))
              : SizedBox(height:1),
          ]): _buildDataGrid([
          _buildDataCell('Full Name', name, isDarkMode: isDarkMode),
            Obx(() => _buildDataCell('Emirates ID', controller.emiratesId.value, isDarkMode: isDarkMode)),
            Obx(() => _buildDataCell('Nationality', controller.nationality.value, isDarkMode: isDarkMode)),
            Obx(
              () => _buildDataCell(
                'Employment Status',
                controller.employmentStatus.value,
                subtext: controller.employmentSector.value,
                isDarkMode: isDarkMode,
              ),
            ),
            // Obx(() => _buildDataCell('Primary Bank', controller.primaryBank.value, isDarkMode: isDarkMode)),
            // Obx(() => _buildDataCell('Account Age', controller.accountAge.value, isDarkMode: isDarkMode)),
           
          ]),
          SizedBox(height:20),
              name == "Sultan Al Harthi" ?ElevatedButton(
                onPressed: (){
                    _onSubmit(context, controller.editableEmail.value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7FFF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Send Consent',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ):SizedBox(height:1),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2);
  }

  Widget _buildFinancialDataCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      isDarkMode,
      title: 'Other Information',
      icon: Icons.account_balance_wallet_outlined,
      child: _buildDataGrid([
        Obx(
          () => _buildDataCell(
            'Monthly Income',
            NumberFormat('#,###,##0.00').format(controller.monthlyIncome.value),
            subtext: 'AED (Verified)',
            isHighlighted: true,
            isDarkMode: isDarkMode,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Current Obligations',
           NumberFormat('#,###,##0.00').format(controller.currentObligations.value),
            subtext: 'AED / month',
            isDarkMode: isDarkMode,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Requested Loan Amount',
            NumberFormat('####,##0.00').format(controller.loanAmount.value),
            subtext: 'AED',
            isHighlighted: true,
            isDarkMode: isDarkMode,
          ),
        ),
        Obx(
          () => _buildDataCell(
            'Requested Tenure',
            '${controller.tenure.value}',
            subtext: 'Months',
            isDarkMode: isDarkMode,
          ),
        ),
      ]),
    ).animate().fadeIn(duration: 600.ms, delay: 150.ms).slideY(begin: 0.2);
  }

  Widget _buildCalculationsCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      isDarkMode,
      title: 'Finaxis Insights',
      icon: Icons.calculate_outlined,
      child: Obx(
        () => Column(
          children: [
            _buildMetricBar(
              'FOIR (Fixed Obligation to Income)',
              'FOIR',
              'Target: ≤40%',
              name == "Abdul Harthi"?55.30:controller.foir.value,
              name == "Abdul Harthi"?62.30:35.20,
              40,
              50,
              controller.getProgressColor(name == "Abdul Harthi"?62.30:controller.foir.value, 30, 40),
              context,
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricBar(
              'DSR (Debt Service Ratio)',
              'DSR',
              'Target: ≤50%',
              name == "Abdul Harthi"?57.20:controller.dsr.value,
              name == "Abdul Harthi"?70.35:23.00,
              50,
              60,
              controller.getProgressColor(name == "Abdul Harthi"?70.35:controller.dsr.value, 40, 50),
              context,
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricContainer(
              'Calculated Monthly EMI',
              'Proposed Loan',
              NumberFormat('#,###').format(controller.emi.value),
              isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildMetricContainer(
              'Calculated Tenure',
              'Proposed Loan',
              '12 months',
              isDarkMode,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildCreditScoreCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      isDarkMode,
      title: 'Credit Score Analysis',
      icon: Icons.star_outline,
      child: Row(
          children: [
               Expanded(
              child: _buildScoreCard(
                'Our Score',
                '741',
                '✓ EXCELLENT',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'AECB Score',
                '712',
                '✓ EXCELLENT',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            // Expanded(
            //   child: _buildScoreCard(
            //     'Score Category',
            //     controller.aecbScore.value >= 750
            //         ? 'Excellent'
            //         : controller.aecbScore.value >= 700
            //         ? 'Very Good'
            //         : 'Good',
            //     '≥750 Required',
            //     controller.aecbScore.value >= 750
            //         ? Colors.green
            //         : Colors.orange,
            //     themeController,
            //     isDarkMode,
            //   ),
            // ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'Default Risk',
                'Low',
                'Historical Performance',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'Bureau Verification',
                'Verified',
                '✓ VALID',
                Colors.green,
                themeController,
                isDarkMode,
              ),
            ),
          ],
        ),
      
    ).animate().fadeIn(duration: 600.ms, delay: 250.ms).slideY(begin: 0.2);
  }

  Widget _buildDecisionCard(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return _buildCard2(
      subtitle: '',
      context,
      themeController,
      isDarkMode,
      title: 'Assessment Decision',
      icon: Icons.gavel_outlined,
      child: Obx(
        () => SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.getDecisionColor().withOpacity(0.1),
                      controller.getDecisionColor().withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: controller.getDecisionColor(),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      controller.decisionStatus.value,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: controller.getDecisionColor(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '✓ Finaxis Credit Score: ${controller.aecbScore.value}',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      '✓ FOIR: ${controller.foir.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                         fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      '✓ DSR: ${controller.dsr.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                         fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: Text(
                        'Risk Assessment: ${controller.riskAssessment.value}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'With an additional loan of AED 100,000.00, customer FOIR will be 35%. '
                      'This indicates low financial stress.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        height: 1.6,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   'Going beyond a loan of AED 250,000.00, customer FOIR will be 43% and may result in financial stress.',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.redAccent,
                    //     height: 1.6,
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Text(
                      '💡 Recommendation: A loan commitment between AED 100,000.00 and AED 200,000.00 is ideal based on your income analysis.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Row(
              //   children: [
              //     Expanded(
              //       child: ElevatedButton.icon(
              //         onPressed: controller.approveAndSync,
              //         icon: const Icon(Icons.check_circle_outline),
              //         label: const Text('APPROVE & SYNC TO LMS'),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: themeController
              //               .getThemeData()
              //               .primaryColor,
              //           foregroundColor: Colors.white,
              //           padding: const EdgeInsets.symmetric(vertical: 16),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: controller.requestMoreInfo,
              //         child: const Text('Request More Info'),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              //           foregroundColor: isDarkMode ? Colors.white : Colors.black87,
              //           padding: const EdgeInsets.symmetric(vertical: 16),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: controller.rejectCase,
              //         child: const Text('Reject Application'),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              //           foregroundColor: isDarkMode ? Colors.white : Colors.black87,
              //           padding: const EdgeInsets.symmetric(vertical: 16),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2);
  }

  Widget _buildCard2(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    final cardBg = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeController
                      .getThemeData()
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: themeController.getThemeData().primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              subtitle.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Customer Id:'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDataGrid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2,
      children: children,
    );
  }

  Widget _buildDataCell(
    String label,
    String value, {
    String? subtext,
    bool isHighlighted = false,
    VoidCallback? onEdit,
    IconData? editIcon,
    Function(String)? onSave,
    required bool isDarkMode,
  }) {
    final TextEditingController _controller = TextEditingController(text: value);
    final ValueNotifier<bool> _isEditing = ValueNotifier(false);
    final ValueNotifier<String> _displayValue = ValueNotifier(value);

    final cellBg = isHighlighted
        ? (isDarkMode ? Colors.blue.shade900 : Colors.blue.shade50)
        : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100);

    final cellBorder = isHighlighted
        ? (isDarkMode ? Colors.blue.shade700 : Colors.blue.shade200)
        : Colors.transparent;

    return ValueListenableBuilder<bool>(
      valueListenable: _isEditing,
      builder: (context, isEditing, _) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cellBg,
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted ? Border.all(color: cellBorder) : null,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isEditing)
                    TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: isHighlighted ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: isHighlighted
                            ? (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700)
                            : (isDarkMode ? Colors.white : Colors.black),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
                        ),
                      ),
                      maxLines: 1,
                    )
                  else
                    ValueListenableBuilder<String>(
                      valueListenable: _displayValue,
                      builder: (context, displayValue, _) {
                        return Text(
                          displayValue,
                          style: TextStyle(
                            fontSize: isHighlighted ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: isHighlighted
                                ? (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700)
                                : (isDarkMode ? Colors.white : Colors.black),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  if (subtext != null && !isEditing) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtext,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: isEditing
                    ? InkWell(
                        onTap: () {
                          _displayValue.value = _controller.text;
                          onSave?.call(_controller.text);
                          _isEditing.value = false;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    : onEdit != null
                        ? InkWell(
                            onTap: () {
                              _isEditing.value = true;
                              onEdit();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade500,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                editIcon ?? Icons.edit,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricContainer(
    String title,
    String subtitle,
    String value,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar(
    String name,
    String name2,
    String threshold,
    double value,
    double value2,
    double thresholdValue,
    double maxValue,
    Color color,
    BuildContext context,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    threshold,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showInfoDialog(context, name2, isDarkMode),
                child: Icon(
                  Icons.info_outline,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current $name2",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (value / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          name2 == "FOIR"?Container() :Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Post Approved $name2",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (value2 / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${value2.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String metricName, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metricName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (metricName == 'DSR')
                    _buildDSRTable(isDarkMode)
                  else if (metricName == 'FOIR')
                    _buildFOIRTable(isDarkMode)
                  else
                    Text(
                      'No information available',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDSRTable(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(['Range', 'Meaning', 'Action'], isDarkMode),
        _buildDSRRow('0–35%', 'Very strong', 'Easily eligible', Colors.green, isDarkMode),
        _buildDSRRow('35–45%', 'Good', 'Eligible with normal checks', Colors.blue, isDarkMode),
        _buildDSRRow('45–50%', 'Critical band', 'Eligible but tight; often lower amount or shorter tenure', Colors.orange, isDarkMode),
        _buildDSRRow('> 50%', 'Not allowed', 'Loan must be rejected/reduced', Colors.red, isDarkMode),
      ],
    );
  }

  Widget _buildFOIRTable(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(['Range', 'Category', 'Description'], isDarkMode),
        _buildFOIRRow('< 40%', 'Strong', 'Low fixed obligations', Colors.green, isDarkMode),
        _buildFOIRRow('40–50%', 'Acceptable', 'But risky', Colors.orange, isDarkMode),
        _buildFOIRRow('> 50%', 'Bad', 'Generally not favorable', Colors.red, isDarkMode),
      ],
    );
  }

  Widget _buildTableHeader(List<String> headers, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: headers.map((header) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                header,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDSRRow(String range, String meaning, String action, Color color, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                meaning,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                action,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFOIRRow(String range, String category, String description, Color color, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    String label,
    String value,
    String status,
    Color statusColor,
    ThemeController themeController,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}