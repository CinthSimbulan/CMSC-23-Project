import 'package:cmsc_23_project/pages/OrgPage/editstatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQrPage extends StatefulWidget {
  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  String _scanResult = '';

  Future<void> _scanQRCode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } catch (e) {
      scanResult = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanResult = scanResult;
    });

    // Navigate to the form page if the scan result matches expected data
    if (_scanResult == 'EditStatus') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditStatus()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanQRCode,
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}
