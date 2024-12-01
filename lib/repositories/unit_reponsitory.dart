import 'package:smart_event/services/api_service.dart';

class UnitRepository {
  final ApiService apiService;

  UnitRepository(this.apiService);

  Future<List<dynamic>> getUnits() async {
    final response = await apiService.get('/units');
    if (response.statusCode == 200) {
      return response.data; // Đảm bảo response.data là List
    } else {
      throw Exception('Failed to fetch units');
    }
  }
}
