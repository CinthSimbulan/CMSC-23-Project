import 'dart:io';

import 'package:cmsc_23_project/models/donation_model.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/address.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/contact.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/date&dtime.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/dropdown.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/generate.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/image.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/itemcategory.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/numberinputfield.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/qrcode.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/textfield.dart';
import 'package:cmsc_23_project/providers/image_provider.dart';
import 'package:cmsc_23_project/providers/organizations_provider.dart';
import 'package:cmsc_23_project/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Donor extends StatefulWidget {
  static const routename = '/donor';
  final String? orgId;
  final String? userId;

  const Donor({super.key, this.orgId, this.userId});

  @override
  State<Donor> createState() => _DonorState();
}

// class Donation {
//   String category;
//   String modeOfDelivery;
//   int weight;
//   File? photo;
//   DateTime? selectedDateTime;
//   List<String> addresses;
//   String contactNumber;

//   Donation(
//       {required this.category,
//       required this.modeOfDelivery,
//       required this.weight,
//       this.photo,
//       this.selectedDateTime,
//       required this.addresses,
//       required this.contactNumber});
// }

class _DonorState extends State<Donor> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String modeOfDelivery = "Pick-up";
  int weight = 0;
  String weightUnit = "kg"; // Added weight unit state
  File? photo;
  DateTime? selectedDateTime;
  List<String> addresses = [];
  String contactNumber = "";

  bool validate = false; //to show the summary of the donation

  //controller for textfieldwidget for the others
  final TextEditingController categoryController = TextEditingController();

  // List to maintain item categories
  //THIS SHOULD BE IN THE DATABASE  (for now, it's hardcoded)
  List<Map<String, dynamic>> itemCategories = [
    {'category': 'Food', 'value': false},
    {'category': 'Clothes', 'value': false},
    {'category': 'Cash', 'value': false},
    {'category': 'Necessities', 'value': false},
  ];

  // Method to add a new category
  void addItemCategory(String category) {
    setState(() {
      itemCategories.add({'category': category, 'value': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Donor')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            //Name of The Page
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("DONATE",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        )),
                                  ],
                                )),

                            //Category of the Item
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Item Category: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17)),
                                  ],
                                )),
                            //dyanmic list of categories. pag nag add ng category sa textfield, mag aadd ng checkbox
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  //display existing categories
                                  ...itemCategories.map((item) {
                                    return ItemCategory(
                                      category: item['category'],
                                      value: item['value'],
                                      callback: (value) =>
                                          item['value'] = value,
                                    );
                                  }),

                                  //TextField to add new category
                                  TextFieldWidget(
                                      controller: categoryController,
                                      callback: addItemCategory,
                                      hintText: "Others")
                                ],
                              ),
                            ),

                            //Mode of Delivery: pickup or dropoff
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Mode of Delivery: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17)),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ModeOfDelivery(
                                        value: modeOfDelivery,
                                        (value) => setState(
                                            () => modeOfDelivery = value)),
                                  ],
                                )),

                            //Weight of items
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Weight of Items to Donate: ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: NumberInputField(
                                              title: weight,
                                              callback: (value) =>
                                                  weight = value),
                                        ),
                                        const SizedBox(width: 10),
                                        DropdownButton<String>(
                                          value: weightUnit,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              weightUnit = newValue!;
                                            });
                                          },
                                          items: <String>['kg', 'lbs']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),

                            //display address and contact number if mode of delivery is pick up
                            if (modeOfDelivery == "Pick-up") ...[
                              //address (can save multiple address, for pickup))
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 55),
                                  child: Column(
                                    children: [
                                      const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Address: ",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17)),
                                          ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AddressInput(
                                          addresses: addresses,
                                          callback: (value) =>
                                              addresses = value),
                                    ],
                                  )),

                              //contact no (for pickup)
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 55),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Contact Number: ",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ContactNumberInput(
                                          contactNumber: contactNumber,
                                          callback: (value) =>
                                              contactNumber = value),
                                    ],
                                  )),
                            ],

                            //Photo of item
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
                                      callback: (value) =>
                                          setState(() => photo = value),
                                    ),
                                  ],
                                )),

                            //date and time for delivery
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Date and Time of Delivery: ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DateTimePicker(
                                        selectedDateTime: selectedDateTime,
                                        callback: (value) =>
                                            selectedDateTime = value),
                                  ],
                                )),

                            // if (modeOfDelivery == "Drop-off") ...[
                            //   //button that will generate a qr code
                            //   OutlinedButton(
                            //       onPressed: () {
                            //         //call generate qr code function
                            //         // QrCodeWidget(
                            //         //   data: "hiiiiiiiiiiii",
                            //         // );
                            //         //navigate to the qr code screen
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   QrCodeWidget(data: "EditStatus")),
                            //         );
                            //       },
                            //       child: const Text("Generate QR Code",
                            //           style: TextStyle(
                            //               fontStyle: FontStyle.italic,
                            //               fontWeight: FontWeight.w400,
                            //               fontSize: 17))),
                            //   SizedBox(height: 50),
                            // ],

                            //Submit button/donate button
                            OutlinedButton(
                                onPressed: () async {
                                  //check if all fields are filled up except the photo
                                  if (formKey.currentState!.validate()) {
                                    //check if at least one category is selected
                                    if (itemCategories
                                        .any((element) => element['value'])) {
                                      //check if the date and time is not empty
                                      if (selectedDateTime != null) {
                                        //add the photo of the donation to storage
                                        String photoUrl = await context
                                            .read<ImageUploadProvider>()
                                            .uploadImage(photo!, "donations");

                                        // donation details
                                        Map<String, dynamic> donation = {
                                          'category': itemCategories
                                              .where(
                                                  (element) => element['value'])
                                              .map((e) => e['category'])
                                              .join(', '),
                                          'modeOfDelivery': modeOfDelivery,
                                          'weight': weight.toString(),
                                          'photo': photoUrl,
                                          'selectedDateTime': selectedDateTime,
                                          'addresses': addresses,
                                          'contactNumber': contactNumber
                                        };
                                        //create a donation object. This will be stored sa
                                        //subcollection donation ng organization using the id ng org IF ORG ung user type
                                        // ID lang pala yung isostore sa donation array ng user
                                        Donations tempDonation = Donations(
                                            status: "Pending",
                                            details: donation,
                                            donorId:
                                                widget.userId! //id ng donor
                                            );

                                        // Add the donation to the subcollection 'donations' of an organization
                                        String donationId = await context
                                            .read<OrganizationProvider>()
                                            .addDonation(
                                                widget.orgId!, tempDonation);

                                        // Add the id of the donation to the user array of donations
                                        context
                                            .read<UsersListProvider>()
                                            .addDonationToUser(
                                                widget.userId!, donationId);

                                        //addd the photo url to the donation details
                                        context
                                            .read<OrganizationProvider>()
                                            .addImageToDonation(
                                                widget.orgId!, donationId);

                                        print(
                                            "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                        print(modeOfDelivery);
                                        // If modeOfDelivery == drop-off after donating, the app wil redirect to a page where the user can generate a QR code
                                        // if (modeOfDelivery == "Drop-off") {
                                        //   print('trueeeeee');
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               GenerateQrButtonWidget(
                                        //                 donationId: donationId,
                                        //               )));
                                        // } else {
                                        //   print("Yawaaaaaaaaaaaaaa");
                                        // }
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                },
                                child: const Text("Donate",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20))),

                            SizedBox(height: 50),

                            //cancel donation button. Pwede to gawing 'clear' button. for now ito mnuna ginagawa ni cancel pero dapat
                            //magreredirect na to sa previous page which is ung list ng organization sa donor's page
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    formKey.currentState!.reset();
                                    modeOfDelivery = "Pick-up";
                                    weight = 0;
                                    photo = null;
                                    selectedDateTime = null;
                                    addresses = [];
                                    contactNumber = "";
                                    weightUnit = "kg";

                                    //reset values of the categories
                                    for (var item in itemCategories) {
                                      item['value'] = false;
                                    }
                                    categoryController
                                        .clear(); //clear text fieldR
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15))),
                          ],
                        ))))
          ],
        )));
  }
}
