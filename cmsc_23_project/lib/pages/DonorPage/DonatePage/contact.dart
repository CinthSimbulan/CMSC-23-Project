import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactNumberInput extends StatefulWidget {
  final ValueChanged<String> callback;

  ContactNumberInput({required this.callback});

  @override
  _ContactNumberInputState createState() => _ContactNumberInputState();
}

class _ContactNumberInputState extends State<ContactNumberInput> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Enter Contact Number',
              hintText: 'e.g. 1234567890',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a contact number';
              }
              if (value.length < 10 || value.length > 15) {
                return 'Please enter a valid contact number';
              }
              return null;
            },
            onChanged: (value) {
              if (_formKey.currentState?.validate() == true) {
                widget.callback(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
