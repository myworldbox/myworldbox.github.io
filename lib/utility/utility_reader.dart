import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_library/@core/core_enum.dart';

class UtilityReader {
  Future<dynamic> readFile(String path) async {
    try {
      // Get the file extension from the enum
      final extension = path.toString().split('.').last.toLowerCase();
      CoreEnumFile? enumFile = CoreEnumFile.values.firstWhere(
        (e) => e.name == extension,
      );

      // Process based on file type
      switch (enumFile) {
        // JSON files
        case CoreEnumFile.json:
          final data = await rootBundle.loadString(path);
          return json.decode(data);

        // Text-based files
        case CoreEnumFile.txt:
        case CoreEnumFile.md:
        case CoreEnumFile.env:
        case CoreEnumFile.css:
        case CoreEnumFile.js:
        case CoreEnumFile.html:
        case CoreEnumFile.xml:
          return await rootBundle.loadString(path); // Return as plain text

        // Binary file types that could be converted to base64
        case CoreEnumFile.avi:
        case CoreEnumFile.bmp:
        case CoreEnumFile.docx:
        case CoreEnumFile.gif:
        case CoreEnumFile.jpeg:
        case CoreEnumFile.jpg:
        case CoreEnumFile.mov:
        case CoreEnumFile.mp3:
        case CoreEnumFile.mp4:
        case CoreEnumFile.pdf:
        case CoreEnumFile.png:
        case CoreEnumFile.ppt:
        case CoreEnumFile.rar:
        case CoreEnumFile.svg:
        case CoreEnumFile.tiff:
        case CoreEnumFile.wav:
        case CoreEnumFile.xls:
        case CoreEnumFile.zip:
          // For binary files, load as bytes instead
          final byteData = await rootBundle.load(path);
          final bytes = byteData.buffer.asUint8List();
          return base64Encode(bytes);
      }
    } catch (e) {
      log('Error reading file: $e');
      return null;
    }
  }
}
