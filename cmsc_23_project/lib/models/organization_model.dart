import 'dart:convert';

class Organization {
  // String? id;
  String name;
  String about;
  String status;
  String isApproved;
  String imageUrl;

  // String? imageUrl; o kaya File! imageFile; for proof of legitimacy
  // collection for donation
  //collection for drives

  //donation
  //organization

  Organization({
    // this.id,
    required this.name,
    required this.about,
    required this.status,
    required this.isApproved,
    required this.imageUrl,
  });

  // Factory constructor to instantiate object from json format
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      // id: json['id'],
      name: json['name'],
      about: json['about'],
      status: json['status'],
      isApproved: json['isApproved'],
      imageUrl: json['imageUrl'],
      // donations: Map<String, dynamic>.from(json['donations'] ?? {})
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Organization>((dynamic d) => Organization.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(Organization org) {
    return {
      // 'id': user.id,
      'name': org.name,
      'about': org.about,
      'status': org.status,
      'isApproved': org.isApproved,
      'imageUrl': org.imageUrl,
      // 'donations': org.donations,
    };
  }
}
