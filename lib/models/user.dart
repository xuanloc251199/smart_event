class User {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final String? sex;
  final String? phone;
  final String? dateOfBirth;
  final String? address;
  final String? permanentAddress;
  final String? avatar;
  final String? identityCard;
  final String? studentId;
  final int? unitId;
  final int? facultyId;
  final int? classId;
  final String? faceData;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.sex,
    this.phone,
    this.dateOfBirth,
    this.address,
    this.permanentAddress,
    this.avatar,
    this.identityCard,
    this.studentId,
    this.unitId,
    this.facultyId,
    this.classId,
    this.faceData,
  });

  // Từ JSON sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      sex: json['sex'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      address: json['address'] ?? '',
      permanentAddress: json['permanent_address'] ?? '',
      avatar: json['avatar'] ?? '',
      identityCard: json['identity_card'] ?? '',
      studentId: json['student_id'] ?? '',
      unitId: json['unit_id'] ?? 0,
      facultyId: json['faculty_id'] ?? 0,
      classId: json['class_id'] ?? 0,
      faceData: json['face_data'] ?? '',
    );
  }

  // Từ User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'sex': sex,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'address': address,
      'permanent_address': permanentAddress,
      'avatar': avatar,
      'identity_card': identityCard,
      'student_id': studentId,
      'unit_id': unitId,
      'faculty_id': facultyId,
      'class_id': classId,
      'face_data': faceData,
    };
  }
}
