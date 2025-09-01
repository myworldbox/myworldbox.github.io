import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform, File, Directory;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/utility/utility_http.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/core_static.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_request.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../../core/core_record.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../core/core_enum.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late final GlobalKey<FormState> _formKey;
  late Map<CoreEnumInput, TextEditingController> _controller;
  late List<CoreEnumInput> _fieldList;
  late List<CoreEnumInput?> _styledFieldList;
  late bool _isPasswordVisible;
  late bool _rememberMe;
  late bool _isSubmitting;
  late List<CoreRecordRequest> _requestLogin;

  late final String _textLoginTopic;
  late final String _textUsername;
  late final String _textPassword;
  late final String _textLoginButton;
  late final String _textForgetPassword;
  late final String _textLoginSuccess;
  late final String _textLoginFailed;

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
  final UtilityHttp _utilityHttp;

  CurrentUtility()
    : _utilityRequest = UtilityRequest(),
      _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp();
}

class CurrentFunc {
  List<Widget> _wrapForm(BrsAuthLogin app) {
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
      CoreEnumInput.nameUser,
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
            case CoreEnumInput.nameUser:
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

  Widget _form(BrsAuthLogin app) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(param._textLoginTopic, style: TextStyle(fontSize: size.xs)),
          Wrap(children: func._wrapForm(app)),
          /*
          CheckboxListTile(
            value: param._rememberMe,
            onChanged: (value) =>
                app.setState(() => param._rememberMe = value ?? false),
            title: const Text('Remember me'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          */
          Container(
            padding: EdgeInsets.all(size.xxxs),
            child: ElevatedButton(
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
                    final result = await utility._utilityHttp.Login({
                      "userName": param._data?[CoreEnumInput.nameUser.name],
                      "password": param._data?[CoreEnumInput.password.name],
                    });

                    switch (result.success) {
                      case true:
                        Navigator.pushNamed(
                          app.context,
                          CoreEnumRoute.userSetting.toString(),
                          arguments: <CoreEnumBrs, dynamic>{
                            CoreEnumBrs.token: result.token,
                            CoreEnumBrs.scopeList: result.scopeList,
                          },
                        );
                        break;
                      default:
                        app.setState(() {
                          CoreStatic.coreVar.ok = true;
                          param._isSubmitting = false;
                        });
                        break;
                    }

                    CoreStatic.coreVar.message = [
                      result.success == true
                          ? param._textLoginSuccess
                          : param._textLoginFailed,
                      result.message,
                    ].where((str) => str != null && str.isNotEmpty).join(' - ');

                    ScaffoldMessenger.of(app.context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(
                      app.context,
                    ).showSnackBar(utility._utilityWidget.widgetSnackBar(app));
                  } catch (e) {
                    log('Error occurred: $e');
                  }
                }
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    vertical: size.xxxs,
                    horizontal: size.xxs,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.deepPurple,
                ),
                textStyle: WidgetStateProperty.all(
                  TextStyle(fontSize: size.xxs),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.xxxxs),
                  ),
                ),
              ),
              child: Text(param._textLoginButton),
            ),
          ),
          /*
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
          */
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                final url = Uri.https(
                  CoreStatic.coreConst.host.backend,
                  CoreStatic.coreConst.path.heCanForgetPassword,
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  TextStyle(fontSize: size.xxs),
                ),
              ),
              child: Text(param._textForgetPassword),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(BrsAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    /*
    final logo = Image.asset(
      height: eachHeight * 2,
      width: eachHeight * 2,
      'assets/png/${CoreStatic.coreVar.project.name}_favicon_0.png',
      fit: BoxFit.contain,
    );
    */

    final formSection = Flex(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      direction: Axis.vertical,
      children: [
        // Padding(padding: EdgeInsets.all(size.xs), child: logo),
        _form(app),
      ],
    );

    final mainItems = [
      Container(
        padding: EdgeInsets.symmetric(vertical: eachHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth * (changeSize ? 0.85 : 0.20),
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
      utility._utilityWidget.widgetCloseButton(app),
      Positioned(
        bottom: size.xxxs,
        left: size.xxxs,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(app.context, CoreEnumRoute.root.toString());
          },
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black,
          child: const Icon(Icons.menu_book_rounded),
        ),
      ),
    ];
  }
}

class BrsAuthLogin
    extends
        ModelApp<
          Pager<BrsAuthLogin>,
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
      CoreStatic.coreVar
        ..inputExtend![CoreEnumInput.nameUser] = (
          iconData:
              CoreStatic.coreConst.inputAll[CoreEnumInput.nameUser]!.iconData,
          pattern:
              CoreStatic.coreConst.inputAll[CoreEnumInput.nameUser]!.pattern,
          name: localeRouteJson["username"].toString(),
          hint: "請輸入正確用戶名稱",
          enable: true,
          readOnly: false,
          select: null,
          defaultValue: null,
        )
        ..inputExtend![CoreEnumInput.password] = (
          iconData:
              CoreStatic.coreConst.inputAll[CoreEnumInput.password]!.iconData,
          pattern:
              CoreStatic.coreConst.inputAll[CoreEnumInput.password]!.pattern,
          name: localeRouteJson["password"].toString(),
          hint: "請輸入正確密碼",
          enable: true,
          readOnly: false,
          select: null,
          defaultValue: null,
        );

      param
        .._formKey = GlobalKey<FormState>()
        .._fieldList = CoreStatic.coreConst.field[CoreStatic.coreVar.route]!
        .._controller = {
          for (var key in param._fieldList)
            key: TextEditingController(text: null),
        }
        .._isPasswordVisible = false
        .._rememberMe = false
        .._isSubmitting = false
        .._textLoginTopic = localeRouteJson["login_topic"].toString()
        .._textUsername = localeRouteJson["username"].toString()
        .._textPassword = localeRouteJson["password"].toString()
        .._textLoginButton = localeRouteJson["login_button"].toString()
        .._textForgetPassword = localeRouteJson["forget_password"].toString()
        .._textLoginSuccess = localeJson["alert"]["login_success"].toString()
        .._textLoginFailed = localeJson["alert"]["login_failed"].toString();
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
