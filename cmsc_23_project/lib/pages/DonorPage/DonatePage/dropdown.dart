import 'package:flutter/material.dart';

class ModeOfDelivery extends StatefulWidget {
  final Function(String)? callback;
  final ValueChanged? onChanged;
  String value;
  ModeOfDelivery(this.callback,
      {super.key, this.onChanged, required this.value});

  @override
  State<ModeOfDelivery> createState() => _ModeOfDeliveryState();
}

class _ModeOfDeliveryState extends State<ModeOfDelivery> {
  static final List<String> _options = ["Pick-up", "Drop-off"];

  String currentValue = _options[0];
  String value = "";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        items: _options.map((choice) {
          return DropdownMenuItem(value: choice, child: Text(choice));
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.value = value!;
            widget.onChanged?.call(value!);
          });
          widget.callback!(widget.value);
        },
        value: widget.value);
  }
}
