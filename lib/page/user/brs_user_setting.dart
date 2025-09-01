import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/core_static.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_http.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_storage.dart';
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
  late String _textCenterCode;
  late bool _isSubmitting;
  late String _textSubmit;
  late String _textBack;
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
  final UtilityStorage _utilityStorage;

  CurrentUtility()
    : _utilityRequest = UtilityRequest(),
      _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp(),
      _utilityStorage = UtilityStorage();
}

class CurrentFunc {
  List<Widget> _wrapForm(BrsUserSetting app) {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final inputList = app.local.utility._utilityWidget.widgetField(
      app,
      ModelUi(controller: param._controller),
    );

    final List<CoreEnumInput?> styledFieldList = [CoreEnumInput.centerCode];

    int realIndex = 0;

    final list = styledFieldList
        .where((element) => changeSize ? element != null : true)
        .map((element) {
          final double widthFactor;
          if (element != null && realIndex < inputList.length) {
            realIndex++;
          }
          switch (element) {
            case CoreEnumInput.centerCode:
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

  Widget _form(BrsUserSetting app) {
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
        children: [
          Wrap(children: func._wrapForm(app)),
          Container(
            padding: EdgeInsets.all(size.xxxs),
            child: Row(
              spacing: size.xxxs,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        vertical: size.xxxs,
                        horizontal: size.xxs,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.purple,
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
                  onPressed: () async {
                    if (param._isSubmitting) return;
                    if (param._formKey.currentState!.validate()) {
                      app.setState(() {
                        param._isSubmitting = true;

                        param._data = {
                          for (var entry in param._controller.entries)
                            entry.key.name: entry.value.text,
                        };
                      });

                      try {
                        final String? centerCode =
                            param._data![CoreEnumInput.centerCode.name]!;

                        await utility._utilityStorage.delete([
                          CoreEnumStorage.centerCode,
                          CoreEnumStorage.bookList,
                        ]);

                        await utility._utilityStorage.create(
                          <CoreEnumStorage, dynamic>{
                            CoreEnumStorage.centerCode: centerCode,
                          },
                        );

                        final result = await utility._utilityHttp.GetBookList(
                          centerCode.toString().padLeft(4, '0'),
                        );
                        await utility._utilityStorage.create(
                          <CoreEnumStorage, dynamic>{
                            CoreEnumStorage.bookList: result.bookList!,
                          },
                        );

                        Navigator.pushNamed(
                          app.context,
                          CoreEnumRoute.root.toString(),
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
                  child: Text(param._textSubmit),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        vertical: size.xxxs,
                        horizontal: size.xxs,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                    textStyle: WidgetStateProperty.all(
                      TextStyle(fontSize: size.xxs),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.xxxxs),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      app.context,
                      CoreEnumRoute.root.toString(),
                    );
                  },
                  child: Text(param._textBack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(BrsUserSetting app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final logo = SizedBox.shrink();

    final formSection = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [logo, _form(app)],
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
      utility._utilityWidget.widgetCloseButton(app),
    ];
  }
}

class BrsUserSetting
    extends
        ModelApp<
          Pager<BrsUserSetting>,
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
    final domainJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.domain, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    setState(() {
      param
        .._fieldList = CoreStatic.coreConst.field[CoreStatic.coreVar.route]!
        .._controller = {
          for (var key in param._fieldList) key: TextEditingController(),
        }
        .._formKey = GlobalKey<FormState>()
        .._textSubmit = localeJson["confirm"].toString()
        .._textBack = localeJson["cancel"].toString()
        .._textCenterCode = localeRouteJson["center_code"].toString()
        .._isSubmitting = false;
    });

    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<CoreEnumBrs, dynamic>;

    final List<dynamic> scopeList = argument[CoreEnumBrs.scopeList];

    final List<({String displayText, String value})> scopeCodeList = scopeList
        .map(
          (x) => (
            displayText: "${x['scopeCode']} - ${x['longNameChinese']}",
            value: x['scopeCode'] as String,
          ),
        )
        .toList();

    String? centerCode = utility._utilityStorage.read(
      CoreEnumStorage.centerCode,
    );

    // Select a random value for hint
    final randomValue =
        scopeCodeList[Random().nextInt(scopeCodeList.length)].value;

    // Create the pattern using the values from scopeCodeList
    final pattern =
        '^(${scopeCodeList.map((scope) => RegExp.escape(scope.value)).join('|')})\$';

    final inputExtend = {
      CoreEnumInput.centerCode: (
        name: param._textCenterCode,
        hint: 'e.g. ${randomValue}',
        pattern: pattern,
        iconData: Icons.home,
        enable: true,
        readOnly: false,
        select: scopeCodeList,
        defaultValue: centerCode?.toString().padLeft(4, '0'),
      ),
    };

    setState(() {
      CoreStatic.coreVar.inputExtend = {
        ...inputExtend,
        ...CoreStatic.coreConst.inputAll,
      };
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
