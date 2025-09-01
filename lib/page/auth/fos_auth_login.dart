import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../core/core_generic.dart';
import '../../item/button/exist_button.dart';
import '../../item/button/normal_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

// Removed: import 'package:universal_html/html.dart' as html;
// Removed: import 'dart:ui_web' as ui_web;
// Removed: import 'dart:js_interop';
// Removed: @JS('jsQR') and external _jsQR function

class CurrentParam {
  late Map<CoreEnumWidget, Widget> item;
  late final int _canvasHeight;
  late final int _canvasWidth;
  late final String _textCameraScan;
  late final String _textSystemLogin;
  late final String _textScanCard;
  late final String _textExist;
  late String _textCurrentTime;
  late final Timer _timerDelay;
  Timer? _timerSync;

  QRViewController? _scannerController;
  late String _textScanCode, _textMemberCode;
  bool _isScanning = false;
  Uint8List? _barcode;
  final qrKey = GlobalKey(debugLabel: 'QR');
  // Removed: html.MediaStream? _webStream;
  // Removed: html.VideoElement? _webVideo;
  // Removed: html.CanvasElement? _webCanvas;
  // Removed: html.CanvasRenderingContext2D? _webCanvasContext;
  Timer? _scanTimer;
  DateTime? _lastScanTime;
  String? _lastScannedCode;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityConvert _utilityConvert;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  void _syncTimer(FosAuthLogin app) {
    final initialDelay = Duration(seconds: 60 - DateTime.now().second);

    void updateTime() {
      if (app.mounted) {
        app.setState(() {
          app.local.param._textCurrentTime = _formatCurrentTime(app);
        });
      }
    }

    updateTime();
    app.local.param._timerDelay = Timer(initialDelay, () {
      updateTime();
      app.local.param._timerSync = Timer.periodic(
        const Duration(minutes: 1),
        (_) => updateTime(),
      );
    });
  }

  String _formatCurrentTime(FosAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final size = selector.getSize(app);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    String dateFormatted = utility._utilityConvert.toCustomizedDate(
      CoreStatic.coreVar.locale,
    );
    String timeFormatted = utility._utilityConvert.toCustomizedTime(
      CoreStatic.coreVar.locale,
    );

    return '$dateFormatted\n$timeFormatted';
  }

  void _stopCamera(FosAuthLogin app) {
    app.local.param
      .._scanTimer?.cancel()
      .._scanTimer = null;
  }

  void _disposeCamera(FosAuthLogin app) {
    app.local.param
      .._scanTimer?.cancel()
      .._scannerController = null
      .._scanTimer = null;
  }

  void _handleScan(FosAuthLogin app, String? code) {
    if (code == null || code.isEmpty || app.local.param._isScanning) return;
    if (!_isValidCode(code)) return;

    final now = DateTime.now();
    if (app.local.param._lastScannedCode == code &&
        app.local.param._lastScanTime != null &&
        now.difference(app.local.param._lastScanTime!) <
            const Duration(seconds: 2))
      return;

    if (app.mounted) {
      app.setState(() {
        app.local.param
          .._barcode = Uint8List.fromList(code.codeUnits)
          .._isScanning = true
          .._lastScannedCode = code
          .._lastScanTime = now;
      });
      _showAlert(app);
      Timer(
        const Duration(seconds: 2),
        () => app.setState(() => app.local.param._isScanning = false),
      );
    }
  }

