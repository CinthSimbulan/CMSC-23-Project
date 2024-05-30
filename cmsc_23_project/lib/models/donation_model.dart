import 'dart:convert';

class Donations {
  String status;
  Map<String, dynamic> details;
  String donorId;
  Donations(
      {required this.status, required this.details, required this.donorId});

  // Factory constructor to instantiate object from json format
  factory Donations.fromJson(Map<String, dynamic> json) {
    return Donations(
      status: json['status'],
      details: json['details'],
      donorId: json['donorId'],
    );
  }

  // Method to convert Donations instance to json format
  Map<String, dynamic> toJson(Donations donation) {
    return {
      'status': status,
      'details': details,
      'donorId': donorId,
    };
  }

  // Static method to create a list of Donations from a JSON array
  static List<Donations> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donations>((dynamic d) => Donations.fromJson(d)).toList();
  }
}
