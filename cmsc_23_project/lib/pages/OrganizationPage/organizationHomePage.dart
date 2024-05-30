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
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.donationData?['status'] ??
        ''; // Initialize dropdownValue with current status
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
        // Reference to the document containing the donation data
        DocumentReference donationRef = FirebaseFirestore.instance
            .collection('organizations')
            .doc(widget.orgId)
            .collection('donations')
            .doc(widget.donationId);
        // Update the 'status' field with the new value
        await donationRef.update({'status': newStatus});
        print('Donation status updated successfully!');
      } catch (error) {
        print('Error updating donation status: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Organization Home page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              title:
                  Text('Weight: ${widget.donationData?['details']['weight']}'),
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
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: [
                'Pending',
                'Confirmed',
                'Scheduled for pick-up',
                'Complete',
                'Cancelled'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateDonationStatus(dropdownValue);
                Navigator.pop(context);
              },
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }
}
