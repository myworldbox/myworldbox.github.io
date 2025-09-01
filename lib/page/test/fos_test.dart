import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late Widget _itemSplashImage;
  late int _count;
}

class CurrentUtility {
  final UtilityWidget _utilityWidget;
  final UtilityActivity _utilityActivity;

  CurrentUtility()
    : _utilityWidget = UtilityWidget(),
      _utilityActivity = UtilityActivity();
}

class CurrentFunc {
  Widget itemSplashImage(FosTest app) {
    return Text('Counter: ${app.local.param._count}');
  }
}

class FosTest
    extends
        ModelApp<Pager<FosTest>, CurrentParam, CurrentUtility, CurrentFunc> {
  @override
  get init => () async {
    await local.utility._utilityActivity.init(this);
    setState(() {
      local.param
        .._count = 0
        .._itemSplashImage = local.func.itemSplashImage(this);
    });
  };

  @override
  get refresh => () async {};

  @override
  get renew => () async {
    await local.utility._utilityActivity.renew(this);
  };

  @override
  get discard => () async {
    super.discard();
  };

  @override
  get ui => [
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
    local.param._itemSplashImage,
  ];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
