import 'package:smart_event/services/api_service.dart';

class ClassRepository {
  final ApiService apiService;

  ClassRepository(this.apiService);

  Future<List<dynamic>> getClasses() async {
    final response = await apiService.get('/classes');
    if (response.statusCode == 200) {
      return response.data; // Đảm bảo response.data là List
    } else {
      throw Exception('Failed to fetch classes');
    }
  }
}
