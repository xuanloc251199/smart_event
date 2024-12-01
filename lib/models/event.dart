import 'package:intl/intl.dart';
import 'package:smart_event/models/registrations.dart';

class Event {
  final String id;
  final DateTime date;
  final String title;
  final String location;
  final String? thumbnail;
  final String? description;
  final String? category;
  final String? startTime; // Thời gian bắt đầu
  final String? endTime; // Thời gian kết thúc
  final List<Registration> registrations;

  Event({
    required this.id,
    required this.date,
    required this.title,
    required this.location,
    this.thumbnail,
    this.description,
    this.category,
    this.startTime,
    this.endTime,
    required this.registrations,
  });

  // Chuyển từ JSON sang Event
  factory Event.fromJson(Map<String, dynamic> json) {
    final registrationsData = json['registrations'];
    List<Registration> parsedRegistrations = [];

    if (registrationsData is List) {
      parsedRegistrations = registrationsData
          .map((reg) => Registration.fromJson(reg as Map<String, dynamic>))
          .toList();
    }

    return Event(
      id: json['id']?.toString() ?? '',
      date: json['date'] != null
          ? DateFormat('d-M-y').parse(json['date'])
          : DateTime.now(), // Chuyển cột `date` sang DateTime
      title: json['title'] ?? 'No Title',
      location: json['location'] ?? 'No Location',
      thumbnail: json['thumbnail'],
      description: json['description'],
      category: json['category'],
      startTime: json['start_time'], // Lấy `start_time` dạng String
      endTime: json['end_time'], // Lấy `end_time` dạng String
      registrations: parsedRegistrations,
    );
  }

  // Getter để lấy ngày
  String get day {
    return DateFormat('dd').format(date);
  }

  // Getter để lấy tháng dưới dạng chữ
  String get monthName {
    return DateFormat.MMMM().format(date);
  }

  // Format ngày thành chuỗi
  String get formattedDate {
    final day = DateFormat('d').format(date);
    final month = DateFormat('MMMM', 'vi').format(date);
    final year = DateFormat('y').format(date);
    return '$day $month năm $year';
  }

  // Ghép `date` với `start_time` và `end_time` nếu cần
  DateTime? get startDateTime {
    if (startTime != null) {
      final parsedTime = DateFormat('HH:mm:ss').parse(startTime!);
      return DateTime(
          date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
    }
    return null;
  }

  DateTime? get endDateTime {
    if (endTime != null) {
      final parsedTime = DateFormat('HH:mm:ss').parse(endTime!);
      return DateTime(
          date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
    }
    return null;
  }

  String get weekday {
    return DateFormat.EEEE('vi').format(date); // Ví dụ: Thứ Hai
  }

  // Lấy thời gian bắt đầu dưới dạng HH:mm
  String get formattedStartTime {
    if (startTime != null) {
      final parsedTime = DateFormat('HH:mm:ss').parse(startTime!);
      return DateFormat('HH:mm').format(parsedTime); // Ví dụ: 09:00
    }
    return 'N/A'; // Nếu không có start_time
  }

  // Lấy thời gian kết thúc dưới dạng HH:mm
  String get formattedEndTime {
    if (endTime != null) {
      final parsedTime = DateFormat('HH:mm:ss').parse(endTime!);
      return DateFormat('HH:mm').format(parsedTime); // Ví dụ: 11:00
    }
    return 'N/A'; // Nếu không có end_time
  }

  // Ghép thứ, ngày, giờ bắt đầu và kết thúc thành chuỗi định dạng
  String get fullFormattedDateTime {
    return '$weekday, ${DateFormat('dd/MM/yyyy').format(date)} '
        '${formattedStartTime} - ${formattedEndTime}';
    // Ví dụ: Thứ Hai, 01/01/2025 09:00 - 11:00
  }

  // Kiểm tra nếu thời gian hiện tại nằm trong khoảng sự kiện
  bool isWithinEventTimeFrame() {
    final now = DateTime.now();
    final start = startDateTime ?? date;
    final end = endDateTime ??
        date.add(
            const Duration(hours: 2)); // Giả sử thời gian kết thúc cách 2 giờ
    return now.isAfter(start) && now.isBefore(end);
  }
}
