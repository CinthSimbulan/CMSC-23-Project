import 'dart:convert';

class Drive {
  String name;
  String description;
  Map<String, dynamic>? donations;

  Drive({required this.name, required this.description, this.donations});

  // Factory constructor to instantiate object from json format
  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
        name: json['name'],
        description: json['description'],
        donations: json['donations']);
  }

  static List<Drive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Drive>((dynamic d) => Drive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Drive item) {
    return {
      'name': item.name,
      'description': item.description,
      'donations': item.donations
    };
  }
}
