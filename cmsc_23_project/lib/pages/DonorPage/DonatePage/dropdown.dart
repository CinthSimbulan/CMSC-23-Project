import 'package:flutter/material.dart';

class ModeOfDelivery extends StatefulWidget {
  final Function(String)? callback;
  final ValueChanged? onChanged;
  const ModeOfDelivery(this.callback, {super.key, this.onChanged});

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
            currentValue = value!;
            widget.onChanged?.call(value!);
          });
          widget.callback!(currentValue);
        },
        value: currentValue);
  }
}
