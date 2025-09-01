import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../item/layout/default_layout.dart';
import '../../model/model_app.dart';

class UtilityConvert {
  String stringToSnakeCase(String input) {
    if (input.isEmpty) return input;

    // Insert underscores between lowercase and uppercase letters
    String withUnderscores = input.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (Match m) => '${m[1]}_${m[2]}',
    );

    // Handle sequences like "aBCD" -> "a_b_c_d"
    withUnderscores = withUnderscores.replaceAllMapped(
      RegExp(r'([A-Z])([A-Z][a-z])'),
      (Match m) => '${m[1]}_${m[2]}',
    );

    // Replace non-alphanumeric characters with underscores
    withUnderscores = withUnderscores.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');

    // Convert to lowercase
    return withUnderscores.toLowerCase();
  }

  Map<String, dynamic> mapKeyToMap(Map<CoreEnumInput, dynamic> map) {
    return map.map((key, value) => MapEntry(key.name, value));
  }

  Map<String, dynamic> listToMap(List<dynamic> list) {
    Map<String, dynamic> map = {};

    for (var item in list[0]) {
      map[item] = list
          .sublist(1)
          .map(
            (e) => e.length > list[0].indexOf(item)
                ? e[list[0].indexOf(item)]
                : null,
          )
          .toList();
    }
    return map;
  }

  Color hexToColor(String color) {
    return Color(int.parse(color.replaceAll('#', '0xff')));
  }

  String toVerticalText(String text) {
    return text.split('').join('\n');
  }

  String toLocaleAlias(String locale) {
    return locale.replaceAllMapped(
      RegExp(r'^([a-zA-Z]{2})-([a-zA-Z]{2})$'),
      (Match m) => '${m[1]!.toLowerCase()}_${m[2]!.toLowerCase()}',
    );
  }

  String toCustomizedTime(CoreEnumLocale locale) {
    String timeFormatted;
    DateTime now = DateTime.now();

    String hour = (now.hour % 12).toString();
    if (hour == '0') hour = '12';
    String minute = now.minute.toString().padLeft(2, '0');

    switch (locale) {
      case CoreEnumLocale.zhCn:
      case CoreEnumLocale.zhHk:
        String period = now.hour >= 12 ? '下午' : '上午';
        timeFormatted = '$period$hour時$minute分';
        break;
      case CoreEnumLocale.enUs:
        String period = now.hour >= 12 ? 'PM' : 'AM';
        timeFormatted = '$hour:$minute $period';
        break;
    }
    return timeFormatted;
  }

  String toCustomizedDate(CoreEnumLocale locale) {
    String dateFormatted;
    DateTime now = DateTime.now();

    String year = now.year.toString();
    String month = now.month.toString();
    String day = now.day.toString();

    switch (locale) {
      case CoreEnumLocale.zhCn:
      case CoreEnumLocale.zhHk:
        dateFormatted = '$year年$month月$day日';
        break;
      case CoreEnumLocale.enUs:
        dateFormatted = '$month/$day/$year';
        break;
    }
    return dateFormatted;
  }

  String htmlToText(String htmlContent) {
    // Remove HTML tags
    final RegExp tagRegExp = RegExp(
      r'<[^>]*>',
      multiLine: true,
      caseSensitive: true,
    );
    String textContent = htmlContent.replaceAll(tagRegExp, '');

    // Remove HTML entities
    final RegExp entityRegExp = RegExp(
      r'&[^;]+;',
      multiLine: true,
      caseSensitive: true,
    );
    textContent = textContent.replaceAll(entityRegExp, '');

    return textContent;
  }

  String uint8ListToHex(Uint8List b) => b
      .fold('', (s, b) => s + b.toRadixString(16).padLeft(2, '0'))
      .padRight(16, '0')
      .substring(0, 16);

  String uint8ListToBase64(Uint8List b) => base64Url
      .encode(b)
      .replaceAll('=', '')
      .padRight(16, '0')
      .substring(0, 16);

  String uint8ListToUuid(Uint8List b) {
    final h = md5.convert(b).toString();
    return '${h.substring(0, 4)}-${h.substring(4, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}';
  }

  String uint8ListToSha1(Uint8List b) =>
      sha1.convert(b).toString().substring(0, 16);

  String uint8ListToId(Uint8List b) => (b.fold(
    0,
    (p, b) => (p * 256 + b) % 10000000000000000,
  )).toString().padLeft(16, '0');
  
  dynamic stringToDynamic(String data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return data;
    }
  }
}
