import 'package:intl/intl.dart';

class Event {
  final String id;
  final DateTime date;
  final String title;
  final String location;
  final List<String> attendees;
  final String image;
  final String? description;
  final String? link;

  Event({
    required this.id,
    required this.date,
    required this.title,
    required this.location,
    required this.attendees,
    required this.image,
    this.description,
    this.link,
  });

  String get day {
    return DateFormat('dd').format(date); // Trích xuất ngày
  }

  // Getter để lấy tháng dạng chữ (ví dụ: "Tháng 12")
  String get monthName {
    return DateFormat.MMMM('vi').format(date); // Định dạng tháng theo chữ
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(date); // Lấy giờ và phút từ `date`
  }

  // Phương thức để chuyển từ Map sang Event (JSON parse)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      location: map['location'],
      attendees: List<String>.from(map['attendees']),
      image: map['image'],
      description: map['description'],
      link: map['link'],
    );
  }

  // Phương thức để chuyển từ Event sang Map (JSON serialize)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'location': location,
      'attendees': attendees,
      'image': image,
      'description': description,
      'link': link,
    };
  }
}
