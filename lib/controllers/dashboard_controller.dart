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
  
  // Sorting state for recent applicants table
  final RxInt recentApplicantsSortColumnIndex = 0.obs;
  final RxBool recentApplicantsSortAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      
      // Load dashboard data
      final dashboard = await _dashboardService.fetchDashboardData();
      dashboardData.value = dashboard;
      
      // Load applicants data
      final applicantsList = await _applicantService.fetchApplicants();
      print('Applicants loaded: ${applicantsList.length} applicants');
      applicants.value = applicantsList;
      filteredApplicants.value = applicantsList;
      
    } catch (e) {
      print('Dashboard loading error: $e');
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      );
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

  /// Sort recent applicants table by column
  void sortRecentApplicants(int columnIndex, bool ascending) {
    recentApplicantsSortColumnIndex.value = columnIndex;
    recentApplicantsSortAscending.value = ascending;
    
    final currentList = List<ApplicantModel>.from(filteredApplicants);
    
    switch (columnIndex) {
      case 0: // CIF
        currentList.sort((a, b) => ascending 
          ? a.cif.compareTo(b.cif) 
          : b.cif.compareTo(a.cif));
        break;
      case 1: // Name
        currentList.sort((a, b) => ascending 
          ? a.name.compareTo(b.name) 
          : b.name.compareTo(a.name));
        break;
      case 2: // Credit Score
        currentList.sort((a, b) => ascending 
          ? a.creditScore.compareTo(b.creditScore) 
          : b.creditScore.compareTo(a.creditScore));
        break;
      case 3: // Risk Status
        currentList.sort((a, b) => ascending 
          ? a.ragStatus.compareTo(b.ragStatus) 
          : b.ragStatus.compareTo(a.ragStatus));
        break;
      case 4: // Bank
        currentList.sort((a, b) => ascending 
          ? a.bankName.compareTo(b.bankName) 
          : b.bankName.compareTo(a.bankName));
        break;
      default:
        return; // Don't sort if column not recognized
    }
    
    filteredApplicants.value = currentList;
  }
}
