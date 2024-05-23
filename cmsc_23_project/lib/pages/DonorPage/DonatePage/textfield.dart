import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final Function(String)? callback;
  final ValueChanged? onChanged;
  final String? title;
  const TextFieldWidget({super.key, this.onChanged, this.callback, this.title});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String inputValue = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // validator: (value) {
        //   if (inputValue == "") return widget.title;
        //   return null;
        // },
        onChanged: (value) {
          setState(() {
            inputValue = value;
            widget.onChanged?.call(value);
          });
          widget.callback!(inputValue);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(widget.title!),
        ));
  }
}
