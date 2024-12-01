import 'package:dio/dio.dart';
import '../utils/constants.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Logging request details
    print("Request to: ${options.baseUrl}${options.path}");
    print("Method: ${options.method}");
    print("Headers: ${options.headers}");
    print("Data: ${options.data}");

    // Adding default headers (if needed)
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    // Pass to next handler
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Logging response details
    print(
        "Response from: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
    print("Status Code: ${response.statusCode}");
    print("Data: ${response.data}");

    // Pass to next handler
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Logging error details
    print("Error on: ${err.requestOptions.baseUrl}${err.requestOptions.path}");
    print("Error Type: ${err.type}");
    print("Error Message: ${err.message}");

    // Handle token expiration (optional)
    if (err.response?.statusCode == 401) {
      print("Unauthorized. Token might be expired.");
      // You can add logic here to refresh the token or logout the user.
    }

    // Pass to next handler
    super.onError(err, handler);
  }
}
