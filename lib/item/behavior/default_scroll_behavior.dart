import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class DefaultScrollBehavior extends ScrollBehavior {
  // Configure scroll physics for all platforms
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return const BouncingScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }

  // Enable dragging for both touch and mouse devices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  // Customize scrollbar appearance
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // Use more visible scrollbar on desktop platforms
    if (isDesktop(context)) {
      return Scrollbar(
        controller: details.controller,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 12.0,
        radius: const Radius.circular(10),
        child: child,
      );
    }
    return child;
  }

  // Helper methods
  bool isDesktop(BuildContext context) {
    final platform = getPlatform(context);
    return platform == TargetPlatform.linux ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows;
  }
}