import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  static const routename = '/home';

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> list_organizations = [];
  String name = "Name";
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
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
                      print("profile");
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
                        print("logout");
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
            child: Text("Organizations to Donate:"),
          ),
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
}
