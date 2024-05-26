import 'package:cmsc_23_project/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static const routename = '/home';

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? user;
  Map<String, String> details = {
    "Type": "Donor",
    "Name": "name",
    "Username": "username",
    "Password": "password",
    "Address": "address",
    "Contact": "0999",
  };

  List<String> list_organizations = [];
  // for testing
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 5; i++) {
      list_organizations.add("org$i");
    }
  }

  @override
  Widget build(BuildContext context) {
    user = context.read<UserAuthProvider>().user;
    Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: user!.email!)
        .snapshots();

    return StreamBuilder(
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
          details['Type'] = userData['type'] ?? 'No type';

          return Scaffold(
            appBar: AppBar(
              title: Text(details['Type']!),
            ),
            body: ListView(
              children: [
                header,
                const Divider(),
                organizations,
              ],
            ),
          );
        }
      },
    );
  }

  Widget get header => Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                }),
            Expanded(
              child: Text(
                details["Name"]!,
                style: const TextStyle(
                  fontSize: 36,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<UserAuthProvider>().signOut();
                  },
                  child: const Text(
                    'logout',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget get organizations => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Organizations to Donate:"),
            (list_organizations.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'No Organization to Donate',
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list_organizations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(list_organizations[index]),
                        onTap: () {
                          print(list_organizations[index]);
                        },
                      );
                    },
                  ),
          ],
        ),
      );
}
