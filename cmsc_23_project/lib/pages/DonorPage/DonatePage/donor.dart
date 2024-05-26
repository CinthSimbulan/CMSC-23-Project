import 'dart:io';

import 'package:cmsc_23_project/pages/DonorPage/DonatePage/address.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/contact.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/date&dtime.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/dropdown.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/image.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/itemcategory.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/numberinputfield.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Donor extends StatefulWidget {
  static const routename = '/donor';

  const Donor({super.key});

  @override
  State<Donor> createState() => _DonorState();
}

class Donation {
  String category;
  String modeOfDelivery;
  int weight;
  File? photo;
  DateTime? selectedDateTime;
  List<String> addresses;
  String contactNumber;

  Donation(
      {required this.category,
      required this.modeOfDelivery,
      required this.weight,
      this.photo,
      this.selectedDateTime,
      required this.addresses,
      required this.contactNumber});
}

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

                            if (modeOfDelivery == "Drop-off") ...[
                              //button that will generate a qr code
                              OutlinedButton(
                                  onPressed: () {},
                                  child: const Text("Generate QR Code",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17))),
                              SizedBox(height: 50),
                            ],

                            //Submit button/donate button
                            OutlinedButton(
                                onPressed: () {
                                  //check if all fields are filled up except the photo
                                  if (formKey.currentState!.validate()) {
                                    //check if at least one category is selected
                                    if (itemCategories
                                        .any((element) => element['value'])) {
                                      //check if the date and time is not empty
                                      if (selectedDateTime != null) {
                                        //create a donation object
                                        Donation donation = Donation(
                                            category: itemCategories
                                                .where((element) =>
                                                    element['value'])
                                                .map((e) => e['category'])
                                                .join(', '),
                                            modeOfDelivery: modeOfDelivery,
                                            weight: weight,
                                            photo: photo,
                                            selectedDateTime: selectedDateTime,
                                            addresses: addresses,
                                            contactNumber: contactNumber);

                                        print(donation.addresses);
                                        setState(() {
                                          validate = true;
                                        });

                                        //send the donation object to the database
                                        //for now, just print the donation object
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
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15))),

                            //show the summary of the donation
                            //para lang mapakita kung nagana. aalisin din to if iaapply na yung sa database na crud
                            if (validate == true) ...[
                              //summary of the donation
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Summary of Donation",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //display the summary of the donation
                                    Column(
                                      children: [
                                        Text(
                                            "Category: ${itemCategories.where((element) => element['value']).map((e) => e['category']).join(', ')}"),
                                        Text(
                                            "Mode of Delivery: $modeOfDelivery"),
                                        Text("Weight: $weight $weightUnit"),
                                        if (modeOfDelivery == "Pick-up") ...[
                                          Text(
                                              "Address: ${addresses.join(', ')}"),
                                          Text(
                                              "Contact Number: $contactNumber"),
                                        ],
                                        if (photo != null) ...[
                                          Image.file(photo!),
                                        ],
                                        if (selectedDateTime != null) ...[
                                          Text(
                                              "Date and Time of Delivery: $selectedDateTime"),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ))))
          ],
        )));
  }
}
