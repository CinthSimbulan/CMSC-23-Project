import 'package:flutter/material.dart';

class AddressInput extends StatefulWidget {
  final ValueChanged<List<String>> callback;
  List<String>? addresses;

  AddressInput({required this.callback, this.addresses});

  @override
  _AddressInputState createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  final TextEditingController _addressController = TextEditingController();

  void _addAddress() {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        widget.addresses!.add(_addressController.text);
        _addressController.clear();
      });
      widget.callback(widget.addresses!);
    }
  }

  void _removeAddress(int index) {
    setState(() {
      widget.addresses!.removeAt(index);
    });
    widget.callback(widget.addresses!);
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
          itemCount: widget.addresses!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.addresses![index]),
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
