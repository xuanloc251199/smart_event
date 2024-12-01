import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<Response> register(Map<String, dynamic> data) async {
    return await apiService.post('/register', data, headers: {});
  }

  Future<Response> login(Map<String, dynamic> data) async {
    return await apiService.post('/login', data, headers: {});
  }

  Future<Response> getProfile(String token) async {
    return await apiService.get(
      '/user',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    // API gọi cập nhật thông tin người dùng
    return await apiService.post(
      '/update-user-detail',
      data,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> updateAvatar(String token, FormData formData) async {
    // API gọi cập nhật avatar
    return await apiService.post(
      '/update-avatar',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> saveFaceData(String token, FormData formData) async {
    return await apiService.post(
      '/save-face-data',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> uploadFaceData(String token, FormData formData) async {
    return await apiService.post(
      '/save-face-data',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> logout(String token) async {
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
}
