import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatefulWidget {
  final ValueChanged<File?>? callback;

  const PhotoPicker({super.key, this.callback});

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.callback!(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image == null
            ? const Text('No image selected.')
            : Image.file(_image!, height: 200),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Select From Gallery'),
            ),
          ],
        )
      ],
    );
  }
}
