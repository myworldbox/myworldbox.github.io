import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';
import '../../model/model_ui.dart';
import 'package:flutter_library/flutter_library.dart';
import '../../core/core_generic.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {
  late ModelUi _ui;
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

class CurrentFunc {}

class ScreenSplash
    extends
        ModelApp<
          Pager<ScreenSplash>,
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

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    await utility._utilityActivity.init(this);

    if (mounted) {
      final ModelUi args =
          ModalRoute.of(context)?.settings.arguments as ModelUi;

      setState(() {
        param._ui = args;
      });
      Timer(param._ui.duration!, () {
        Navigator.pushNamed(context, param._ui.redirectRoute!.toString());
      });
    }
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
  get ui => [];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
