import 'package:finaxis_web/views/dashboard/dashboard_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    // 📅 Date Filter Properties
  final selectedDateFilter = DateFilterType.month.obs;
  final fromDate = Rx<DateTime>(DateTime.now().subtract(const Duration(days: 30)));
  final toDate = Rx<DateTime>(DateTime.now());
  @override
  void onInit() {
    super.onInit();
     setDateFilter(DateFilterType.month);
    fetchDashboardData();
  }
void setDateFilter(DateFilterType filterType) {
  selectedDateFilter.value = filterType;

  final now = DateTime.now();

  switch (filterType) {
    case DateFilterType.today:
      final today = DateTime(now.year, now.month, now.day);
      fromDate.value = today;
      toDate.value = today;
      break;

    case DateFilterType.week:
      final endDate = DateTime(now.year, now.month, now.day);
      final startDate = endDate.subtract(const Duration(days: 6));
      fromDate.value = startDate;
      toDate.value = endDate;
      break;

    case DateFilterType.month:
      final endDate = DateTime(now.year, now.month, now.day);
      final startDate = endDate.subtract(const Duration(days: 30));
      fromDate.value = startDate;
      toDate.value = endDate;
      break;

    case DateFilterType.calendar:
      if (fromDate.value.isAfter(toDate.value)) {
        final endDate = DateTime(now.year, now.month, now.day);
        final startDate = endDate.subtract(const Duration(days: 30));
        fromDate.value = startDate;
        toDate.value = endDate;
      }
      break;
  }

  fetchDashboardData();
}

/// Set From Date
void setFromDate(DateTime date) {
  fromDate.value = date;

  // Validation: Ensure from date is not after to date
  if (date.isAfter(toDate.value)) {
    toDate.value = date;
  }

  // Only apply restrictions for non-calendar filters
  if (selectedDateFilter.value == DateFilterType.week) {
    // Limit to 7 days
    if (toDate.value.difference(date).inDays > 7) {
      toDate.value = date.add(const Duration(days: 7));
    }
  } else if (selectedDateFilter.value == DateFilterType.month) {
    // Limit to 30 days
    if (toDate.value.difference(date).inDays > 30) {
      toDate.value = date.add(const Duration(days: 30));
    }
  }
  // For calendar mode, allow any range without restrictions
}

/// Set To Date - UPDATED
void setToDate(DateTime date) {
  toDate.value = date;

  // Validation: Ensure to date is not before from date
  if (date.isBefore(fromDate.value)) {
    fromDate.value = date;
  }

  // Only apply restrictions for non-calendar filters
  if (selectedDateFilter.value == DateFilterType.week) {
    // Limit to 7 days
    if (date.difference(fromDate.value).inDays > 7) {
      fromDate.value = date.subtract(const Duration(days: 7));
    }
  } else if (selectedDateFilter.value == DateFilterType.month) {
    // Limit to 30 days
    if (date.difference(fromDate.value).inDays > 30) {
      fromDate.value = date.subtract(const Duration(days: 30));
    }
  }}

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
       final fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate.value);
      final toDateStr = DateFormat('yyyy-MM-dd').format(toDate.value);
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
