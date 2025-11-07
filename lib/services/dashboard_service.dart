import '../models/dashboard_model.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<DashboardModel> fetchDashboardData() async {
    // TODO: Replace with actual API endpoint
    // final response = await _apiService.get('/api/dashboard');
    
    final data = await _apiService.loadJsonAsset('assets/mock_data/dashboard.json');
    return DashboardModel.fromJson(data);
  }
}
