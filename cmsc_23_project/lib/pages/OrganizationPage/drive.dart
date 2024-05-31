import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/adddrive.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/drivedetails.dart';
import 'package:flutter/material.dart';

class DrivePage extends StatefulWidget {
  const DrivePage({super.key, this.orgId});

  static const routename = '/drive';
  final String? orgId;

  @override
  State<DrivePage> createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  late Stream<QuerySnapshot> driveStream;

  @override
  void initState() {
    super.initState();
    driveStream = FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.orgId)
        .collection('drives')
        .snapshots();
  }

  void _deleteDrive(String driveId) async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.orgId)
        .collection('drives')
        .doc(driveId)
        .delete();
  }

  void _editDrive(
      String driveId, String currentName, String currentDescription) async {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    final editFormKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Drive'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Drive Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the drive name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Drive Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3, // Allow multiple lines for description
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the drive description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editFormKey.currentState!.validate()) {
                await FirebaseFirestore.instance
                    .collection('organizations')
                    .doc(widget.orgId)
                    .collection('drives')
                    .doc(driveId)
                    .update({
                  'name': nameController.text,
                  'description': descriptionController.text,
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation Drive Homepage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDrivePage(
                        orgId: widget.orgId,
                      ),
                    ),
                  );
                },
                child: const Text('Add Donation Drive'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: driveStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No donation drives found.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var driveDoc = snapshot.data!.docs[index];
                        var drive = driveDoc.data() as Map<String, dynamic>;
                        String driveId = driveDoc.id;
                        String driveName = drive['name'] ?? 'No name';
                        String driveDescription =
                            drive['description'] ?? 'No description';
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(driveName),
                            subtitle: Text(driveDescription),
                            leading: IconButton(
                              icon: const Icon(Icons.list_sharp),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Drivedetails(
                                            drive: drive,
                                          )),
                                );
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editDrive(
                                        driveId, driveName, driveDescription);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteDrive(driveId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
