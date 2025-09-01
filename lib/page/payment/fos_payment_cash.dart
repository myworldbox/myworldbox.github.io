import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';

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
  late final Timer _timer;
  late final String _textOrderIs;
  late final String _textCompleteOrder;
  late final String _textTakeTicket;
  late final String _textPayAtCashier;
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
  List<Widget> _layout(FosPaymentCash app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    List<Widget> mainItem = [
      utility._utilityWidget.widgetSectionLogo(app),
      Container(
        height: eachHeight,
        width: maxWidth,
        decoration: BoxDecoration(
          border: utility._utilityWidget.border().border, // Keep the border
        ), // No background color for outer Container (transparent)
        child: Container(
          width: maxWidth,
          height: eachHeight,
          decoration: BoxDecoration(
            color: Colors.black, // Black background only for text area
          ),
          child: Center(
            child: Text(
              param._textCompleteOrder, // First text
              style: TextStyle(fontSize: eachHeight / 2, color: Colors.white),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(size.xs),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth * 0.9,
            ), // Tight constraints for content
            child: Container(
              padding: EdgeInsets.all(size.xxs),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.xxs),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Shrink vertically
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(size.xxxs),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(size.xxxs),
                    ),
                    child: Text(
                      param._textOrderIs,
                      style: TextStyle(
                        fontSize: eachHeight / 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "XX12343253535",
                    style: TextStyle(
                      fontSize: eachHeight / 2,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/png/${CoreStatic.coreVar.project.name}_logo.png',
                    fit: BoxFit.contain,
                    width: eachHeight * 5, // Constrain image size
                  ),
                  Text(
                    "1 ${param._textTakeTicket}",
                    style: TextStyle(
                      fontSize: eachHeight / 2,
                      color: Colors.black,
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "2 ${param._textPayAtCashier}",
                        style: TextStyle(
                          fontSize: eachHeight / 2,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_down_alt, size: eachHeight / 2),
                        color: Colors.black,
                        onPressed: () => utility._utilityCallback.speak(
                          app,
                          ModelUi(
                            data:
                                "${param._textTakeTicket}${param._textPayAtCashier}",
                          ),
                        ),
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.black, width: 2.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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

class FosPaymentCash
    extends
        ModelApp<
          Pager<FosPaymentCash>,
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
        .._textOrderIs = localeRouteJson["order_is"].toString()
        .._textCompleteOrder = localeRouteJson["complete_order"].toString()
        .._textTakeTicket = localeRouteJson["take_ticket"].toString()
        .._textPayAtCashier = localeRouteJson["pay_at_cashier"].toString()
        .._textExist = localeJson["exist"].toString();
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
