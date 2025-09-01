import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_template/core/core_const.dart';
import 'package:flutter_template/core/core_static.dart';
import 'package:flutter_template/utility/utility_request.dart';

class UtilityHttp {
  final _coreConst = CoreStatic.coreConst;
  final UtilityRequest _utilityRequest = UtilityRequest();

  Future<({bool? success, List<dynamic>? bookList})> GetBookList(
    String centerCode,
  ) async {
    final uri = Uri.https(_coreConst.host.backend, _coreConst.path.bookList, {
      "centerCode": centerCode,
    });

    final result = await http
        .get(uri, headers: CoreStatic.coreConst.header.json)
        .timeout(const Duration(seconds: 60));

    final body = jsonDecode(result.body);

    return (
      success: (result.statusCode == 200),
      bookList: body as List<dynamic>?,
    );
  }

  Future<
    ({bool? success, String? message, String? token, List<dynamic>? scopeList})
  >
  Login(Map<String, String> loginData) async {
    final uri = Uri.https(_coreConst.host.backend, _coreConst.path.login);

    final result = await http
        .post(
          uri,
          headers: CoreStatic.coreConst.header.json,
          body: jsonEncode(loginData),
        )
        .timeout(const Duration(seconds: 60));

    final body = jsonDecode(result.body);

    return (
      success: body['data']['loginStatus'] == 0,
      message: body['message']?.toString(),
      token: body['data']['token']?.toString(),
      scopeList: body['data']['scopes'] as List<dynamic>?,
    );
  }

  Future<({bool? success})> UploadBookPerference(
    List<dynamic> bookPreferences,
  ) async {
    final uri = Uri.https(
      _coreConst.host.backend,
      _coreConst.path.bookPreference,
      null,
    );

    final result = await http
        .post(
          uri,
          headers: CoreStatic.coreConst.header.json,
          body: jsonEncode(bookPreferences),
        )
        .timeout(const Duration(seconds: 60));

    final body = jsonDecode(result.body);

    return (success: (result.statusCode == 200));
  }
}
