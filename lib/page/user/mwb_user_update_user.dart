import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/item/layout/grid_layout.dart';
import '../../core/core_static.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../core/core_generic.dart';
import '../../core/core_record.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../core/core_enum.dart';
import 'package:flutter_library/@core/core_enum.dart';

import '../../utility/utility_request.dart';

class CurrentParam {
  late final GlobalKey<FormState> _formKey;
  late Map<CoreEnumInput, TextEditingController> _controller;
  late List<CoreEnumInput> _fieldList;
  late bool _accountExist;
  late bool _emailSubcription;
  late bool _isSubmitting;
  late List<CoreRecordRequest> _requestGetUser;
  late List<CoreRecordRequest> _requestLogin;
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
  List<Widget> _wrapForm(MwbUserUpdateUser app) {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final inputList = app.local.utility._utilityWidget.widgetField(
      app,
      ModelUi(controller: param._controller),
    );

    int realIndex = 0;

    final styledFieldList = [
      /* { 0 } */
      CoreEnumInput.nameFirst,
      CoreEnumInput.nameLast,
      null,
      CoreEnumInput.dateOfBirth,

      null,
      CoreEnumInput.countryCode,
      CoreEnumInput.phoneNumberPrimary,
      null,

      CoreEnumInput.mailPersonal,
      null,
      null,
      null,
      CoreEnumInput.idTelegram,

      null,
      null,
      null,
      CoreEnumInput.idInstagram,

      CoreEnumInput.membership,
      null,
      null,
    ];

    final list = styledFieldList.where(
          (element) => changeSize ? element != null : true,
        )
        .map((element) {
          final double widthFactor;
          if (element != null && realIndex < inputList.length) {
            realIndex++;
          }
          switch (element) {
            case CoreEnumInput.dateOfBirth:
            case CoreEnumInput.mailPersonal:
              widthFactor = 0.75;
              break;
            case CoreEnumInput.idTelegram:
            case CoreEnumInput.idInstagram:
              widthFactor = 0.5;
              break;
            case null:
            case CoreEnumInput.nameFirst:
            case CoreEnumInput.nameLast:
            case CoreEnumInput.countryCode:
            case CoreEnumInput.phoneNumberPrimary:
            case CoreEnumInput.membership:
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

  Widget _form(MwbUserUpdateUser app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Form(
      key: param._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(children: func._wrapForm(app)),
          CheckboxListTile(
            value: param._emailSubcription,
            onChanged: (value) =>
                app.setState(() => param._emailSubcription = value ?? false),
            title: const Text('Subscribe To Official Event'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (param._isSubmitting) return;
                if (param._formKey.currentState!.validate()) {
                  try {
                    app.setState(() {
                      param._isSubmitting = true;
                      param._data = {
                        for (var entry in param._controller!.entries)
                          entry.key.name: entry.value.text,
                      };
                    });
                    await utility._utilityRequest.postLoop(
                      app,
                      param._requestLogin,
                    );
                  } catch (e) {
                    log('Error occurred: $e');
                  } finally {
                    app.setState(
                      () => param._isSubmitting = false,
                    ); // Re-enable button
                  }
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(app.context);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(MwbUserUpdateUser app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final logo = SizedBox.shrink();

    final formSection = changeSize
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [logo, _form(app)],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo,
              Expanded(child: _form(app)),
            ],
          );

    final mainItems = [
      Container(
        padding: EdgeInsets.symmetric(vertical: eachHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth * 0.85),
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

class MwbUserUpdateUser
    extends
        ModelApp<
          Pager<MwbUserUpdateUser>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

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
        .._accountExist = false
        .._emailSubcription = false
        .._isSubmitting = false
        .._requestGetUser = [
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/auth"),
            headers: () => CoreStatic.coreConst.header.json,
            body: () => {
              "operator": {"provider": "jwt", "action": "create"},
              "data": {},
            },
            callback: (Response result) async {
              setState(() {
                CoreStatic.coreVar.message = "Synced";
                CoreStatic.coreVar.token = result.body;
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
                      CoreStatic.coreVar.message = 'User Info Not Existed';
                    });
                    return false;
                  } else if (data is List && data.isNotEmpty) {
                    setState(() {
                      CoreStatic.coreVar.message = 'User Info Retrieved';
                      param
                        .._data = data.first
                        .._accountExist = true;
                    });
                  }
                  break;
                case 500:
                  break;
              }
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/crypto"),
            headers: headers,
            body: () => {
              "operator": {"provider": "crypto", "action": "decrypt"},
              "cache": {
                "target": [
                  ...param._fieldList.map((f) => f.name),
                  CoreEnumInput.emailSubscription.name,
                ],
              },
              "data": param._data,
            },
            callback: (Response result) async {
              final data = jsonDecode(result.body);
              switch (result.statusCode) {
                case 200:
                  setState(() {
                    CoreStatic.coreVar.message = "Decrypted";
                    for (var key in param._fieldList) {
                      log("${key} to ${data[key.name]}");
                      if (param._controller!.containsKey(key)) {
                        param._controller![key]!.text = data[key.name];
                      }
                    }
                    bool emailSubscription =
                        data[CoreEnumInput.emailSubscription.name];
                    setState(() {
                      param._emailSubcription = emailSubscription;
                    });
                  });
                  break;
                case 500:
                  break;
              }
            },
          ),
        ]
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
                CoreStatic.coreVar.message = "Synced";
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
                  ...param._fieldList.map((f) => f.name),
                  CoreEnumInput.emailSubscription.name,
                ],
              },
              "data": {
                ...param._data!,
                CoreEnumInput.emailSubscription.name: param._emailSubcription,
              },
            },
            callback: (Response result) async {
              setState(() {
                CoreStatic.coreVar.message = "Encrypted";
                param._data = jsonDecode(result.body);
              });
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/database"),
            headers: headers,
            body: () => {
              "operator": {
                "provider": "google_sheet",
                "action": param._accountExist ? "update" : "create",
              },
              "cache": {
                "spreadsheetId": "1R-l94_YypmQIoZoBjL_-OMi-HzLCotaCdWCI8u3gMJE",
                "range": "A1:Z100",
                "tab": CoreEnumTab.user.name,
              },
              "data": {
                CoreEnumInput.datetime.name: utility._utilitySelector.getTime(),
                CoreEnumInput.id.name: CoreStatic.coreVar.id,
                ...param._data!,
              },
            },
            callback: (result) async {
              setState(() {
                CoreStatic.coreVar
                  ..cache = param._data
                  ..message = 'User Info Updated';
              });
              Navigator.pushNamed(
                context,
                CoreEnumRoute.userSetting.toString(),
              );
            },
          ),
        ];
    });

    if (CoreStatic.coreVar.id is String) {
      try {
        setState(() {
          if (param._isSubmitting) return;
          param._isSubmitting = true;
        });
        await local.utility._utilityRequest.postLoop(
          this,
          param._requestGetUser,
        );
      } catch (e) {
        log('Error occurred: $e');
      } finally {
        setState(() => param._isSubmitting = false); // Re-enable button
      }
    }
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
