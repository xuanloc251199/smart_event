import 'package:smart_event/resources/images.dart';

class Registration {
  final int userId;
  final String fullName;
  final String avatar;
  final bool isRegister; // Thêm trường is_register
  final String? status; // Có thể null

  Registration({
    required this.userId,
    required this.fullName,
    required this.avatar,
    required this.isRegister,
    this.status,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      userId: json['user_id'],
      fullName: json['full_name'] ?? 'Unknown', // Lấy username từ user
      avatar: json['avatar'],
      isRegister: (json['is_register'] ?? 0) == 1, // Chuyển thành bool
      status: json['status'], // Có thể null
    );
  }

  String get formattedStatus {
    switch (status) {
      case 'checked_in':
        return 'Checked In';
      case 'absent':
        return 'Absent';
      case '':
      case null:
        return 'No Status';
      default:
        return 'Unknown Status';
    }
  }
}
