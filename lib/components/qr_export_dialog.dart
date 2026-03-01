import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrExportDialog extends StatelessWidget {
  final String qrData;

  const QrExportDialog({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final bool isTooLarge = qrData.length > 2500; // QR v40 limit

    return AlertDialog(
      title: const Text('QR Code Share'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isTooLarge)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Zu viele Daten für einen QR-Code. Bitte wähle einen kleineren Zeitraum oder nutze den CSV-Export.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Lass diesen Code von einem anderen Gerät abscannen, um die Daten zu importieren.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}
