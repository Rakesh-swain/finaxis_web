import 'package:get/get.dart';
import '../models/applicant_model.dart';
import '../services/applicant_service.dart';

class ApplicantDetailController extends GetxController {
  final ApplicantService _service = ApplicantService();

  final RxList<ApplicantDetailModel> applicantDetailList = <ApplicantDetailModel>[].obs;
  final Rxn<ApplicantDetailModel> currentApplicant = Rxn<ApplicantDetailModel>();
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  String? currentCif;

  @override
  void onInit() {
    super.onInit();
    currentCif = Get.parameters['cif'];
    fetchApplicantDetails();
  }

  Future<void> fetchApplicantDetails() async {
    // try {
      isLoading.value = true;
      
      // This now works because service returns List<ApplicantDetailModel>
      final data = await _service.fetchApplicantDetails();
      applicantDetailList.assignAll(data);
      
      // Find the specific applicant by CIF
      if (currentCif != null && currentCif!.isNotEmpty) {
        final detail = applicantDetailList.firstWhereOrNull(
          (d) => d.applicant.cif == currentCif,
        );
        
        if (detail != null) {
          currentApplicant.value = detail;
        } else {
          Get.snackbar(
            'Error',
            'Applicant with Application No. $currentCif not found',
            snackPosition: SnackPosition.BOTTOM,
          );
          // Show first applicant instead of going back
          if (applicantDetailList.isNotEmpty) {
            currentApplicant.value = applicantDetailList.first;
          }
        }
      } else if (applicantDetailList.isNotEmpty) {
        currentApplicant.value = applicantDetailList.first;
      }
    // } catch (e) {
    //   print('Error in fetchApplicantDetails: $e');
    //   Get.snackbar(
    //     'Error',
    //     'Failed to load applicant details: $e',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
    isLoading.value = false;
  }

  void switchToApplicant(String cif) {
    final detail = applicantDetailList.firstWhereOrNull(
      (d) => d.applicant.cif == cif,
    );
    
    if (detail != null) {
      currentApplicant.value = detail;
      currentCif = cif;
      selectedTabIndex.value = 0;
    }
  }

  List<Map<String, String>> getAllApplicants() {
    return applicantDetailList.map((d) => {
      'cif': d.applicant.cif,
      'name': d.applicant.name,
    }).toList();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  ApplicantDetailModel? get applicantDetail => currentApplicant.value;
}