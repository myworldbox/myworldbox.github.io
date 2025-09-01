import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_template/utility/utility_selector.dart';
import 'package:flutter_template/utility/utility_widget.dart';
import '../../core/core_mixin.dart';

import '../../core/core_struct.dart';
import '../core/core_static.dart';
import '../item/layout/default_layout.dart';

import 'model_ui.dart';

abstract class ModelApp<T extends StatefulWidget, A, B, C> extends State<T>
    with WidgetsBindingObserver, CoreMixin
    implements CoreStructSkeleton<A, B, C> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        if (mounted) {
          await renew();
          await init();
          await refresh();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    discard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        if (mounted) {
          await renew();
          await refresh();
        }
      });
    });
  }

  Widget build(BuildContext context) {
    final widget = UtilityWidget();
    bool ok = CoreStatic.coreVar.ok;

    return FutureBuilder<void>(
      future: Future.delayed(const Duration(milliseconds: 500)),
      builder: (context, snapshot) {
        return DefaultLayout(
            ui: ModelUi(
              dataList: ok ? ui : [widget.widgetLoading(this)],
            ),
          );
      },
    );
  }

  @override
  get init => () async {};

  @override
  get refresh => () async {};

  @override
  get renew => () async {};

  @override
  get discard => () async {};

  @override
  get ui => [];
}
