import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<dio.Response> register(Map<String, dynamic> data) async {
    return await apiService.post('/register', data, headers: {});
  }

  Future<dio.Response> login(Map<String, dynamic> data) async {
    return await apiService.post('/login', data, headers: {});
  }

  Future<dio.Response> getProfile(String token) async {
    return await apiService.get(
      '/user',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<dio.Response> updateProfile(dio.FormData formData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    return await apiService.post(
      '/update-user-detail',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<dio.Response> updateAvatar(String token, dio.FormData formData) async {
    // API gọi cập nhật avatar
    return await apiService.post(
      '/update-avatar',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // Future<dio.Response> saveFaceData(String token, dio.FormData formData) async {
  //   return await apiService.post(
  //     '/save-face-data',
  //     formData,
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  // }

  Future<dio.Response> uploadFaceData(
      String token, dio.FormData formData) async {
    return await apiService.post(
      '/save-face-data',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<dio.Response> logout(String token) async {
    return await apiService.post(
      '/logout',
      {},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<List<dynamic>> getFaculties() async {
    final response = await apiService.get('/faculties');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch faculties');
    }
  }

  Future<List<dynamic>> getClasses() async {
    final response = await apiService.get('/classes');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch classes');
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<dio.Response> saveFaceData(String token, dio.FormData formData) async {
    return await apiService.post(
      '/save-face-data',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<dio.Response> verifyFaceData(
      String token, dio.FormData formData) async {
    return await apiService.post(
      '/verify-face-data',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
