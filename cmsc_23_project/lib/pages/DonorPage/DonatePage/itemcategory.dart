import 'package:flutter/material.dart';

class ItemCategory extends StatefulWidget {
  final Function(bool)? callback;
  final ValueChanged? onChanged;
  final String? category;
  const ItemCategory({super.key, this.onChanged, this.category, this.callback});

  @override
  State<ItemCategory> createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory> {
  bool item = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.category!),
        leading: Checkbox(
          value: widget.callback!(item),
          onChanged: (bool? value) {
            setState(() {
              item = !item;
            });
          },
        ));
  }
}
