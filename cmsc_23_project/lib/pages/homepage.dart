import 'package:cmsc_23_project/models/organization_model.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/donor.dart';
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
  Organization? org;
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
    //fetch user from provider
    user = context.read<UserAuthProvider>().user;
    //fetch user from firestore
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
          //id of the current user
          final userId = snapshot.data!.docs[0].id;
          return Scaffold(
            appBar: AppBar(
              title: Text(details['Type']!),
            ),
            body: ListView(
              children: [
                header,
                const Divider(),
                if (details['Type'] == 'Donor') ...{
                  organizations(userId)
                  //update organization widget such that it will fetch
                  //organizations from firestore
                } else ...{
                  donations(userData['orgDetails']['reference'])
                  // donations
                  //update donations widget such that it will fetch
                  //donations from firestore
                },
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                type: details["Type"],
                              )));
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

  Widget organizations(userId) => Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('organizations')
              .snapshots(),
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
                child: Text("No organization data found"),
              );
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> orgData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  final orgId = snapshot.data!.docs[index].id;

                  return ListTile(
                    title: Text(orgData['name'] ?? 'No name'),
                    onTap: () {
                      print(orgData.toString());
                      print(orgData['name']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Donor(orgId: orgId, userId: userId)),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
        // child: Column(
        //   children: [
        //     const Text("Organizations to Donate:"),
        //     if (list_organizations.isEmpty)
        //       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: Center(
        //           child: Text(
        //             'No Organization to Donate',
        //           ),
        //         ),
        //       )
        //     else
        //       ListView.builder(
        //         physics: const NeverScrollableScrollPhysics(),
        //         shrinkWrap: true,
        //         itemCount: list_organizations.length,
        //         itemBuilder: (context, index) {
        //           return ListTile(
        //             title: Text(list_organizations[index]),
        //             onTap: () {
        //               print(list_organizations[index]);
        //             },
        //           );
        //         },
        //       ),
        //   ],
        // ),
      );

  //homepage of organization
  //this should show a clickable 'donations' which will navigate to a new page that shows the list of donations of the current org
  // and a clickable 'drives' which will navigate to a new page that shows the list of drives of the current org
  Widget donations(orgId) => Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgId)
            .collection('donations')
            .snapshots(),
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
            return Center(
              child: Text(orgId),
            );
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> donationData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(donationData['donorId'] ?? 'No name'),
                  onTap: () {
                    print(donationData.toString());
                    print(donationData['name']);
                  },
                );
              },
            );
          }
        },
      ));
}
