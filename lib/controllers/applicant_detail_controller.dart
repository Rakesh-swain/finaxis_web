import 'package:get/get.dart';
import '../models/applicant_model.dart';
import '../services/applicant_service.dart';

class ApplicantDetailController extends GetxController {
  final ApplicantService _applicantService = ApplicantService();

  final Rx<ApplicantDetailModel?> applicantDetail = Rx<ApplicantDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  late String cif;

  @override
  void onInit() {
    super.onInit();
    cif = Get.parameters['cif'] ?? '';
    if (cif.isNotEmpty) {
      fetchApplicantDetail();
    }
  }

  Future<void> fetchApplicantDetail() async {
    try {
      isLoading.value = true;
      final detail = await _applicantService.fetchApplicantDetail(cif);
      applicantDetail.value = detail;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load applicant details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
