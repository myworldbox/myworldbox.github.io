import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_template/core/core_const.dart';
import 'package:flutter_template/utility/utility_audio.dart';
import 'package:flutter_template/utility/utility_http.dart';
import 'package:flutter_template/utility/utility_storage.dart';
import '../../core/core_enum.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/model_app.dart';
import 'package:flutter_library/@core/core_enum.dart';

import '../core/core_record.dart';
import '../core/core_static.dart';

class UtilityActivity {
  final UtilityAudio _utilityAudio;
  final UtilityReader _utilityReader;
  final UtilityConvert _utilityConvert;
  final UtilitySelector _utilitySelector;
  final UtilityHttp _utilityHttp;
  final UtilityStorage _utilityStorage;

  UtilityActivity()
    : _utilityAudio = UtilityAudio(),
      _utilityReader = UtilityReader(),
      _utilityConvert = UtilityConvert(),
      _utilitySelector = UtilitySelector(),
      _utilityHttp = UtilityHttp(),
      _utilityStorage = UtilityStorage();

  Future<void> once() async {
    switch (CoreStatic.coreVar.project) {
      case CoreEnumProject.brs:
        List<dynamic>? bookPreferenceList = _utilityStorage.read(
          CoreEnumStorage.bookPreferenceList,
        );
        if (bookPreferenceList != null) {
          await _utilityHttp.UploadBookPerference(bookPreferenceList);
          await _utilityStorage.delete(<CoreEnumStorage>[
            CoreEnumStorage.bookPreferenceList,
          ]);
        }

        // await _utilityAudio.start('mp3/Keys Of Moon - Blooming Melody.mp3');
        break;
      case CoreEnumProject.fos:
        // await _utilityAudio.start('mp3/Keys Of Moon - Enchanted.mp3');
        break;
      case CoreEnumProject.mwb:
        // await _utilityAudio.start('mp3/Keys Of Moon - Yugen.mp3');
        break;
    }
  }

