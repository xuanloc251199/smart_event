import 'package:smart_event/resources/strings.dart';

class Category {
  final int id;
  final String name;
  final String? description;
  final String thumbnail;

  Category({
    required this.id,
    required this.name,
    this.description,
    required this.thumbnail,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? AppString.appName,
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}
