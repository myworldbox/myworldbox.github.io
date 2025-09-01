import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image' as img;
import 'package:qr_code_tools/qr_code_tools.dart'
    as qr_tools; // Alias to avoid conflicts
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QrCodeReader extends StatefulWidget {
  final Uint8List qrImageBytes; // QR code image as bytes

  const QrCodeReader({required this.qrImageBytes, super.key});

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  String? _qrCodeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decodeQrCode();
  }

  Future<void> _decodeQrCode() async {
    try {
      // Decode bytes to an image
      final image = img.decodeImage(widget.qrImageBytes);
      if (image == null) {
        setState(() {
          _qrCodeData = 'Failed to decode image bytes';
          _isLoading = false;
        });
        return;
      }

      // Save image to a temporary file (qr_code_tools requires a file path)
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_qr.png');
      await tempFile.writeAsBytes(img.encodePng(image));

      // Decode QR code from the file using qr_code_tools' decodeFrom
      final data = await qr_tools.decodeFrom(tempFile.path);

      setState(() {
        _qrCodeData = data ?? 'No QR code found';
        _isLoading = false;
      });

      // Clean up temporary file
      await tempFile.delete();
    } catch (e) {
      setState(() {
        _qrCodeData = 'Error decoding QR code: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Text(
              _qrCodeData ?? 'No data',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          Image.memory(
            widget.qrImageBytes,
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) =>
                const Text('Invalid image bytes'),
          ),
        ],
      ),
    );
  }
}