  Future<void> init(ModelApp app) async {
    final lang = CoreStatic.coreVar.locale.value;
    final projectName = CoreStatic.coreVar.project.name;

    final sharedPrefs = null;

    Map<CoreEnumInput, CoreRecordInput>? inputExtend;

    Map<(CoreEnumAsset, CoreEnumFile), dynamic> file;

    for (var asset in [
      CoreStatic.coreConst.asset.background,
      CoreStatic.coreConst.asset.faceScanGif,
      CoreStatic.coreConst.asset.bookFoldGif,
    ]) {
      precacheImage(AssetImage(asset), app.context);
    }

    final (locale) = await _utilityReader.readFile(
      'assets/json/${projectName}_locale_${_utilityConvert.toLocaleAlias(lang)}.json',
    );

    switch (CoreStatic.coreVar.project) {
      case CoreEnumProject.mwb:
        final (
          List<dynamic> domain,
          List<dynamic> phoneNumber,
          List<dynamic> motto,
        ) = await (
          _utilityReader.readFile('assets/json/domain.json'),
          _utilityReader.readFile('assets/json/phone_number.json'),
          _utilityReader.readFile('assets/json/motto.json'),
        ).wait;

        file = {
          (CoreEnumAsset.domain, CoreEnumFile.json): domain,
          (CoreEnumAsset.phoneNumber, CoreEnumFile.json): phoneNumber,
          (CoreEnumAsset.motto, CoreEnumFile.json): motto,
        };

        final universityExtensionArm = _utilityConvert.stringToSnakeCase(
          CoreEnumDomain.universityExtensionArm.name,
        );
        final String countryCode = _utilityConvert.stringToSnakeCase(
          CoreEnumInput.countryCode.name,
        );

        final domainList =
            domain
                .where(
                  (item) =>
                      item[CoreEnumInput.domain.name] != null &&
                      (item[CoreEnumInput.type.name] ==
                              universityExtensionArm ||
                          item[CoreEnumInput.type.name] ==
                              CoreEnumDomain.university.name),
                )
                .expand(
                  (item) => (item[CoreEnumInput.domain.name] as List<dynamic>)
                      .cast<String>(),
                )
                .toSet()
                .toList()
              ..sort();

        final List<({String displayText, String value})> domainFinalList =
            domainList.map((x) => (displayText: x, value: x)).toList();

        final List<({String displayText, String value})> phoneNumberList =
            phoneNumber
                .where((item) => item[countryCode] != null)
                .map(
                  (x) => (
                    displayText: x[countryCode] as String,
                    value: x[countryCode] as String,
                  ),
                )
                .toSet()
                .toList()
              ..sort((a, b) => a.value.compareTo(b.value));

        final index = Random().nextInt(domainList.length);

        inputExtend = {
          CoreEnumInput.mailSchool: (
            name: 'School Mail',
            hint: 'e.g. user@${domainFinalList[index].value}',
            pattern:
                '^([a-zA-Z0-9._%+-]+)@(${domainFinalList.map((x) => RegExp.escape(x.value)).join('|')})\$',
            iconData: Icons.school,
            enable: true,
            readOnly: false,
            select: domainFinalList,
            defaultValue: null,
          ),
          CoreEnumInput.countryCode: (
            name: 'Country Code',
            hint: 'e.g. ${phoneNumberList.first.value}',
            pattern:
                '(${phoneNumberList.map((x) => RegExp.escape(x.value)).join('|')})\$',
            iconData: Icons.school,
            enable: true,
            readOnly: false,
            select: phoneNumberList,
            defaultValue: null,
          ),
        };

        break;
      case CoreEnumProject.fos:
        final (mdOrderRule, htmlOrderRule) = await (
          _utilityReader.readFile('assets/md/${projectName}_order_rule.md'),
          _utilityReader.readFile('assets/html/${projectName}_order_rule.html'),
        ).wait;

        file = {
          (CoreEnumAsset.orderRule, CoreEnumFile.md): mdOrderRule,
          (CoreEnumAsset.orderRule, CoreEnumFile.html): htmlOrderRule,
        };

        /*
        final flutterTts = FlutterTts();
        await flutterTts.stop();
        await flutterTts.setLanguage(lang);
        await flutterTts.setPitch(1.0);
        await flutterTts.setVolume(1.0);
        await flutterTts.awaitSpeakCompletion(true);

        app.setState(() {
          CoreStatic.coreVar.flutterTts = flutterTts;
        });
        */

        break;
      case CoreEnumProject.brs:
        final (gifFaceScan, gifBookFold) = await (
          _utilityReader.readFile(CoreStatic.coreConst.asset.faceScanGif),
          _utilityReader.readFile(CoreStatic.coreConst.asset.bookFoldGif),
        ).wait;

        file = {
          (CoreEnumAsset.faceScan, CoreEnumFile.gif): gifFaceScan,
          (CoreEnumAsset.bookFold, CoreEnumFile.gif): gifBookFold,
        };

        break;
    }

    app.setState(() {
      CoreStatic.coreVar
        ..inputExtend = {...?inputExtend, ...CoreStatic.coreConst.inputAll}
        ..sharedPrefs = sharedPrefs
        ..googleFonts = GoogleFonts.aBeeZee()
        ..message = null
        ..file = {...file, (CoreEnumAsset.locale, CoreEnumFile.json): locale};
    });

    log("[init]: (${CoreStatic.coreVar.ok})");
  }

  Future<void> refresh(ModelApp app) async {
    final core = _utilitySelector.getCore(app);

    app.setState(() {
      CoreStatic.coreVar.ok = true;
    });

    log("[refresh]: (${CoreStatic.coreVar.ok})");
  }

  Future<void> discard(ModelApp app) async {
    final selector = _utilitySelector;

    log("[discard]: (${CoreStatic.coreVar.ok})");
  }

  Future<void> renew(ModelApp app) async {
    final selector = _utilitySelector;

    final context = app.context;
    final mediaQuery = MediaQuery.of(context);

    final orientation = mediaQuery.orientation == Orientation.landscape
        ? CoreEnumOrientation.landscape
        : CoreEnumOrientation.portrait;

    final route = ModalRoute.of(context)?.settings.name;

    app.setState(() {
      CoreStatic.coreVar
        ..context = app.context
        ..size = mediaQuery.size
        ..orientation = orientation
        ..device = _utilitySelector.getCoreEnumDevice(app)
        ..route = CoreEnumRoute.toCoreEnum(route!)!
        ..ok = false;
    });

    log(
      "[renew]: (${CoreStatic.coreVar.ok}) (${CoreStatic.coreVar.route}) ---> ${CoreStatic.coreVar.device} --- [w:${CoreStatic.coreVar.size.width},h:${CoreStatic.coreVar.size.height}] --- ${CoreStatic.coreVar.orientation}",
    );
  }

  void openLinkInNewTab(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
