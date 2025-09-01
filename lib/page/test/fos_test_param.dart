import 'package:flutter/material.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';
import '../../item/layout/overlay_layout.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {}

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
  List<Widget> _layout(FosTestParam app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    String _testParam =
        "device ---> ${CoreStatic.coreVar.device}\norientation ---> ${CoreStatic.coreVar.orientation}\nmaxHeight ---> ${maxHeight}\nmaxWidth ---> ${maxWidth}";

    List<Widget> mainItem = [
      Container(
        height: maxHeight,
        width: maxWidth,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(child: Text(_testParam)),
      ),
    ];

    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItem),
    ];
  }
}

class FosTestParam
    extends
        ModelApp<
          Pager<FosTestParam>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    await local.utility._utilityActivity.init(this);
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
