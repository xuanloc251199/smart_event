import 'package:dio/dio.dart';

import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;
  ProfileRepository(this._apiService);

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await _apiService.get(
      '/user',
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.data; // Trả về dữ liệu user từ API
  }

  Future<List<dynamic>> getUnits() async {
    final response = await _apiService.get('/units');
    return response.data;
  }

  Future<List<dynamic>> getFaculties(int unitId) async {
    final response = await _apiService.get(
      '/faculties',
      queryParameters: {'unitId': unitId.toString()},
    );
    return response.data;
  }

  Future<List<dynamic>> getClasses(int facultyId) async {
    final response = await _apiService.get(
      '/classes',
      queryParameters: {'facultyId': facultyId.toString()},
    );
    return response.data;
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _apiService.post('/api/user/update', data);
  }
}
