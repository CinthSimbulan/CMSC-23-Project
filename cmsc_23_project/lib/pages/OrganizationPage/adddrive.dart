import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/models/drive_model.dart';
import 'package:flutter/material.dart';

class AddDrivePage extends StatefulWidget {
  const AddDrivePage({super.key, this.orgId});

  static const routename = '/adddrive';
  final String? orgId;

  @override
  State<AddDrivePage> createState() => _AddDrivePageState();
}

class _AddDrivePageState extends State<AddDrivePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _driveNameController = TextEditingController();
  final TextEditingController _driveDescriptionController =
      TextEditingController();
  final Map<String, dynamic> emptyMap = {};

  @override
  void dispose() {
    _driveNameController.dispose();
    _driveDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Snackbar to display that the form is valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully')),
      );

      // Create a Drive object from the input values
      final drive = Drive(
          name: _driveNameController.text,
          description: _driveDescriptionController.text,
          donations: emptyMap);

      // Add the Drive object to Firestore
      try {
        CollectionReference driveCollection = FirebaseFirestore.instance
            .collection('organizations')
            .doc(widget.orgId)
            .collection('drives');

        driveCollection.add(drive.toJson(drive)).then((docRef) {
          String autoId = docRef.id;
          docRef.update({'id': autoId});
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drive added successfully!')),
        );

        // Clear the input fields
        _driveNameController.clear();
        _driveDescriptionController.clear();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add drive: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Drive"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Big text',
                  style: TextStyle(
                    fontSize: 32, // Increase the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                const SizedBox(
                    height:
                        20), // Add some space between the text and text fields
                TextFormField(
                  controller: _driveNameController,
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
                const SizedBox(height: 20), // Add space between the text fields
                TextFormField(
                  controller: _driveDescriptionController,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50, // Increase the height of the button
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
