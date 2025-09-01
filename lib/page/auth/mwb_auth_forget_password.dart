import 'package:flutter/material.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {}

class CurrentUtility {
  final UtilityWidget _utilityWidget;
  final UtilityActivity _utilityActivity;

  CurrentUtility()
    : _utilityWidget = UtilityWidget(),
      _utilityActivity = UtilityActivity();
}

class CurrentFunc {}

class MwbAuthForgetPassword
    extends
        ModelApp<
          Pager<MwbAuthForgetPassword>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {};

  @override
  get refresh => () async {};

  @override
  get renew => () async {
    await local.utility._utilityActivity.renew(this);
  };

  @override
  get discard => () async {};

  @override
  get ui => [];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
