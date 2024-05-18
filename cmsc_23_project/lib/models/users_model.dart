import 'dart:convert';

class myUser {
  String? id;
  String name;
  String username;
  String address;
  String contactno;

  myUser(
      {required this.id,
      required this.name,
      required this.username,
      required this.address,
      required this.contactno});

  // Factory constructor to instantiate object from json format
  factory myUser.fromJson(Map<String, dynamic> json) {
    return myUser(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        address: json['address'],
        contactno: json['contactno']);
  }

  static List<myUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<myUser>((dynamic d) => myUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(myUser item) {
    return {
      'id': item.id,
      'name': item.name,
      'username': item.username,
      'address': item.address,
      'contactno': item.contactno
    };
  }
}
