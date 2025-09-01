import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;
import '../../core/core_var.dart';
import '../core/core_enum.dart';
import '../core/core_static.dart'; // For web support
import 'dart:convert'; // For jsonEncode/jsonDecode

class UtilityStorage {
  final CoreVar _coreVar = CoreStatic.coreVar;

  Future<void> create(Map<CoreEnumStorage, dynamic> data) async {
    if (kIsWeb) {
      data.forEach((key, value) {
        web.window.localStorage.setItem(key.name, jsonEncode(value));
      });
    } else {
      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _coreVar.sharedPrefs?.setString(key.name, value);
        } else if (value is bool) {
          await _coreVar.sharedPrefs?.setBool(key.name, value);
        } else if (value is int) {
          await _coreVar.sharedPrefs?.setInt(key.name, value);
        } else if (value is double) {
          await _coreVar.sharedPrefs?.setDouble(key.name, value);
        } else if (value is Map || value is List) {
          await _coreVar.sharedPrefs?.setString(key.name, jsonEncode(value));
        } else {
          throw ArgumentError('Unsupported type for storage at key: $key');
        }
      }
    }
  }

  dynamic read(CoreEnumStorage key) {
    final raw = kIsWeb
        ? web.window.localStorage.getItem(key.name)
        : _coreVar.sharedPrefs?.get(key.name);

    try {
      final decoded = jsonDecode(raw.toString());
      return decoded;
    } catch (_) {
      return raw; // Return as-is if not JSON
    }
  }

  Future<void> update(Map<CoreEnumStorage, dynamic> data) async => create(data);

  Future<void> delete(List<CoreEnumStorage> key) async {
    if (kIsWeb) {
      key.forEach((key) {
        web.window.localStorage.removeItem(key.name);
      });
    } else {
      key.map((key) async {
        await _coreVar.sharedPrefs?.remove(key.name);
      });
    }
  }

  Future<void> deleteAll() async {
    if (kIsWeb) {
      web.window.localStorage.clear();
    } else {
      _coreVar.sharedPrefs?.clear();
    }
  }
}
