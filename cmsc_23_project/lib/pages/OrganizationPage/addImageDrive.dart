import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/image.dart';
import 'package:cmsc_23_project/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Class for org to add image to prove donation to the donor
//This image will be sent to donor as proof that their donation was given to a beneficiary
class Addimagedrive extends StatefulWidget {
  const Addimagedrive({super.key, this.donation, this.orgId});

  static const routename = '/addimagedrive';
  final Map? donation;
  final String? orgId;

  @override
  State<Addimagedrive> createState() => _AddimagedriveState();
}

class _AddimagedriveState extends State<Addimagedrive> {
  File? photo;

  Future<void> updateDonationStatus(String newStatus) async {
    try {
      DocumentReference donationRef = FirebaseFirestore.instance
          .collection('organizations')
          .doc(widget.orgId)
          .collection('donations')
          .doc(widget.donation!['id']);
      await donationRef.update({'status': newStatus});
      print('Donation status updated successfully!');
    } catch (error) {
      print('Error updating donation status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add image to prove donation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 55),
                child: Column(
                  children: [
                    const Text("Photo of Item: ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            fontSize: 17)),
                    const SizedBox(
                      height: 10,
                    ),
                    PhotoPicker(
                      callback: (value) => setState(() => photo = value),
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    //button to send proof to donor
                    ElevatedButton(
                      onPressed: () async {
                        //save image to firebase storage
                        String photoUrl = await context
                            .read<ImageUploadProvider>()
                            .uploadImage(photo!, "drives");

                        //send image to donor
                        // send 'photoUrl' to donor via sms or email
                        print('donation id');
                        print(widget.donation!['id']);
                        print('org id');

                        print(widget.orgId);
                        //change the status to 'completed';
                        updateDonationStatus('completed');

                        Navigator.pop(context);
                      },
                      child: const Text('Send Proof to Donor'),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
