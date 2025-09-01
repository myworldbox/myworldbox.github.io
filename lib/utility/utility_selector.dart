import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/core_record.dart';
import '../../model/model_app.dart';
import 'package:flutter_library/@core/core_enum.dart';

import '../core/core_static.dart';

class UtilitySelector {
  String getTime() {
    DateTime currentTime = DateTime.now();

    // Extract date and time components
    int year = currentTime.year;
    int month = currentTime.month;
    int day = currentTime.day;
    int hours = currentTime.hour;
    int minutes = currentTime.minute;
    int seconds = currentTime.second;

    String formattedDateTime =
        '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} '
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedDateTime;
  }

  (double, double, double) getAdjustedSize(ModelApp app) {
    final core = getCore(app);

    log(
      "getAdjustedSize: h->${CoreStatic.coreVar.size.height}, w->${CoreStatic.coreVar.size.width}, ${CoreStatic.coreVar.section}",
      name: "UtilitySelector",
    );

    return (
      CoreStatic.coreVar.size.height,
      CoreStatic.coreVar.size.width,
      CoreStatic.coreVar.size.height / CoreStatic.coreVar.section,
    );
  }

  CoreRecordCore getCore(ModelApp app) => (
    coreVar: CoreStatic.coreVar,
    coreConst: CoreStatic.coreConst,
    coreUnion: CoreStatic.coreUnion,
    coreJoint: CoreStatic.coreJoint,
    coreUnfold: CoreStatic.coreUnfold,
  );

  CoreRecordSize getSize(ModelApp app) => (
    xxxxs: CoreStatic.coreConst.size[CoreEnumSize.xxxxs]!,
    xxxs: CoreStatic.coreConst.size[CoreEnumSize.xxxs]!,
    xxs: CoreStatic.coreConst.size[CoreEnumSize.xxs]!,
    xs: CoreStatic.coreConst.size[CoreEnumSize.xs]!,
    s: CoreStatic.coreConst.size[CoreEnumSize.s]!,
    m: CoreStatic.coreConst.size[CoreEnumSize.m]!,
    l: CoreStatic.coreConst.size[CoreEnumSize.l]!,
    xl: CoreStatic.coreConst.size[CoreEnumSize.xl]!,
    xxl: CoreStatic.coreConst.size[CoreEnumSize.xxl]!,
    xxxl: CoreStatic.coreConst.size[CoreEnumSize.xxxl]!,
    xxxxl: CoreStatic.coreConst.size[CoreEnumSize.xxxxl]!,
  );

