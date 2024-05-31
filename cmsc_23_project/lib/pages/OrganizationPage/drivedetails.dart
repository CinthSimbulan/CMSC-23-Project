import 'package:cmsc_23_project/pages/OrganizationPage/addImageDrive.dart';
import 'package:flutter/material.dart';

class Drivedetails extends StatefulWidget {
  const Drivedetails({super.key, this.drive, this.driveId, this.orgId});

  static const routename = '/drivedetails';
  final String? orgId;
  final Map? drive;
  final String? driveId;

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
                donation['details']['id'],
                // widget.driveId!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Addimagedrive(
                            donation: donation['details'],
                            orgId: widget.orgId,
                          )),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
