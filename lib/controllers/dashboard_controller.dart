import 'package:get/get.dart';
import '../models/dashboard_model.dart';
import '../models/applicant_model.dart';
import '../services/dashboard_service.dart';
import '../services/applicant_service.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = DashboardService();
  final ApplicantService _applicantService = ApplicantService();

  final Rx<DashboardModel?> dashboardData = Rx<DashboardModel?>(null);
  final RxList<ApplicantModel> applicants = <ApplicantModel>[].obs;
  final RxList<ApplicantModel> filteredApplicants = <ApplicantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedRagFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      
      final dashboard = await _dashboardService.fetchDashboardData();
      final applicantsList = await _applicantService.fetchApplicants();
      
      dashboardData.value = dashboard;
      applicants.value = applicantsList;
      filteredApplicants.value = applicantsList;
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByRag(String ragStatus) {
    selectedRagFilter.value = ragStatus;
    if (ragStatus == 'all') {
      filteredApplicants.value = applicants;
    } else {
      filteredApplicants.value = applicants
          .where((applicant) => applicant.ragStatus.toLowerCase() == ragStatus.toLowerCase())
          .toList();
    }
  }

  void navigateToApplicantDetail(String cif) {
    Get.toNamed('/applicant/$cif');
  }
}
