import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/models/organization_model.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:cmsc_23_project/providers/organizations_provider.dart';
import 'package:cmsc_23_project/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routename = '/profile';
  final String? type;
  const Profile({super.key, this.type});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;

  Map<String, dynamic> details = {
    "Type": "Donor",
    "Name": "name",
    "Username": "username",
    "Password": "password",
    "Address/es": [],
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
            details['Address/es'] = userData['addresses'] ?? 'No address/es';
            details['Contact'] = userData['contactno'] ?? 'No contact';

            print(userData);
            print(details);
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      String key = details.keys.elementAt(index);
                      if (key == 'Address/es') {
                        // address only
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
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: details['Address/es'].length,
                                    itemBuilder:
                                        (addressContext, addressIndex) {
                                      // String addressKey = details.keys
                                      //     .elementAt(index)[addressIndex];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                              details['Address/es']
                                                  [addressIndex]!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          if (addressIndex <
                                              details['Address/es'].length - 1)
                                            const Divider()
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // other details
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
                      }
                    },
                  ),
                ),
                if (widget.type! == 'Organization')
                  organizationDetails(context, snapshot)
              ],
            );
          }
        },
      ),
    );
  }
}

Widget organizationDetails(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  final String userId = snapshot.data!.docs[0].id;
  return Padding(
    padding: const EdgeInsets.all(24),
    child: FutureBuilder<String?>(
      future: context.read<UsersListProvider>().fetchOrgId(userId),
      builder: (context, AsyncSnapshot<String?> orgSnapshot) {
        if (orgSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (orgSnapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${orgSnapshot.error}"),
          );
        } else if (!orgSnapshot.hasData || orgSnapshot.data == null) {
          return const Center(
            child: Text("No organization data found"),
          );
        } else {
          String orgId = orgSnapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('organizations')
                .doc(orgId)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> orgDocSnapshot) {
              if (orgDocSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (orgDocSnapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${orgDocSnapshot.error}"),
                );
              } else if (!orgDocSnapshot.hasData ||
                  !orgDocSnapshot.data!.exists) {
                return const Center(
                  child: Text("No organization data found"),
                );
              } else {
                Map<String, dynamic> orgData =
                    orgDocSnapshot.data!.data() as Map<String, dynamic>;
                // return Column(
                //   children: [
                //     Text('Organization Details'),
                //     Text('Name: ${orgData['name']}'),
                //     Text('About: ${orgData['about']}'),
                //     Text('Status: ${orgData['status']}'),
                //     // Add more fields as necessary
                //   ],
                // );
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Organization Details",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orgData.length,
                        itemBuilder: (context, index) {
                          String key = orgData.keys.elementAt(index);
                          if (key == 'imageUrl') {
                            return const SizedBox.shrink();
                          } else {
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
                                      orgData[key]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // if (widget.type! == 'Organization')
                    //   organizationDetails(context, snapshot)
                  ],
                );
              }
            },
          );
        }
      },
    ),
  );
}
