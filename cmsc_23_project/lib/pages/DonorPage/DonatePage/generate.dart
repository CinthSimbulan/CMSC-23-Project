import 'package:cmsc_23_project/pages/DonorPage/DonatePage/qrcode.dart';
import 'package:flutter/material.dart';

class GenerateQrButtonWidget extends StatefulWidget {
  static const routename = '/generateQr';
  final String? donationId;

  const GenerateQrButtonWidget({super.key, this.donationId});

  @override
  State<GenerateQrButtonWidget> createState() => _GenerateQrButtonWidgetState();
}

class _GenerateQrButtonWidgetState extends State<GenerateQrButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donationId ?? "Generate QR Code"),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrCodeWidget(data: widget.donationId!),
              ),
            );
          },
          child: const Text(
            "Generate QR Code",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
