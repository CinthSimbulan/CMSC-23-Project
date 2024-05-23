import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/pages/DonorPage/image.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
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
  String? address;
  String? contact;
  String? password;
  bool isOrganization = false;
  String? organizationName;
  File? photo;
  final Map<String, dynamic> details = {
    "Type": "Donor",
    "Name": "",
    "Username": "",
    "Address": "",
    "Contact": ""
  };

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
                  organizationCheckbox,
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

  Widget get addressField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Address"),
              hintText: "Enter your address"),
          onSaved: (value) => setState(() {
            address = value;
            details['Address'] = address;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
      );

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

  Widget get organizationCheckbox => CheckboxListTile(
        title: const Text('Are you an organization?'),
        value: isOrganization,
        onChanged: (bool? value) {
          setState(() {
            isOrganization = value!;
          });
        },
      );

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
            details['Type'] = "Organization";
          }),
          validator: (value) {
            if (isOrganization && (value == null || value.isEmpty)) {
              return "This field is required for organizations";
            }
            return null;
          },
        ),
      );

  Widget get proofImage => Padding(
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: Column(
        children: [
          const Text("Photo of Item: ",
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
          print(details);

          String? message = await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!);
          // check if the widget hasn't been disposed of after an asynchronous action
          if (message == "Success") {
            CollectionReference usersCollection =
                FirebaseFirestore.instance.collection('users');
            usersCollection.add({
              'type': details['Type'],
              'name': details['Name'],
              'username': details['Username'],
              'address': details['Address'],
              'contactno': details['Contact'],
              if (isOrganization) 'organization_name': details['Organization'],
            }).then((docRef) {
              String autoId = docRef.id;
              docRef.update({'id': autoId});
            });
            if (mounted) {
              // It's safe to update the state or call setState()
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Sign up successful. Logging you in')),
              );
              Navigator.pop(context);
            }
          } else {
            setState(() {
              error = message;
              showErrorMessage = true;
            });
          }
        }
      },
      child: const Text("Sign Up"));

  Widget get errorMessage => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
}
