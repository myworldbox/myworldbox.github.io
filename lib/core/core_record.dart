import 'package:flutter/material.dart';
import '../../core/core_joint.dart';
import '../../core/core_var.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'core_const.dart';
import 'core_enum.dart';
import 'core_unfold.dart';
import 'core_union.dart';

typedef CoreRecordSizeId = (CoreEnumDevice, CoreEnumOrientation, CoreEnumSize);

typedef CoreRecordRoute = ({IconData icon, WidgetBuilder builder, bool enable});

typedef CoreRecordTex = ({String name, String tex});

typedef CoreRecordGraph = ({
  CoreEnumStep type,
  String from,
  String to /*String? hint*/,
});

typedef CoreRecordSize = ({
  double xxxxs,
  double xxxs,
  double xxs,
  double xs,
  double s,
  double m,
  double l,
  double xl,
  double xxl,
  double xxxl,
  double xxxxl,
});

typedef CoreRecordCore = ({
  CoreVar coreVar,
  CoreConst coreConst,
  CoreUnion coreUnion,
  CoreJoint coreJoint,
  CoreUnfold coreUnfold,
});

typedef CoreRecordRequest = ({
  Uri uri,
  Map<String, String> Function() headers,
  Map<String, dynamic> Function() body,
  Function callback,
});

typedef CoreRecordInput = ({
  IconData iconData,
  String pattern,
  String name,
  bool enable,
  String hint,
  List<({String displayText, String value})>? select,
  String? defaultValue,
  bool readOnly,
});
