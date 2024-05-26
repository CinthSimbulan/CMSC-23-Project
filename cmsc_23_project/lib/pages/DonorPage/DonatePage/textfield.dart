import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final Function(String) callback;
  final String hintText;
  final TextEditingController controller;

  const TextFieldWidget(
      {required this.callback,
      required this.hintText,
      super.key,
      required this.controller});
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
      onSubmitted: (value) {
        widget.callback(value);
        widget.controller.clear();
      },
    );
  }
}
