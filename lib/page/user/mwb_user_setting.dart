import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_record.dart';
import '../../core/core_static.dart';
import '../../item/layout/overlay_layout.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_request.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {
  late final GlobalKey<FormState> _formKey;
  late List<CoreRecordRequest> _requestDelete;
  late bool _isSubmitting;
}

class CurrentUtility {
  final UtilityRequest _utilityRequest;
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityRequest = UtilityRequest(),
      _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  Widget _form(MwbUserSetting app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Form(
      key: param._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: size.xxs,
        children: [
          Center(child: Text('${CoreStatic.coreVar.id}')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.userUpdateAuth.toString(),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: Text(
              'Update Auth Info',
              style: TextStyle(fontSize: size.xxs, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.userUpdateUser.toString(),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: Text(
              'Update User Info',
              style: TextStyle(fontSize: size.xxs, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (param._isSubmitting) return;
                app.setState(() {
                  param._isSubmitting = true;
                });
                await utility._utilityRequest.postLoop(
                  app,
                  param._requestDelete,
                );
              } catch (e) {
                log('Error occurred: $e');
              } finally {
                app.setState(
                  () => param._isSubmitting = false,
                ); // Re-enable button
              }

              Navigator.pushNamed(app.context, CoreEnumRoute.root.toString());
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: Text(
              'Delete Account',
              style: TextStyle(fontSize: size.xxs, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              app.setState(() {
                CoreStatic.coreVar
                  ..token = null
                  ..id = null;
              });
              Navigator.pushNamed(app.context, CoreEnumRoute.root.toString());
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: size.xxs)),
            ),
            child: Text(
              'Logout', // Fixed typo: 'Logoutg' to 'Logout'
              style: TextStyle(fontSize: size.xxs, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(MwbUserSetting app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final logo = Image.asset(
      height: eachHeight * 2,
      width: eachHeight * 2,
      'assets/png/${CoreStatic.coreVar.project.name}_favicon_1.png',
      fit: BoxFit.contain,
    );

    final formSection = Column(
      mainAxisSize: MainAxisSize.min, // Important: allows Column to wrap
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.all(size.s), child: logo),
        _form(app),
      ],
    );

    List<Widget> mainItems = [
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

class MwbUserSetting
    extends
        ModelApp<
          Pager<MwbUserSetting>,
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
        .._isSubmitting = false
        .._requestDelete = [
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
              "operator": {"provider": "google_sheet", "action": "delete"},
              "cache": {
                "spreadsheetId": "1R-l94_YypmQIoZoBjL_-OMi-HzLCotaCdWCI8u3gMJE",
                "range": "A1:Z100",
                "tab": CoreEnumTab.user.name,
              },
              "data": {CoreEnumInput.id.name: CoreStatic.coreVar.id},
            },
            callback: (Response result) async {
              switch (result.statusCode) {
                case 200:
                  setState(() {
                    CoreStatic.coreVar.message = 'User Data Deleted';
                  });
                  break;
                case 500:
                  setState(() {
                    CoreStatic.coreVar.message = 'Deletion Failed';
                  });
                  return false;
              }
            },
          ),
          (
            uri: Uri.https(CoreStatic.coreConst.host.myapibox, "api/database"),
            headers: headers,
            body: () => {
              "operator": {"provider": "google_sheet", "action": "delete"},
              "cache": {
                "spreadsheetId": "1R-l94_YypmQIoZoBjL_-OMi-HzLCotaCdWCI8u3gMJE",
                "range": "A1:Z100",
                "tab": CoreEnumTab.auth.name,
              },
              "data": {CoreEnumInput.id.name: CoreStatic.coreVar.id},
            },
            callback: (Response result) async {
              switch (result.statusCode) {
                case 200:
                  setState(() {
                    CoreStatic.coreVar.message = 'Auth Data Deleted';
                  });
                  break;
                case 500:
                  setState(() {
                    CoreStatic.coreVar.message = 'Deletion Failed';
                  });
                  return false;
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
  get discard => () async {};

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
