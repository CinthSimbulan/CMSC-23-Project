//HINDI NA NEED

import 'package:cmsc_23_project/pages/profile.dart';
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
  List<String> list_donations = [];
  String name = "Name";

  // for testing
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 5; i++) {
      list_donations.add("Donation #$i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organization's Homepage"),
      ),
      body: ListView(
        children: [
          Padding(
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
                              builder: (context) => const Profile()));
                    }),
                Expanded(
                  child: Text(
                    name,
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
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("List of Donations:"),
          ),
          (list_donations.isEmpty)
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'No donations yet',
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list_donations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list_donations[index]),
                      onTap: () {
                        print(list_donations[index]);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