  Future<void> _showCameraPreviewDialog(FosAuthLogin app) async {
    final selector = app.local.utility._utilitySelector;

    final size = selector.getSize(app);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    try {
      await showDialog(
        context: app.context, // Ensure app.context is the correct BuildContext
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Camera Preview'),
          content: SizedBox(
            width: param._canvasWidth.toDouble(),
            height: param._canvasHeight.toDouble(),
            child: QRView(
              key: param.qrKey,
              onQRViewCreated: (controller) {
                app.setState(() {
                  param._scannerController = controller;
                  param._isScanning = true;
                });
                controller.scannedDataStream.listen((scanData) {
                  func._handleScan(app, scanData.code);
                });
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                func._stopCamera(app);
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ).then((_) => func._stopCamera(app));
      param._scannerController?.resumeCamera();
    } catch (e) {
      log('Camera error: $e');
    }
  }

  // Removed: _startWebScan method (no longer needed)

  bool _isValidCode(String code) => code.length >= 2;

  void _showAlert(FosAuthLogin app) => showDialog(
    context: app.context,
    builder: (ctx) => AlertDialog(
      title: const Text('Code Detected'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Would you like to proceed?'),
          const SizedBox(height: 16),
          Text(
            'Code: ${app.local.utility._utilityConvert.uint8ListToSha1(app.local.param._barcode!)}',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _stopCamera(app);
            Navigator.popUntil(
              app.context,
              (route) => route.settings.name == null,
            );
            Navigator.pushNamed(
              app.context,
              CoreEnumRoute.menuLogin.toString(),
            );
          },
          child: const Text('Proceed'),
        ),
      ],
    ),
  );

  Map<CoreEnumWidget, Widget> createItem(FosAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return {
      CoreEnumWidget.imageLogo: utility._utilityWidget.widgetSectionLogo(app),
      CoreEnumWidget.textTopic: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: param._textSystemLogin,
                style: TextStyle(
                  fontSize: eachHeight / 2.5,
                  color: Colors.white,
                ),
              ),
              WidgetSpan(child: SizedBox(width: size.xxs)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: IconButton(
                  tooltip: "Speak The Text",
                  icon: Icon(Icons.volume_down_alt, size: eachHeight / 2.5),
                  color: Colors.greenAccent,
                  onPressed: () => utility._utilityCallback.speak(
                    app,
                    ModelUi(
                      data: "${param._textSystemLogin}${param._textScanCard}",
                    ),
                  ),
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Colors.greenAccent, width: 2.0),
                    ),
                  ),
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: param._textScanCard,
                style: TextStyle(
                  fontSize: eachHeight / 2.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      CoreEnumWidget.imageIntro: Image.network(
        CoreStatic.coreConst.url.image,
        fit: BoxFit.cover,
      ),
      CoreEnumWidget.textTime: Container(
        padding: EdgeInsets.all(size.xxxs),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(size.xxs),
        ),
        child: Text(
          param._textCurrentTime,
          style: TextStyle(fontSize: eachHeight / 4),
        ),
      ),
      CoreEnumWidget.buttonScanner: NormalButton(
        app: app,
        ui: ModelUi(
          callback: () {
            app.local.func._showCameraPreviewDialog(app);
          },
          iconData: Icons.arrow_forward,
          data: param._textCameraScan,
        ),
      ),
      CoreEnumWidget.buttonExist: ExistButton(
        app: app,
        ui: ModelUi(data: CoreStatic.coreUnion.data(param._textExist)),
      ),
    };
  }

  List<Widget> _layout(FosAuthLogin app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    param.item = func.createItem(app);

    List<Widget> mainItem = [
      SizedBox(
        height: eachHeight,
        width: maxWidth,
        child: param.item[CoreEnumWidget.imageLogo],
      ),
      Container(
        height: eachHeight * 0.15,
        width: maxWidth,
        padding: EdgeInsets.all(size.xxs),
      ),
      Container(
        height: eachHeight * 1.7,
        width: maxWidth,
        padding: EdgeInsets.all(size.xxs),
        decoration: BoxDecoration(
          color: Colors.black,
          border: utility._utilityWidget.border().border,
        ),
        child: param.item[CoreEnumWidget.textTopic],
      ),
      Container(
        height: eachHeight * 0.15,
        width: maxWidth,
        padding: EdgeInsets.all(size.xxs),
      ),
      Container(
        height: eachHeight * 3,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: param.item[CoreEnumWidget.imageIntro],
      ),
      Container(
        height: ((CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? eachHeight * 3
            : eachHeight),
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        padding: EdgeInsets.only(left: size.m, right: size.m),
        child: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: param.item[CoreEnumWidget.textTime],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: param.item[CoreEnumWidget.buttonScanner],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: param.item[CoreEnumWidget.textTime],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: param.item[CoreEnumWidget.buttonScanner],
                  ),
                ],
              ),
      ),
      Container(
        height: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? eachHeight * 1.5
            : eachHeight,
        width: maxWidth / 2,
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          border: utility._utilityWidget.border().border,
        ),
        padding: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? null
            : EdgeInsets.only(left: size.m),
        child: Align(
          alignment: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
              ? Alignment.center
              : Alignment.centerLeft,
          child: param.item[CoreEnumWidget.buttonExist],
        ),
      ),
    ];

    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItem),
    ];
  }
}

class FosAuthLogin
    extends
        ModelApp<
          Pager<FosAuthLogin>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

    final size = selector.getSize(this);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);
    utility._utilityActivity.init(this);

    final file = CoreStatic.coreVar.file!;
    final localeJson = file[(CoreEnumAsset.locale, CoreEnumFile.json)];
    final domainJson = file[(CoreEnumAsset.domain, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];
    setState(() {
      local.param
        .._canvasHeight = 480
        .._canvasWidth = 480
        .._isScanning = false
        .._textCameraScan = localeRouteJson["camera_scan"].toString()
        .._textScanCard = localeRouteJson["scan_card"].toString()
        .._textSystemLogin = localeRouteJson["system_login"].toString()
        .._textExist = localeJson["exist"].toString()
        .._textMemberCode = localeRouteJson["member_code"]
        .._textScanCode = localeRouteJson["scan_code"];
    });

    local.func._syncTimer(this);
  };

  @override
  get refresh => () async {
    await local.utility._utilityActivity.refresh(this);
  };

  @override
  get renew => () async {
    await local.utility._utilityActivity.renew(this);
  };

  @override
  get discard => () async {
    local.param._timerDelay.cancel();
    local.param._timerSync?.cancel();
    local.func._disposeCamera(this);
    local.param._scannerController?.dispose();
    await local.utility._utilityActivity.discard(this);
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
