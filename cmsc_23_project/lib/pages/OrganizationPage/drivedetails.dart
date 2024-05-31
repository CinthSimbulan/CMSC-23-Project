import 'package:cmsc_23_project/pages/OrganizationPage/addImageDrive.dart';
import 'package:flutter/material.dart';

class Drivedetails extends StatefulWidget {
  const Drivedetails({super.key, this.drive});

  static const routename = '/drivedetails';
  final Map? drive;

  @override
  State<Drivedetails> createState() => _DrivedetailsState();
}

class _DrivedetailsState extends State<Drivedetails> {
  @override
  Widget build(BuildContext context) {
    // Extract the donations array from the drive map
    List donations = widget.drive?['donations'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Donations in Donation Drive')),
      body: SingleChildScrollView(
        child: Column(
          children: donations.map<Widget>((donation) {
            return ListTile(
              title: Text(
                donation['details']['category'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Addimagedrive(donation: donation['details'])),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
