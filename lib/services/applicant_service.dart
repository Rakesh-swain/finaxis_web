import '../models/applicant_model.dart';
import 'api_service.dart';

class ApplicantService {
  final ApiService _apiService = ApiService();

  Future<List<ApplicantModel>> fetchApplicants() async {
    // TODO: Replace with actual API endpoint
    // final response = await _apiService.get('/api/applicants');
    
    final data = await _apiService.loadJsonListAsset('assets/mock_data/applicants.json');
    return data.map((json) => ApplicantModel.fromJson(json)).toList();
  }

  Future<ApplicantDetailModel> fetchApplicantDetail(String cif) async {
    // TODO: Replace with actual API endpoint
    // final response = await _apiService.get('/api/applicants/$cif');
    
    final data = await _apiService.loadJsonAsset('assets/mock_data/applicant_detail.json');
    return ApplicantDetailModel.fromJson(data);
  }
}
