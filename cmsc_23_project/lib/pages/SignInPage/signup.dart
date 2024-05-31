import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/models/donation_model.dart';
import 'package:cmsc_23_project/models/organization_model.dart';
import 'package:cmsc_23_project/models/users_model.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/image.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:cmsc_23_project/providers/image_provider.dart';
import 'package:cmsc_23_project/providers/organizations_provider.dart';
import 'package:cmsc_23_project/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  static const routename = '/sign-up';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String? error;
  bool showErrorMessage = false;

  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  List<String> addresses = [];
  String? contact;
  String? password;
  bool isAdmin = false;
  bool isOrganization = false;
  String? organizationName;
  File? photo;
  final TextEditingController _addressController = TextEditingController();

  final Map<String, dynamic> details = {
    "Type": "Donor",
    "Name": "",
    "Username": "",
    "Contact": ""
  };

  // method to add multiple address
  void _addAddress() {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        addresses.add(_addressController.text);
        _addressController.clear();
      });
    }
  }

  //method to delete an address
  void _removeAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heading,
                  nameField,
                  usernameField,
                  addressField,
                  contactField,
                  passwordField,
                  adminSwitch,
                  if (!isAdmin) organizationCheckbox,
                  if (isOrganization) organizationNameField,
                  if (isOrganization) proofImage,
                  submitButton,
                  showErrorMessage ? errorMessage : Container(),
                ],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  // Name of User
  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Name"),
              hintText: "Enter your name"),
          onSaved: (value) => setState(() {
            name = value;
            details['Name'] = name;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
      );

  // Email of User
  Widget get usernameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Username"),
              hintText: "Enter a valid email"),
          onSaved: (value) => setState(() {
            email = value;
            details['Username'] = email;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid email format";
            } else if (!EmailValidator.validate(value)) {
              return "Please enter a valid email format";
            }
            return null;
          },
        ),
      );

  // Address/es of User
  Widget get addressField => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter Address')),
                  onSaved: (value) => setState(() {
                    _addAddress();
                  }),
                  validator: (value) {
                    if (addresses.isEmpty) {
                      return "Please add an address";
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addAddress,
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(addresses[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeAddress(index),
                ),
              );
            },
          ),
        ],
      ));

  //Contact Number of User
  Widget get contactField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Contact no."),
              hintText: "Enter your Contact Number"),
          keyboardType: TextInputType.number,
          onSaved: (value) => setState(() {
            contact = value;
            details['Contact'] = contact;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            } else if (value.length != 11) {
              return "Invalid contact number";
            } else if (!RegExp(r'^09').hasMatch(value)) {
              return "Invalid contact number. Should start with '09'";
            }
            return null;
          },
        ),
      );

  // Password of User
  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "At least 6 characters"),
          obscureText: true,
          onSaved: (value) => setState(() {
            password = value;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            } else if (value.length < 6) {
              return "Password should be at least 6 characters.";
            }

            return null;
          },
        ),
      );

  // Switch button for Admin
  Widget get adminSwitch => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          const Text('Are you an admin?'),
          Switch(
            value: isAdmin,
            onChanged: (bool value) {
              setState(() {
                isAdmin = value;
                isOrganization = false;
                value ? details['Type'] = "Admin" : details['Type'] = "Donor";
              });
            },
          )
        ],
      ));

  // Checkbox for Organization if User is an Organization
  Widget get organizationCheckbox => CheckboxListTile(
        title: const Text('Are you an organization?'),
        value: isOrganization,
        onChanged: (bool? value) {
          setState(() {
            isOrganization = value!;
            value
                ? details['Type'] = "Organization"
                : details['Type'] = "Donor";
          });
        },
      );

  // Organization Name of User
  Widget get organizationNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Organization Name"),
            hintText: "Enter organization name",
          ),
          enabled: isOrganization,
          onSaved: (value) => setState(() {
            organizationName = value;
            details['Organization'] = organizationName;
          }),
          validator: (value) {
            if (isOrganization && (value == null || value.isEmpty)) {
              return "This field is required for organizations";
            }
            return null;
          },
        ),
      );

  // Photo for proof of legitimacy of Organization
  Widget get proofImage => Padding(
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: Column(
        children: [
          const Text("Proof of Legitimacy: ",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15)),
          const SizedBox(
            height: 10,
          ),
          PhotoPicker(
            callback: (value) => setState(() => photo = value),
          ),
        ],
      ));

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            String? message = await context
                .read<UserAuthProvider>()
                .authService
                .signUp(email!, password!);

            if (message == "Success") {
              if (isOrganization) {
                String photoURL = await context
                    .read<ImageUploadProvider>()
                    .uploadImage(photo!, 'org_proof_of_legitimacy');

                Organization tempOrg = Organization(
                    name: organizationName!,
                    about: "about",
                    status: "Open",
                    isApproved: "Open",
                    imageUrl: photoURL);

                //Add org to the 'organizations' collection
                String orgId =
                    await context.read<OrganizationProvider>().addOrg(tempOrg);

                //Add user to the 'users' collection with the org id
                myUser tempUser = myUser(
                  name: details['Name'],
                  username: details['Username'],
                  addresses: addresses,
                  contactno: details['Contact'],
                  type: details['Type'],
                  orgDetails: {
                    'name': organizationName,
                    'reference': orgId,
                    'isApproved': "Open"
                  },
                );

                if (mounted) {
                  context.read<UsersListProvider>().addUser(tempUser);
                }
              } else {
                //user is a donor
                //create an instance of user based on the input of the user
                myUser tempUser = myUser(
                  name: details['Name'],
                  username: details['Username'],
                  addresses: addresses,
                  contactno: details['Contact'],
                  type: details['Type'],
                );
                if (mounted) {
                  context.read<UsersListProvider>().addUser(
                      tempUser); //add user using the method in provider
                }
              }

              // if user is an organization, add organization sa org collections

              // !! Eto yung old method na pag add ng user sa firestore, ginawamit ko lang si provider and api para modularized
              // Uncomment and adjust the following block if using Firestore
              // CollectionReference usersCollection =
              //     FirebaseFirestore.instance.collection('users');
              // usersCollection.add({
              //   'type': details['Type'],
              //   'name': details['Name'],
              //   'username': details['Username'],
              //   'address': details['Address'],
              //   'contactno': details['Contact'],
              //   if (isOrganization)
              //     'organization_name': details['Organization'],
              // }).then((docRef) {
              //   String autoId = docRef.id;
              //   docRef.update({'id': autoId});
              // });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sign up successful. Logging you in')),
                );
                Navigator.pop(context);
              }
            } else {
              print('error');
              setState(() {
                error = message;
                showErrorMessage = true;
              });
            }
          }
        },
        child: const Text("Sign Up"),
      );
  // Error Message
  Widget get errorMessage => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
}
