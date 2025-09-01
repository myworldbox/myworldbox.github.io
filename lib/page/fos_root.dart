import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../core/core_static.dart';
import '../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late String _textStart;

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
  List<Widget> _layout(FosRoot app) {
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
        decoration: utility._utilityWidget.border(),
      ),
      Container(
        height: eachHeight * 4,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  app.context,
                  CoreEnumRoute.authLogin.toString(),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(
                  (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
                      ? size.m
                      : size.l,
                ), // Circular padding
                textStyle: TextStyle(fontSize: eachHeight / 2.5),
                side: const BorderSide(color: Colors.greenAccent, width: 2.0),
                shape: const CircleBorder(), // Makes the button circular
              ),
              child: Text(
                param._textStart, // Use param directly
                style: TextStyle(fontSize: eachHeight / 2.5),
              ),
            ),
            IconButton(
              icon: Icon(Icons.volume_down_alt, size: size.m),
              color: Colors.greenAccent,
              onPressed: () => utility._utilityCallback.speak(
                app,
                ModelUi(data: param._textStart),
              ),
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  const BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItem),
    ];
  }
}

class FosRoot
    extends
        ModelApp<Pager<FosRoot>, CurrentParam, CurrentUtility, CurrentFunc> {
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
    setState(() {
      param._textStart = localeRouteJson["start"].toString();
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
