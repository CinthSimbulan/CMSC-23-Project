import 'package:flutter/material.dart';

class AddressInput extends StatefulWidget {
  final ValueChanged<List<String>> callback;

  AddressInput({required this.callback});

  @override
  _AddressInputState createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  final TextEditingController _addressController = TextEditingController();
  List<String> _addresses = [];

  void _addAddress() {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        _addresses.add(_addressController.text);
        _addressController.clear();
      });
      widget.callback(_addresses);
    }
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
    widget.callback(_addresses);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Enter Address'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addAddress,
            ),
          ],
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _addresses.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_addresses[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeAddress(index),
              ),
            );
          },
        ),
      ],
    );
  }
}
