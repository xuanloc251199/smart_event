class ApiResponse {
  bool success;
  dynamic data;
  String? message;

  ApiResponse({this.success = false, this.data, this.message});

  factory ApiResponse.success(dynamic data) {
    return ApiResponse(success: true, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(success: false, message: message);
  }
}
