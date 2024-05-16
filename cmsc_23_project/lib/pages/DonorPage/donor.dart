import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/pages/DonorPage/address.dart';
import 'package:my_app/pages/DonorPage/contact.dart';
import 'package:my_app/pages/DonorPage/date&dtime.dart';
import 'package:my_app/pages/DonorPage/dropdown.dart';
import 'package:my_app/pages/DonorPage/image.dart';
import 'package:my_app/pages/DonorPage/itemcategory.dart';
import 'package:my_app/pages/DonorPage/numberinputfield.dart';
import 'package:my_app/pages/DonorPage/textfield.dart';

class Donor extends StatefulWidget {
  const Donor({super.key});

  @override
  State<Donor> createState() => _DonorState();
}

class _DonorState extends State<Donor> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String modeOfDelivery = "";
  bool food = false;
  bool clothes = false;
  bool cash = false;
  bool necessities = false;
  String other = "";
  int weight = 0;
  File? photo;
  DateTime? selectedDateTime;
  List<String> addresses = [];
  String contactNumber = "";

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
                            //Category of the Item
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("Item Category: ",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  ItemCategory(
                                      category: "Food",
                                      callback: (value) => food = value),
                                  ItemCategory(
                                      category: "Clothes",
                                      callback: (value) => clothes = value),
                                  ItemCategory(
                                      category: "Cash",
                                      callback: (value) => cash = value),
                                  ItemCategory(
                                      category: "Necessities",
                                      callback: (value) => necessities = value),
                                  TextFieldWidget(
                                      title: "Other",
                                      callback: (value) => other = value),
                                ],
                              ),
                            ),

                            //Mode of Delivery: pickup or dropoff
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Mode of Delivery: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ModeOfDelivery(
                                        (value) => modeOfDelivery = value),
                                  ],
                                )),

                            //Weight of items
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Weight of Items to Donate: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    NumberInputField(
                                        callback: (value) => weight = value),
                                  ],
                                )),

                            //Photo of item
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Photo of Item: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
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
                                    const Text("Date and Time of Delivery: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DateTimePicker(
                                        callback: (value) =>
                                            selectedDateTime = value),
                                  ],
                                )),

                            //address (can save multiple address, for pickup))
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Address: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AddressInput(
                                        callback: (value) => addresses = value),
                                  ],
                                )),

                            //contact no (for pickup)
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 55),
                                child: Column(
                                  children: [
                                    const Text("Contact Number: ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ContactNumberInput(
                                        callback: (value) =>
                                            contactNumber = value),
                                  ],
                                )),

                            //button that will generate a qr code
                            OutlinedButton(
                                onPressed: () {},
                                child: const Text("Generate QR Code",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15))),

                            SizedBox(height: 50),
                            //cancel donation button
                            OutlinedButton(
                                onPressed: () {},
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15)))
                          ],
                        ))))
          ],
        )));
  }
}
