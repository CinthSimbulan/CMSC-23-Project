import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputField extends StatefulWidget {
  final int? title;
  final Function(int)? callback;
  final ValueChanged? onChanged;

  const NumberInputField(
      {super.key, this.onChanged, this.callback, this.title});

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  int inputValue = 0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          setState(() {
            inputValue = intValue;
            widget.onChanged?.call(intValue);
          });
          widget.callback!(inputValue);
        }
      },
      decoration: InputDecoration(
        hintText: widget.title.toString(),
      ),
    );
  }
}
