import 'package:dio/dio.dart';
import '../providers/dio_interceptor.dart';
import '../utils/constants.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5), // 5 giây
      receiveTimeout: const Duration(seconds: 30), // 3 giây
    ));

    // Thêm interceptor
    _dio.interceptors.add(DioInterceptor());
  }

  Future<Response> post(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    return await _dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers), // Thêm headers tại đây
    );
  }

  Future<Response> get(String endpoint,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(
      endpoint,
      options: Options(headers: headers),
      queryParameters: queryParameters, // Thêm queryParameters vào đây
    );
  }

  Future<Response> logout(String endpoint, String token) async {
    return await _dio.post(endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}
