import 'package:flutter/material.dart';
import '../../model/model_local.dart';

abstract interface class CoreStructSkeleton<A, B, C> {
  List<Widget> get ui;
  Future<void> Function() get init;
  Future<void> Function() get refresh;
  Future<void> Function() get renew;
  Future<void> Function() get discard;
  ModelLocal<A, B, C> get local;
}
