import 'package:flutter/material.dart';

mixin CoreMixin {
  void runWithContext(Future<void> Function() action) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        await action();
      });
    });
  }
}
