import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/utility/utility_http.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {
  late final String _textBack;
  late final String _textComplete;

  late final Uint8List _imageByte;
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;
  final UtilityHttp _utilityHttp;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp();
}

class CurrentFunc {
  List<Widget> _layout(BrsAiBook app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    List<Widget> mainItem = [
      Container(
        width: maxWidth,
        height: maxHeight,
        child: Image.memory(param._imageByte, fit: BoxFit.cover),
      ),
      Positioned(
        bottom: size.m,
        child: Container(
          width: maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        app.context,
                        CoreEnumRoute.root.toString(),
                        arguments: {CoreEnumBrs.openDialog: true},
                      );
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    style: IconButton.styleFrom(
                      iconSize: eachHeight / 2.5,
                      backgroundColor: Colors.tealAccent,
                      padding: EdgeInsets.all(
                        size.xs,
                      ), // Adjust padding for button size
                    ),
                  ),
                  Text(
                    param._textBack, // e.g., "Back"
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: eachHeight / 2.5,
                      shadows: utility._utilityWidget.widgetShadow(app),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        app.context,
                        CoreEnumRoute.transitionScan.toString(),
                        arguments: {CoreEnumBrs.imageByte: param._imageByte},
                      );
                    },
                    icon: Icon(Icons.check, color: Colors.black),
                    style: IconButton.styleFrom(
                      iconSize: eachHeight / 2.5,
                      backgroundColor: Colors
                          .tealAccent, // Matching first button's color for consistency
                      padding: EdgeInsets.all(size.xs),
                    ),
                  ),
                  Text(
                    param._textComplete, // e.g., "Complete"
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: eachHeight / 2.5,
                      shadows: utility._utilityWidget.widgetShadow(app),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    return [
      utility._utilityWidget.widgetBackground(app),
      ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            color: Colors.black.withAlpha(64), // Add a dark overlay
            child: Stack(children: mainItem),
          ),
        ),
      ),
      utility._utilityWidget.widgetCloseButton(app),
    ];
  }
}

class BrsAiBook
    extends
        ModelApp<Pager<BrsAiBook>, CurrentParam, CurrentUtility, CurrentFunc> {
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

    final Map<CoreEnumBrs, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<CoreEnumBrs, dynamic>;

    final Uint8List? userByte = args?[CoreEnumBrs.imageByte];

    setState(() {
      param
        .._textBack = localeJson["back"]
        .._textComplete = localeJson["complete"]
        .._imageByte = userByte!;
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
