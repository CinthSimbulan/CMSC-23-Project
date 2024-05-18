import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  static const routename = '/sign-up';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? address;
  String? contact;
  String? password;
  final Map<String, dynamic> details = {
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
                  // emailField,
                  passwordField,
                  submitButton
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

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print(details);
          CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('users');
          usersCollection.add({
            'name': details['Name'],
            'username': details['Username'],
            'address': details['Address'],
            'contactno': details['Contact'],
          }).then((docRef) {
            String autoId = docRef.id;
            docRef.update({'id': autoId});
          });
          await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!);
          // check if the widget hasn't been disposed of after an asynchronous action
          if (mounted) Navigator.pop(context);
        }
      },
      child: const Text("Sign Up"));
}
