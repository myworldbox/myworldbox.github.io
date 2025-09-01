import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/model_ui.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'core_enum.dart';
import 'core_record.dart';

class CoreVar {
  CoreEnumEnv env;
  CoreEnumProject project;
  CoreEnumLocale locale;
  CoreEnumTheme theme;
  CoreEnumRoute route;
  CoreEnumOrientation orientation;

  CoreEnumDevice? device;

  SharedPreferences? sharedPrefs;

  String? token;
  String? id;

  bool ok;
  String? message;
  int section;

  late Map<CoreEnumDisplay, bool> display;
  late Size size;
  late BuildContext context;
  late State state;

  Map<(CoreEnumAsset, CoreEnumFile), dynamic>? file;

  /*
  late List<CameraDescription> cameraDescriptionList;
  */
  late FlutterTts flutterTts;

  TextStyle? googleFonts;
  ModelUi? modelUi;
  Timer? timer;
  Function? function;
  List<Widget>? ui;
  Map<CoreEnumInput, CoreRecordInput>? inputExtend;

  Map<String, dynamic>? request;
  Map<String, dynamic>? response;

  Map<String, dynamic>? cache;

  CoreVar({
    this.env = CoreEnumEnv.dev,
    this.project = CoreEnumProject.mwb,
    this.locale = CoreEnumLocale.enUs,
    this.theme = CoreEnumTheme.highContrastDark,
    this.route = CoreEnumRoute.root,
    this.orientation = CoreEnumOrientation.landscape,
    this.size = const Size(0, 0),
    this.ok = false,
    this.section = 8,
  }) {
    switch (env) {
      case CoreEnumEnv.dev:
        display = {
          CoreEnumDisplay.appBar: true,
          CoreEnumDisplay.drawer: true,
          CoreEnumDisplay.floatingActionButton: true,
          CoreEnumDisplay.bottomNavigationBar: true,
        };
        break;
      default:
        display = {
          CoreEnumDisplay.appBar: false,
          CoreEnumDisplay.drawer: false,
          CoreEnumDisplay.floatingActionButton: false,
          CoreEnumDisplay.bottomNavigationBar: false,
        };
        break;
    }
  }
}
