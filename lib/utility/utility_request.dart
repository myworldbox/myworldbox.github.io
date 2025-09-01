import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_record.dart';
import '../../model/model_app.dart';
import 'package:http/http.dart' as http;

import '../core/core_static.dart';
import 'utility_widget.dart';

class UtilityRequest {
  final UtilityWidget _utilityWidget = UtilityWidget();

  Future<bool> postLoop(
    ModelApp app,
    List<CoreRecordRequest> requestLoop,
  ) async {
    for (final request in requestLoop) {
      final response = await http.post(
        request.uri,
        headers: request.headers(),
        body: jsonEncode(request.body()),
      );

      log(
        "[${CoreStatic.coreVar.message}] ${request.uri} <---> ${response.body.toString()}",
      );

      var go = await request.callback(response);

      ScaffoldMessenger.of(app.context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        app.context,
      ).showSnackBar(_utilityWidget.widgetSnackBar(app));

      if (go == false) {
        return false;
      }
    }
    return true;
  }
  Future<(bool, dynamic)> post(
    Uri uri,
    Map<String, String>? headers,
    dynamic jsonMap,
  ) async {
    final response = await http
        .post(uri, headers: headers, body: jsonEncode(jsonMap))
        .timeout(const Duration(seconds: 60));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (true, data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
