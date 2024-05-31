import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;

  const QrCodeWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              'Show this QR code to the organization to after drop-off.'),
          const SizedBox(height: 20),
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 200.0,
          ),
          const SizedBox(height: 50),
          //button to save qr code in phone.
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Placeholder()),
              );
            },
            child: const Text('Save QR Code'),
          ),
        ],
      )),
    );
  }
}
