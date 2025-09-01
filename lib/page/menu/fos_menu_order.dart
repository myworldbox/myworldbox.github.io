import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';
import '../../item/button/audible_button.dart';
import '../../item/button/default_button.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import '../../item/button/exist_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late final String _textSelect;
  late final String _textOrder;
  late final String _textSummary;
  late final String _textExist;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  Widget _buttonGroup(FosMenuOrder app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(param._textSelect, style: TextStyle(fontSize: eachHeight / 2)),
        AudibleButton(
          app: app,
          ui: ModelUi(
            backgroundColor: Colors.white,
            callback: () {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.orderRule.toString(),
              );
            },
            iconData: Icons.shop,
            data: param._textOrder,
          ),
        ),
        AudibleButton(
          app: app,
          ui: ModelUi(
            backgroundColor: Colors.white,
            callback: () {
              Navigator.pushNamed(
                app.context,
                CoreEnumRoute.tableOrder.toString(),
              );
            },
            iconData: Icons.shop,
            data: param._textSummary,
          ),
        ),
      ],
    );
  }

  List<Widget> _layout(FosMenuOrder app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final mainItem = [
      utility._utilityWidget.widgetSectionLogo(app),
      Container(
        height: eachHeight * 3,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: Image.network(
          CoreStatic.coreConst.url.image,
          height: eachHeight * 3,
          width: maxWidth,
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: eachHeight * 3,
        width: maxWidth,
        decoration: BoxDecoration(
          border: utility._utilityWidget.border().border,
        ),
        child: func._buttonGroup(app),
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

class FosMenuOrder
    extends
        ModelApp<
          Pager<FosMenuOrder>,
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
        .._textSelect = localeRouteJson["select"]
        .._textOrder = localeRouteJson["order"]
        .._textSummary = localeRouteJson["summary"]
        .._textExist = localeJson["exist"];
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
