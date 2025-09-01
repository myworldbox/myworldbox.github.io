import 'package:flutter/material.dart';

class DefaultNavigationProvider extends InheritedWidget {
  const DefaultNavigationProvider({super.key, required super.child});

  static DefaultNavigationProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DefaultNavigationProvider>();
  }

  @override
  bool updateShouldNotify(DefaultNavigationProvider oldWidget) {
    return false;
  }
}
