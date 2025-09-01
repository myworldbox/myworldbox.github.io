import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform, File, Directory;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/core_static.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_request.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../core/core_generic.dart';
import '../../core/core_record.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../core/core_enum.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late final GlobalKey<FormState> _formKey;
  late Map<CoreEnumInput, TextEditingController> _controller;
  late final List<CoreEnumInput> _fieldList;
  late final List<CoreRecordRequest> _requestLogin;
  late bool _isPasswordVisible;
  late bool _rememberMe;
  late bool _isSubmitting;
  String? _textDialogTopic;
  String? _textDialog;
  Map<String, dynamic>? _data;

  CurrentParam();
}

class CurrentUtility {
  final UtilityRequest _utilityRequest;
  final UtilityActivity _utilityActivity;
  final UtilityConvert _utilityConvert;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityRequest = UtilityRequest(),
      _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  List<Widget> _wrapForm(MwbAuthLogin app) {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final inputList = app.local.utility._utilityWidget.widgetField(
      app,
      ModelUi(controller: param._controller),
    );

    final List<CoreEnumInput?> styledFieldList = [
      CoreEnumInput.mailSchool,
      CoreEnumInput.password,
    ];

    int realIndex = 0;

    final list = styledFieldList
        .where((element) => changeSize ? element != null : true)
        .map((element) {
          final double widthFactor;
          if (element != null && realIndex < inputList.length) {
            realIndex++;
          }
          switch (element) {
            case CoreEnumInput.mailSchool:
            case CoreEnumInput.password:
              widthFactor = 1.0;
              /*
          widthFactor = 0.75;
          widthFactor = 0.5;
          */
              break;
            case null:
              widthFactor = 0.25;
              break;
            default:
              widthFactor = 0.0;
              break;
          }
          return FractionallySizedBox(
            widthFactor: changeSize ? 1.0 : widthFactor,
            child: Padding(
              padding: EdgeInsets.all(size.xxxxs),
              child: element == null ? Container() : inputList[realIndex - 1],
            ),
          );
        })
        .toList();

    return list;
  }

  Widget _form(MwbAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final inputList = app.local.utility._utilityWidget.widgetField(
      app,
      ModelUi(controller: param._controller),
    );

    return Form(
      key: param._formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Wrap(children: func._wrapForm(app)),
          CheckboxListTile(
            value: param._rememberMe,
            onChanged: (value) =>
                app.setState(() => param._rememberMe = value ?? false),
            title: const Text('Remember me'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          ElevatedButton(
            onPressed: () async {
              if (param._isSubmitting) return;
              if (param._formKey.currentState!.validate()) {
                app.setState(() {
                  CoreStatic.coreVar.ok = false;
                  param._isSubmitting = true;
                  param._data = {
                    for (var entry in param._controller.entries)
                      entry.key.name: entry.value.text,
                  };
                });

                try {
                  await utility._utilityRequest.postLoop(
                    app,
                    param._requestLogin,
                  );
                } finally {
                  app.setState(() {
                    param._isSubmitting = false;
                    CoreStatic.coreVar.ok = false;
                  });
                }
              }
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: size.xxxs, horizontal: size.xxs),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                Colors.deepPurple,
              ),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.xxxxs),
                ),
              ),
            ),
            child: const Text('Sign In'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.authRegister.toString(),
              );
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.authForgetPassword.toString(),
              );
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(MwbAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final logo = Image.asset(
      height: eachHeight * 2,
      width: eachHeight * 2,
      'assets/png/${CoreStatic.coreVar.project.name}_favicon_0.png',
      fit: BoxFit.contain,
    );

    final formSection = changeSize
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(size.xs), child: logo),
              _form(app),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(size.xs), child: logo),
              Expanded(child: _form(app)),
            ],
          );

    final mainItems = [
      Container(
        padding: EdgeInsets.symmetric(vertical: eachHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth * (changeSize ? 0.85 : 0.35),
            ),
            child: Container(
              padding: EdgeInsets.all(size.xxs),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(size.xs),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Material(color: Colors.transparent, child: formSection),
            ),
          ),
        ),
      ),
    ];

    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItems),
    ];
  }
}

