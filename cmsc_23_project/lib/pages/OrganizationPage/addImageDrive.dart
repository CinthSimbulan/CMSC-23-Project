import 'package:flutter/material.dart';

class Addimagedrive extends StatefulWidget {
  const Addimagedrive({super.key, this.donation});

  static const routename = '/addimagedrive';
  final Map? donation;

  @override
  State<Addimagedrive> createState() => _AddimagedriveState();
}

class _AddimagedriveState extends State<Addimagedrive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add image to prove donation'),
      ),
    );
  }
}
