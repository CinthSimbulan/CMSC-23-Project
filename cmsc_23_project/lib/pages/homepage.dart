import 'package:cmsc_23_project/models/organization_model.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/donor.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/drive.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/editstatus.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/organizationHomePage.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/scanqr.dart';
import 'package:cmsc_23_project/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  Map<String, dynamic> details = {
    "Type": "Donor",
    "Name": "name",
    "Username": "username",
    "Password": "password",
    "Address/es": [],
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
          details['Address/es'] = userData['addresses'] ?? 'No address/es';
          details['Contact'] = userData['contactno'] ?? 'No contact';
          details['Type'] = userData['type'] ?? 'No type';
          //id of the current user
          final userId = snapshot.data!.docs[0].id;
          print(userData);
          print(details);
          return Scaffold(
            appBar: AppBar(
              title: Text(details['Type']!),
            ),
            body: ListView(
              children: [
                header,
                const Divider(),
                if (details['Type'] == 'Donor' || details['Type'] == 'Admin')
                  organizations(userId),
                //update organization widget such that it will fetch
                //organizations from firestore
                if (details['Type'] == 'Organization')
                  donations(userData['orgDetails']['reference']),
                //update donations widget such that it will fetch
                //donations from firestore
                // }
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
      );

  String _scanResult = ''; //for result of scan
  //method for scanning
  Future<String> scanQRCode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } catch (e) {
      scanResult = 'Failed to get platform version.';
    }

    // Navigate to the form page if the scan result matches expected data
    setState(() {
      _scanResult = scanResult;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditStatus(
            donationId: _scanResult,
          ),
        ),
      );
    });

    return '';
  }

  //homepage of organization
  //this should show a clickable 'donations' which will navigate to a new page that shows the list of donations of the current org
  // and a clickable 'drives' which will navigate to a new page that shows the list of drives of the current org
  Widget donations(orgId) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// donation drive button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrivePage(
                          orgId: orgId,
                        ),
                      ));
                },
                child: const Text('Donation drive'),
              ),
              SizedBox(
                width: 20,
              ),
              //button for scan qr
              ElevatedButton(
                  onPressed: scanQRCode, child: const Text("Scan a QR code")),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder(
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
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                    // final orgId = snapshot.data!.docs[index].id;
                    final donationId = snapshot.data!.docs[index].id;
                    return ListTile(
                      title: Text(donationId ?? 'No name'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrganizationHomepage(
                                  orgId: orgId,
                                  donationId: donationId,
                                  donationData: donationData)),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ],
      ));
}
