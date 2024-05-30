import 'dart:convert';

class myUser {
  // String? id;
  String name;
  String username;
  List<String> addresses;
  String contactno;
  String type;
  List<String>? listDonations;
  Map<String, dynamic>? orgDetails;
  //donation
  //organization

  myUser(
      {
      // this.id,
      required this.name,
      required this.username,
      required this.addresses,
      required this.contactno,
      required this.type,
      this.listDonations,
      this.orgDetails});

  // Factory constructor to instantiate object from json format
  factory myUser.fromJson(Map<String, dynamic> json) {
    return myUser(
        // id: json['id'],
        name: json['name'],
        username: json['username'],
        addresses:
            List<String>.from(json['addresses']), //convert to List<String>
        contactno: json['contactno'],
        type: json['type'],
        listDonations: List<String>.from(json['listDonations']),
        orgDetails: Map<String, dynamic>.from(json['orgDetails'] ?? {}));
  }

  static List<myUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<myUser>((dynamic d) => myUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(myUser user) {
    return {
      // 'id': user.id,
      'name': user.name,
      'username': user.username,
      'addresses': user.addresses,
      'contactno': user.contactno,
      'type': user.type,
      'listDonations': user.listDonations,
      'orgDetails': user.orgDetails,
    };
  }
}
