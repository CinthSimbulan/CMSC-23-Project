import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationHomepage extends StatefulWidget {
  const OrganizationHomepage(
      {super.key, this.orgId, this.donationId, this.donationData});

  static const routename = '/organization';
  final String? orgId;
  final String? donationId;
  final Map? donationData;

  @override
  _OrganizationHomepageState createState() => _OrganizationHomepageState();
}

class _OrganizationHomepageState extends State<OrganizationHomepage> {
  late String updatedropdownValue;
  late String linkdropdownValue;

  @override
  void initState() {
    super.initState();
    updatedropdownValue = widget.donationData?['status'] ?? '';
    linkdropdownValue = '';
  }

  @override
  Widget build(BuildContext context) {
    // Convert Timestamp to DateTime
    DateTime selectedDateTime =
        (widget.donationData?['details']['selectedDateTime'] as Timestamp)
            .toDate();

    // Format DateTime
    String formattedDateTime =
        DateFormat('MMMM d, y - hh:mm a').format(selectedDateTime);

    Future<void> updateDonationStatus(String newStatus) async {
      try {
        DocumentReference donationRef = FirebaseFirestore.instance
            .collection('organizations')
            .doc(widget.orgId)
            .collection('donations')
            .doc(widget.donationId);
        await donationRef.update({'status': newStatus});
        print('Donation status updated successfully!');
      } catch (error) {
        print('Error updating donation status: $error');
      }
    }

    Future<void> linkDonation(
        String driveId, Map<String, dynamic> donationData) async {
      try {
        DocumentReference donationRef = FirebaseFirestore.instance
            .collection('organizations')
            .doc(widget.orgId)
            .collection('drives')
            .doc(driveId);

        // Merge the new donation data with the existing donations
        await donationRef.set({
          'donations': FieldValue.arrayUnion([donationData])
        }, SetOptions(merge: true));
        print(donationData);
        print('Donation status linked successfully!');
      } catch (error) {
        print('Error updating donation status: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Organization Home page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Donation Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text('Status: ${widget.donationData?['status']}'),
              ),
              ListTile(
                title: Text(
                    'Category: ${widget.donationData?['details']['category']}'),
              ),
              ListTile(
                title: Text(
                    'Mode of Delivery: ${widget.donationData?['details']['modeOfDelivery']}'),
              ),
              ListTile(
                title: Text(
                    'Weight: ${widget.donationData?['details']['weight']}'),
              ),
              ListTile(
                title: Text(
                    'Contact Number: ${widget.donationData?['details']['contactNumber']}'),
              ),
              ListTile(
                title: Text('Selected Date and Time: $formattedDateTime'),
              ),
              ListTile(
                title: Text(
                    'Addresses: ${widget.donationData?['details']['addresses'].join(', ')}'),
              ),
              ListTile(
                title: Text('Donor ID: ${widget.donationData?['donorId']}'),
              ),
              DropdownButton<String>(
                value: updatedropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  setState(() {
                    updatedropdownValue = value!;
                  });
                },
                items: [
                  'Pending',
                  'Confirmed',
                  'Scheduled for pick-up',
                  'Cancelled',
                  'completed'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    updateDonationStatus(updatedropdownValue);
                    Navigator.pop(context);
                  },
                  child: const Text('Update Status'),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('organizations')
                    .doc(widget.orgId)
                    .collection('drives')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var driveDocs = snapshot.data!.docs;
                  var driveItems = driveDocs.map((drive) {
                    var driveData = drive.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: drive.id,
                      child: Text(driveData['name'] ?? 'No name'),
                    );
                  }).toList();
                  // Add an empty string as one of the choices
                  driveItems.insert(
                      0,
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('None'),
                      ));

                  return DropdownButton<String>(
                    value: linkdropdownValue,
                    hint: const Text('Select a drive'),
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        linkdropdownValue = value!;
                      });
                    },
                    items: driveItems,
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    linkDonation(linkdropdownValue,
                        widget.donationData as Map<String, dynamic>);
                    Navigator.pop(context);
                  },
                  child: const Text('Connect to a donation drive'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
