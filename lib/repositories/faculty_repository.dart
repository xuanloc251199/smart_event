import 'package:smart_event/services/api_service.dart';

class FacultyRepository {
  final ApiService apiService;

  FacultyRepository(this.apiService);

  Future<List<dynamic>> getFaculties() async {
    final response = await apiService.get('/faculties');
    if (response.statusCode == 200) {
      return response.data; // Đảm bảo response.data là List
    } else {
      throw Exception('Failed to fetch faculties');
    }
  }
}
