class Unit {
  final String id;
  final String fullName;
  final String abbreviation;

  Unit({
    required this.id,
    required this.fullName,
    required this.abbreviation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'].toString(),
      fullName: json['full_name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'abbreviation': abbreviation,
    };
  }
}