class MwbAuthLogin
    extends
        ModelApp<
          Pager<MwbAuthLogin>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

    final size = selector.getSize(this);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];
    headers() => {
      ...CoreStatic.coreConst.header.json,
      'Authorization': 'Bearer ${CoreStatic.coreVar.token}',
    };

    setState(() {
      param
        .._formKey = GlobalKey<FormState>()
        .._fieldList = CoreStatic.coreConst.field[CoreStatic.coreVar.route]!
        .._controller = {
          for (var key in param._fieldList)
            key: TextEditingController(text: null),
        }
        .._rememberMe = false
        .._isPasswordVisible = false
        .._isSubmitting = false
        .._textDialogTopic = 'Notice'
        .._requestLogin = [
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/auth"),
            headers: () => CoreStatic.coreConst.header.json,
            body: () => {
              "operator": {"provider": "jwt", "action": "create"},
              "data": {},
            },
            callback: (Response result) async {
              setState(() {
                CoreStatic.coreVar.message = "Data Synced";
                CoreStatic.coreVar.token = result.body;
              });
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/crypto"),
            headers: headers,
            body: () => {
              "operator": {"provider": "crypto", "action": "encrypt"},
              "cache": {
                "target": [
                  CoreEnumInput.mailSchool.name,
                  CoreEnumInput.password.name,
                ],
              },
              "data": param._data,
            },
            callback: (Response result) async {
              setState(() {
                CoreStatic.coreVar.message = "Data Encrypted";
                param._data = jsonDecode(result.body);
              });
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/database"),
            headers: headers,
            body: () => {
              "operator": {"provider": "google_sheet", "action": "get"},
              "cache": {
                "spreadsheetId": "1R-l94_YypmQIoZoBjL_-OMi-HzLCotaCdWCI8u3gMJE",
                "range": "A1:Z100",
                "tab": CoreEnumTab.auth.name,
              },
              "data": param._data,
            },
            callback: (Response result) async {
              final data = jsonDecode(result.body);
              switch (result.statusCode) {
                case 200:
                  if (data is List && data.isEmpty) {
                    setState(() {
                      CoreStatic.coreVar.message = 'Login Failed';
                    });
                    Navigator.pushNamed(
                      context,
                      CoreEnumRoute.authLogin.toString(),
                    );
                    return false;
                  } else if (data is List && data.isNotEmpty) {
                    setState(() {
                      CoreStatic.coreVar
                        ..id = data.first[CoreEnumInput.id.name]
                        ..message = 'Login Succeeded';
                    });
                  }
                  break;
                case 500:
                  break;
              }
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/database"),
            headers: headers,
            body: () => {
              "operator": {"provider": "google_sheet", "action": "get"},
              "cache": {
                "spreadsheetId": "1R-l94_YypmQIoZoBjL_-OMi-HzLCotaCdWCI8u3gMJE",
                "range": "A1:Z100",
                "tab": CoreEnumTab.user.name,
              },
              "data": {CoreEnumInput.id.name: CoreStatic.coreVar.id},
            },
            callback: (Response result) async {
              final data = jsonDecode(result.body);
              switch (result.statusCode) {
                case 200:
                  if (data is List && data.isEmpty) {
                    setState(() {
                      CoreStatic.coreVar.message = 'Incomplete User Info';
                    });
                    Navigator.pushNamed(
                      context,
                      CoreEnumRoute.userUpdateUser.toString(),
                    );
                  } else if (data is List && data.isNotEmpty) {
                    setState(() {
                      CoreStatic.coreVar
                        ..cache = data.first
                        ..message = 'Welcome';
                    });
                    Navigator.pushNamed(
                      context,
                      CoreEnumRoute.userSetting.toString(),
                    );
                  }
                  break;
                case 500:
                  setState(() {
                    CoreStatic.coreVar.message = 'Incomplete User Info';
                  });
                  Navigator.pushNamed(
                    context,
                    CoreEnumRoute.userUpdateUser.toString(),
                  );
                  break;
              }
            },
          ),
        ];
    });
  };

  @override
  get refresh => () async {
    await local.utility._utilityActivity.refresh(this);
  };

  @override
  get renew => () async {
    await local.utility._utilityActivity.renew(this);
  };

  @override
  get discard => () async {
    await local.utility._utilityActivity.discard(this);
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
