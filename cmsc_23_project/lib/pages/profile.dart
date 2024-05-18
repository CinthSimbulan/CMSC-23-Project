import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routename = '/profile';

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;

  Map<String, String> details = {
    "Type": "Donor",
    "Name": "name",
    "Username": "username",
    "Password": "password",
    "Address": "address",
    "Contact": "0999",
  };

  @override
  Widget build(BuildContext context) {
    user = context.read<UserAuthProvider>().user;
    Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: user!.email!)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: StreamBuilder(
        stream: usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No user data found"),
            );
          } else {
            Map<String, dynamic> userData =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;
            details['Type'] = userData['type'] ?? 'No type';
            details['Name'] = userData['name'] ?? 'No name';
            details['Username'] = userData['username'] ?? 'No username';
            details['Address'] = userData['address'] ?? 'No address';
            details['Contact'] = userData['contactno'] ?? 'No contact';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    details["Name"]!,
                    style: const TextStyle(
                      fontSize: 36,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    String key = details.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              details[key]!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cmsc_23_project/providers/auth_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Profile extends StatefulWidget {
//   static const routename = '/profile';
//   const Profile({super.key});
//   @override
//   _Profile createState() => _Profile();
// }

// class _Profile extends State<Profile> {
//   User? user;

//   @override
//   Widget build(BuildContext context) {
//     user = context.read<UserAuthProvider>().user;
//     Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isEqualTo: user!.email!)
//         .snapshots();
//     print(usersStream);

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Details"),
//         ),
//         body: StreamBuilder(
//           stream: usersStream,
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             Map<String, dynamic> userName = {
//               'name': '',
//               'username': '',
//               'address': '',
//               'contactno': ''
//             };
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text("Error encountered! ${snapshot.error}"),
//               );
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (!snapshot.hasData) {
//               return const Center(
//                 child: Text("No User Found"),
//               );
//             } else {
//               userName = snapshot.data!.docs[0].data() as Map<String, dynamic>;
//             }

//             return Container(
//                 margin: const EdgeInsets.all(30),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const Text(
//                             'Name',
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           Text(userName['name'],
//                               style: const TextStyle(fontSize: 20))
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const Text(
//                             'Username',
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           Text(userName['username'],
//                               style: const TextStyle(fontSize: 20))
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const Text(
//                             "Address:",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           Text(userName['address'],
//                               style: const TextStyle(fontSize: 20))
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const Text(
//                             "Contact number:",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           Text(userName['contactno'],
//                               style: const TextStyle(fontSize: 20))
//                         ],
//                       ),
//                     ]));
//           },
//         ));
//   }
// }
