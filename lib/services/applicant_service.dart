import '../models/applicant_model.dart';
import 'api_service.dart';

class ApplicantService {
  final ApiService _apiService = ApiService();

  /// Fetch list of applicants (for table view)
  Future<List<ApplicantModel>> fetchApplicants() async {
    // This expects a List
    final data = await _apiService.loadJsonListAsset(
      'assets/mock_data/applicants.json',
    );
    return data.map((json) => ApplicantModel.fromJson(json)).toList();
  }

  /// Fetch applicant details (now returns a List)
  Future<List<ApplicantDetailModel>> fetchApplicantDetails() async {
    // try {
      // Use loadJsonListAsset since the JSON is now an array
      final data = await _apiService.loadJsonListAsset(
        'assets/mock_data/applicant_detail.json',
      );
      
      // Map each item in the list to ApplicantDetailModel
      return data
          .map((item) => ApplicantDetailModel.fromJson(item as Map<String, dynamic>))
          .toList();
    // } catch (e) {
    //   print('Error in fetchApplicantDetails: $e');
    //   rethrow;
    // }
  }

  /// Fetch single applicant detail by CIF (alternative approach)
  Future<ApplicantDetailModel?> fetchApplicantDetailByCif(String cif) async {
    try {
      final data = await _apiService.loadJsonListAsset(
        'assets/mock_data/applicants_detail.json',
      );
      
      final applicantData = data.firstWhere(
        (item) => item['applicant']['cif'] == cif,
        orElse: () => null,
      );
      
      if (applicantData != null) {
        return ApplicantDetailModel.fromJson(applicantData as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error in fetchApplicantDetailByCif: $e');
      return null;
    }
  }
}