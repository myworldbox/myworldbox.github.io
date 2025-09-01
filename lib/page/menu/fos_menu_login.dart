import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../../item/button/exist_button.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late final String _textWelcome;
  late final String _textQuestion;
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
  Widget _areaButtonGroup(FosMenuLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centers buttons horizontally
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              app.context,
              CoreEnumRoute.menuOrder.toString(),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(size.xxs), // Circular padding
            side: const BorderSide(color: Colors.greenAccent, width: 2.0),
            shape: const CircleBorder(), // Circular shape
          ),
          child: Icon(
            Icons.check, // Tick icon
            size: size.xxl,
          ),
        ),
        SizedBox(width: size.xxs), // Optional spacing between buttons
        ElevatedButton(
          onPressed: () {
            Navigator.pop(app.context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(size.xxs), // Circular padding
            side: const BorderSide(color: Colors.greenAccent, width: 2.0),
            shape: const CircleBorder(), // Circular shape
          ),
          child: Icon(
            Icons.close, // Cross icon
            size: size.xxl,
          ),
        ),
      ],
    );
  }

  Widget _areaWelcome(FosMenuLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Container(
      padding: EdgeInsets.all(size.xxs),
      constraints: BoxConstraints.tightFor(
        width: null,
      ), // Ensures width wraps content
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.xxs),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize:
            MainAxisSize.min, // Ensures Row takes only the space it needs
        children: [
          Icon(Icons.person, size: eachHeight, color: Colors.black),
          Text(
            param._textWelcome,
            style: TextStyle(fontSize: eachHeight / 2, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          IconButton(
            icon: Icon(Icons.volume_down_alt, size: eachHeight / 2),
            color: Colors.black,
            onPressed: () => utility._utilityCallback.speak(
              app,
              ModelUi(data: param._textWelcome),
            ),
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                const BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _layout(FosMenuLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    List<Widget> mainItem = [
      utility._utilityWidget.widgetSectionLogo(app),
      Container(
        height: eachHeight * 3,
        width: maxWidth,
        padding: EdgeInsets.all(size.xxs),
        decoration: BoxDecoration(
          border: utility._utilityWidget.border().border,
        ),
        child: Center(child: func._areaWelcome(app)),
      ),
      Container(
        height: eachHeight,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: Center(
          child: Text(
            param._textQuestion,
            style: TextStyle(fontSize: eachHeight / 2),
          ),
        ),
      ),
      Container(
        height: eachHeight * 2,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: Align(
          alignment: Alignment.center,
          child: func._areaButtonGroup(app),
        ),
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

class FosMenuLogin
    extends
        ModelApp<
          Pager<FosMenuLogin>,
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
        .._textExist = localeJson["exist"]
        .._textWelcome = localeRouteJson["welcome"].toString().replaceAll(
          "{user.name}",
          "唐太宗",
        )
        .._textQuestion = localeRouteJson["question"];
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
