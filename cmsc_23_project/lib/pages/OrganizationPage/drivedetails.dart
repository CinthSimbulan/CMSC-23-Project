import 'package:flutter/material.dart';
import 'addImageDrive.dart';

class Drivedetails extends StatefulWidget {
  const Drivedetails({super.key, this.drive, this.driveId, this.orgId});

  static const routename = '/drivedetails';
  final Map<String, dynamic>? drive;
  final String? driveId;
  final String? orgId;

  @override
  State<Drivedetails> createState() => _DrivedetailsState();
}

class _DrivedetailsState extends State<Drivedetails> {
  @override
  Widget build(BuildContext context) {
    // Extract the donations array from the drive map
    var donations = widget.drive?['donations'];

    return Scaffold(
      appBar: AppBar(title: const Text('Donations in Donation Drive')),
      body: SingleChildScrollView(
        child: donations.isEmpty
            ? const Center(
                child: Text('No donations available'),
              )
            : Column(
                children: (donations as List<dynamic>).map<Widget>((donation) {
                  return ListTile(
                    title: Text(
                      donation['details']['category'],
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