  ThemeData getThemeData(CoreEnumTheme theme) {
    final color = CoreStatic.coreConst.color;
    return ThemeData(
      colorScheme: ColorScheme(
        brightness:
            theme == CoreEnumTheme.light || theme == CoreEnumTheme.highContrast
            ? Brightness.light
            : Brightness.dark,
        primary: color[(theme, CoreEnumColorRole.primary)]!,
        onPrimary: color[(theme, CoreEnumColorRole.onPrimary)]!,
        primaryContainer: color[(theme, CoreEnumColorRole.primaryContainer)]!,
        onPrimaryContainer:
            color[(theme, CoreEnumColorRole.onPrimaryContainer)]!,
        secondary: color[(theme, CoreEnumColorRole.secondary)]!,
        onSecondary: color[(theme, CoreEnumColorRole.onSecondary)]!,
        secondaryContainer:
            color[(theme, CoreEnumColorRole.secondaryContainer)]!,
        onSecondaryContainer:
            color[(theme, CoreEnumColorRole.onSecondaryContainer)]!,
        tertiary: color[(theme, CoreEnumColorRole.tertiary)]!,
        onTertiary: color[(theme, CoreEnumColorRole.onTertiary)]!,
        tertiaryContainer: color[(theme, CoreEnumColorRole.tertiaryContainer)]!,
        onTertiaryContainer:
            color[(theme, CoreEnumColorRole.onTertiaryContainer)]!,
        error: color[(theme, CoreEnumColorRole.error)]!,
        onError: color[(theme, CoreEnumColorRole.onError)]!,
        errorContainer: color[(theme, CoreEnumColorRole.errorContainer)]!,
        onErrorContainer: color[(theme, CoreEnumColorRole.onErrorContainer)]!,
        surface: color[(theme, CoreEnumColorRole.surface)]!,
        onSurface: color[(theme, CoreEnumColorRole.onSurface)]!,
        surfaceContainerLowest:
            color[(theme, CoreEnumColorRole.surfaceContainerLowest)]!,
        surfaceContainerLow:
            color[(theme, CoreEnumColorRole.surfaceContainerLow)]!,
        surfaceContainer: color[(theme, CoreEnumColorRole.surfaceContainer)]!,
        surfaceContainerHigh:
            color[(theme, CoreEnumColorRole.surfaceContainerHigh)]!,
        surfaceContainerHighest:
            color[(theme, CoreEnumColorRole.surfaceContainerHighest)]!,
        onSurfaceVariant: color[(theme, CoreEnumColorRole.onSurfaceVariant)]!,
        outline: color[(theme, CoreEnumColorRole.outline)]!,
        outlineVariant: color[(theme, CoreEnumColorRole.outlineVariant)]!,
        inverseSurface: color[(theme, CoreEnumColorRole.inverseSurface)]!,
        onInverseSurface: color[(theme, CoreEnumColorRole.onInverseSurface)]!,
        inversePrimary: color[(theme, CoreEnumColorRole.inversePrimary)]!,
        surfaceTint: color[(theme, CoreEnumColorRole.surfaceTint)]!,
        scrim: color[(theme, CoreEnumColorRole.scrim)]!,
      ),
      useMaterial3: true,
    );
  }

  getLocal(ModelApp app) =>
      (app.local.param, app.local.utility, app.local.func);

  CoreEnumDevice getCoreEnumDevice(ModelApp app) {
    // Get current view (logical pixels)
    final dispatcher = PlatformDispatcher.instance;
    final view = dispatcher.views.isNotEmpty
        ? dispatcher.views.first
        : (dispatcher.implicitView ?? dispatcher.views.first);
    final logicalSize = view.physicalSize / view.devicePixelRatio;

    double w = logicalSize.width;
    double h = logicalSize.height;

    // If your app tracks a desired orientation, only swap when mismatched.
    // This prevents double-flips and ensures w/h match the intended orientation.
    final coreVar = CoreStatic.coreVar; // adapt to your state holder if needed
    switch (coreVar.orientation) {
      case CoreEnumOrientation.portrait:
        if (w > h) {
          final t = w;
          w = h;
          h = t;
        }
        break;
      case CoreEnumOrientation.landscape:
        if (h > w) {
          final t = w;
          w = h;
          h = t;
        }
        break;
    }

    // Classify using the shortest side — robust across rotations.
    final shortest = w < h ? w : h;
    final longest = w > h ? w : h;

    // Breakpoints (logical px). Tweak to fit your product:
    // - desktop: large layouts, multi-pane (>=800 on short side, ensure decent height)
    // - tablet: medium layouts (>=600 short side)
    // - mobile: phones (>=360 short side, and >=400 long side to avoid tiny windows)
    // - watch: anything smaller
    if (shortest >= 800 && longest >= 600) {
      return CoreEnumDevice.desktop;
    } else if (shortest >= 600) {
      return CoreEnumDevice.tablet;
    } else if (shortest >= 360 && longest >= 400) {
      return CoreEnumDevice.mobile;
    } else {
      return CoreEnumDevice.watch;
    }
  }

  bool changeSize() {
    if (CoreStatic.coreVar.device == CoreEnumDevice.mobile ||
        CoreStatic.coreVar.device == CoreEnumDevice.tablet ||
        (CoreStatic.coreVar.device == CoreEnumDevice.desktop &&
            CoreStatic.coreVar.orientation == CoreEnumOrientation.portrait)) {
      return true;
    } else {
      return false;
    }
  }
}
