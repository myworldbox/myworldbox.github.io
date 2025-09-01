import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import 'package:flutter_library/@model/model_union.dart';

import 'model_app.dart';

class ModelUi {
  final ModelApp? app;

  /// [String, Map, List]
  final dynamic data;
  final List<dynamic>? dataList;
  final Map<CoreEnumInput, TextEditingController>? controller;
  final VoidCallback? callback;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;
  final double? iconSize;
  final BorderSide? borderSide;
  final CoreEnumInput? input;
  final CoreEnumRoute? redirectRoute;
  final String? assetPath;
  final Duration? duration;
  final String? tooltip;

  ModelUi({
    this.app,
    this.data,
    this.dataList,
    this.callback,
    this.iconData,
    this.backgroundColor,
    this.textColor,
    this.textSize,
    this.iconSize,
    this.borderSide,
    this.input,
    this.controller,
    this.redirectRoute,
    this.assetPath,
    this.duration,
    this.tooltip,
  });
}
