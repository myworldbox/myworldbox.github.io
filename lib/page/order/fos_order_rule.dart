import 'dart:async';
import 'dart:developer';
import 'package:flutter_html/flutter_html.dart';
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
import '../../item/button/audible_button.dart';
import '../../item/button/exist_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class CurrentParam {
  late final String _htmlOrderRule;
  late final String _textStartOrder;
  late final String _textOrder;
  late final String _textRule;
  late final String _textExist;

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
  Widget _areaRule(FosOrderRule app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return Center(
      child: Container(
        height: eachHeight * 4,
        width: CoreStatic.coreVar.device == CoreEnumDevice.mobile
            ? maxWidth * 0.9
            : maxWidth / 2,
        padding: EdgeInsets.all(size.xxs),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.xs),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make the column wrap its content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.volume_down_alt, size: eachHeight / 2),
                color: Colors.black,
                onPressed: () async {
                  utility._utilityCallback.speak(
                    app,
                    ModelUi(data: param._textRule),
                  );
                },
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
            ),
            Html(data: app.local.param._htmlOrderRule),
          ],
        ),
      ),
    );
  }

  List<Widget> _layout(FosOrderRule app) {
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
        decoration: utility._utilityWidget.border(),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                param._textOrder,
                style: TextStyle(fontSize: eachHeight / 2),
              ),
              SizedBox(width: size.xxs),
              IconButton(
                icon: Icon(Icons.volume_down_alt, size: eachHeight / 2),
                color: Colors.white,
                onPressed: () async {
                  utility._utilityCallback.speak(
                    app,
                    ModelUi(data: param._textOrder),
                  );
                },
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: eachHeight * 4,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: func._areaRule(app),
      ),
      Container(
        height: eachHeight,
        width: maxWidth,
        decoration: BoxDecoration(
          border: utility._utilityWidget.border().border,
        ),
        child: Center(
          child: AudibleButton(
            app: app,
            ui: ModelUi(
              callback: () {
                Navigator.pushNamed(
                  app.context,
                  CoreEnumRoute.menuFood.toString(),
                );
              },
              iconData: Icons.shop,
              data: param._textStartOrder,
            ),
          ),
        ),
      ),
      Container(
        height: eachHeight,
        width: maxWidth / 2,
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

class FosOrderRule
    extends
        ModelApp<
          Pager<FosOrderRule>,
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

    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(this);

    await local.utility._utilityActivity.init(this);
    final htmlOrderRule =
        CoreStatic.coreVar.file![(CoreEnumAsset.orderRule, CoreEnumFile.html)];
    final mdOrderRule =
        CoreStatic.coreVar.file![(CoreEnumAsset.orderRule, CoreEnumFile.md)];
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    dom.Document document = html_parser.parse(htmlOrderRule);
    document.querySelectorAll('p').forEach((element) {
      element.attributes['style'] =
          "font-size: ${eachHeight * 3 / 5 / 2}px; color: black";
    });

    log("---> message ${document.outerHtml}");

    setState(() {
      local.param
        .._textOrder = localeRouteJson["order"].toString()
        .._textStartOrder = localeRouteJson["start_order"].toString()
        .._htmlOrderRule = document.outerHtml
        .._textRule = local.utility._utilityConvert.htmlToText(
          document.outerHtml,
        )
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
