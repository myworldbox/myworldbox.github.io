import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:flutter_library/@model/model_union.dart';
import '../../item/button/exist_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../item/table/default_table.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late final double _textInputWidth;
  late TextEditingController _textControllerCardNo;
  late Timer _timerDelay;
  late Timer _timerSync;
  late final String _textWelcome;
  late final String _textExist;
  late final String _textHintMemberNum;
  late String _inputCardNo;
  late String _textCurrentTime;
  late String _textCenterName;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityConvert _utilityConvert;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  void _syncTimer(FosTableOrder app) {
    final initialDelay = Duration(seconds: 60 - DateTime.now().second);

    void updateTime() {
      if (app.mounted) {
        app.setState(() {
          app.local.param._textCurrentTime = _formatCurrentTime(app);
        });
      }
    }

    updateTime();
    app.local.param._timerDelay = Timer(initialDelay, () {
      updateTime();
      app.local.param._timerSync = Timer.periodic(
        const Duration(minutes: 1),
        (_) => updateTime(),
      );
    });
  }

  String _formatCurrentTime(FosTableOrder app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    String dateFormatted = utility._utilityConvert.toCustomizedDate(
      CoreStatic.coreVar.locale,
    );
    String timeFormatted = utility._utilityConvert.toCustomizedTime(
      CoreStatic.coreVar.locale,
    );

    return '$dateFormatted\t$timeFormatted';
  }

  ModelUi _uiTable(FosTableOrder app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final Map<String, List<String>> data = {
      'ID': List.generate(25, (index) => (index + 1).toString()),
      'Name': List.generate(25, (index) => 'Name $index'),
      'LastName': List.generate(25, (index) => 'LastName $index'),
      'Age': List.generate(25, (index) => (18 + index).toString()),
      'ID2': List.generate(25, (index) => (index + 1).toString()),
      'Name2': List.generate(25, (index) => 'Name2 $index'),
      'LastName2': List.generate(25, (index) => 'LastName2 $index'),
      'Age2': List.generate(25, (index) => (18 + index).toString()),
    };
    /*
    [
      ["col1", "col2", "col3"],
      ["row1", "row2", "row3"],
      ["row1", "row2", "row3"]
    ]
    */
    return ModelUi(data: CoreStatic.coreJoint.data(data));
  }

  List<Widget> _layout(FosTableOrder app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final mainItem = [
      Flex(
        direction: CoreStatic.coreVar.device == CoreEnumDevice.mobile
            ? Axis.vertical
            : Axis.horizontal,
        children: [
          SizedBox(
            height: eachHeight,
            width: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                ? maxHeight
                : maxWidth / 2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                param._textCenterName,
                style: TextStyle(fontSize: eachHeight / 3),
              ),
            ),
          ),
          Container(
            height: eachHeight * 2,
            width: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                ? maxHeight
                : maxWidth / 2,
            padding: EdgeInsets.only(left: size.xs, right: size.xs),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  param._textCurrentTime,
                  style: TextStyle(fontSize: eachHeight / 3),
                ),
                TextField(
                  controller: param._textControllerCardNo,
                  decoration: InputDecoration(
                    labelText: param._textHintMemberNum,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    app.setState(() {
                      param._inputCardNo = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      Container(
        height: eachHeight,
        width: maxWidth,
        padding: EdgeInsets.only(left: size.xs, right: size.xs),
        child: Center(
          child: Text(
            param._textWelcome,
            style: TextStyle(fontSize: eachHeight / 3),
          ),
        ),
      ),
      Container(
        height: eachHeight * 4,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: Center(child: DefaultTable(ui: func._uiTable(app))),
      ),
      Container(
        height: eachHeight,
        width: maxWidth / 2,
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          border: utility._utilityWidget.border().border,
        ),
        padding: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? null
            : EdgeInsets.only(left: size.m),
        child: Align(
          alignment: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
              ? Alignment.center
              : Alignment.centerLeft,
          child: ExistButton(
            app: app,
            ui: ModelUi(data: CoreStatic.coreUnion.data(param._textExist)),
          ),
        ),
      ),
    ];
    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItem),
    ];
  }
}

class FosTableOrder
    extends
        ModelApp<
          Pager<FosTableOrder>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    await local.utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];
    setState(() {
      local.param
        .._textInputWidth = 400
        .._timerSync = Timer(Duration(), () {})
        .._textCenterName = "成吉思汗 - DECC"
        .._textControllerCardNo = TextEditingController()
        .._textHintMemberNum = localeRouteJson["member_num"]
        .._textExist = localeJson["exist"]
        .._textWelcome = localeRouteJson["welcome"]
            .toString()
            .replaceAll("{user.name}", "唐太宗")
            .replaceAll("{user.id}", "AMC999999");
    });
    local.func._syncTimer(this);
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
    local.param._timerDelay.cancel();
    local.param._timerSync.cancel();
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
