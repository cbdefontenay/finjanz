import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code scannen'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            tooltip: 'Manuelle Eingabe',
            onPressed: () => _showManualInputDialog(context),
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isScanned) return;
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              setState(() {
                _isScanned = true;
              });
              Navigator.pop(context, barcode.rawValue);
              break;
            }
          }
        },
      ),
    );
  }

  void _showManualInputDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Manuelle Eingabe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Falls dein Gerät den integrierten Scanner nicht unterstützt (z.B. wegen fehlender Play-Dienste), scanne den QR-Code mit einer anderen App und füge den erkannten Text hier ein.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'QR-Code Text hier einfügen',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              if (controller.text.isNotEmpty) {
                // Return text to the caller
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Importieren'),
          ),
        ],
      ),
    );
  }
}
