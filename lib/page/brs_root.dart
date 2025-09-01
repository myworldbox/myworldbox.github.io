import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_template/utility/utility_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/core_enum.dart';
import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:camera/camera.dart';
import '../../core/core_generic.dart';
import '../core/core_static.dart';
import '../item/button/normal_button.dart';
import '../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../utility/utility_convert.dart';
import '../utility/utility_http.dart';

class CurrentParam {
  late String _textDailyBook;
  late String _textDisclaimer;
  late String _textSuggestBook;
  late String _textTakePhoto;
  late String _textCameraTopic;
  late bool _openDialog;

  late final double _canvasHeight;
  late final double _canvasWidth;
  late int _countdownSeconds;
  CameraController? _cameraController;
  late bool _takePhotoNow;
  Uint8List? _capturedImage;
  Timer? _countdownTimer;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityConvert _utilityConvert;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;
  final UtilityHttp _utilityHttp;
  final UtilityStorage _utilityStorage;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityConvert = UtilityConvert(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp(),
      _utilityStorage = UtilityStorage();
}

class CurrentFunc {
  Future<void> _sync(BrsRoot app) async {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    String? centerCode = utility._utilityStorage.read(CoreEnumStorage.centerCode);
    List<dynamic>? bookList = utility._utilityStorage.read(
      CoreEnumStorage.bookList,
    );

    if (centerCode == null) {
      Navigator.pushNamed(app.context, CoreEnumRoute.authLogin.toString());
    }

    if (centerCode != null && (bookList == null || bookList.isEmpty)) {
      final result = await utility._utilityHttp.GetBookList(
        centerCode.toString().padLeft(4, '0'),
      );
      await utility._utilityStorage.create(<CoreEnumStorage, dynamic>{
        CoreEnumStorage.bookList: result.bookList!,
      });
    }
  }

  List<Widget> _layout(BrsRoot app) {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    List<Widget> mainItem = [
      Container(
        height: eachHeight * 2,
        width: maxWidth,
        padding: EdgeInsets.all(size.m),
        alignment: Alignment.center,
        child: Text(
          param._textDailyBook,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.xxl,
            color: Colors.lightGreenAccent, // Inner white color
            shadows: utility._utilityWidget.widgetShadow(app),
          ),
        ),
      ),
      SizedBox(
        height: eachHeight * 4,
        width: maxWidth,
        child: Center(
          child: TextButton(
            onPressed: () async {
              await app.local.func._showCameraPreviewDialog(app);
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.s),
                ),
              ),
              padding: WidgetStateProperty.all(EdgeInsets.all(size.m)),
              backgroundColor: WidgetStateProperty.all(
                Colors.black.withAlpha(128),
              ),
              foregroundColor: WidgetStateProperty.all(Colors.greenAccent),
              side: WidgetStateProperty.all(
                const BorderSide(color: Colors.greenAccent, width: 2.0),
              ),
              textStyle: WidgetStateProperty.all(
                TextStyle(fontSize: size.xxxxl, fontWeight: FontWeight.bold),
              ),
              minimumSize: WidgetStateProperty.all(
                Size(maxWidth * 0.5, eachHeight * 4 * 0.5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: eachHeight),
                SizedBox(width: size.s),
                Text(param._textSuggestBook),
              ],
            ),
          ),
        ),
      ),
      Container(
        height: eachHeight * 2,
        width: maxWidth,
        padding: EdgeInsets.all(size.m),
        alignment: Alignment.center,
        child: Text(
          param._textDisclaimer,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: size.xxs,
            color: Colors.tealAccent, // Inner white color
            shadows: utility._utilityWidget.widgetShadow(app),
          ),
        ),
      ),
    ];
    return [
      utility._utilityWidget.widgetBackground(app),
      ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            color: Colors.black.withAlpha(0),
            child: ListView(children: mainItem),
          ),
        ),
      ),
      utility._utilityWidget.widgetCloseButton(app),
      Positioned(
        bottom: size.xxxs,
        left: size.xxxs,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              app.context,
              CoreEnumRoute.authLogin.toString(),
            );
          },
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
          child: const Icon(Icons.person),
        ),
      ),
    ];
  }

  _stopCamera(BrsRoot app) async {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    await param._cameraController?.dispose();

    app.setState(() {
      param
        .._countdownTimer?.cancel()
        .._countdownTimer = null
        .._countdownSeconds = 0
        .._cameraController = null
        .._takePhotoNow = false
        .._capturedImage = null;
    });
  }

  _startCountdown(
    BrsRoot app,
    StateSetter dialogSetState,
    BuildContext dialogContext,
  ) async {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    // Prevent multiple countdowns
    if (param._countdownTimer != null || param._takePhotoNow) return;

    param._takePhotoNow = true; // Lock the process
    param._countdownSeconds = 5;
    dialogSetState(() {});

    param._countdownTimer?.cancel();
    param._countdownTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      if (param._countdownSeconds - 1 > 0) {
        dialogSetState(() {
          param._countdownSeconds--;
        });
      } else {
        CoreStatic.coreVar.ok = false;
        timer.cancel();
        param._countdownTimer = null;
        try {
          if (param._cameraController != null &&
              param._cameraController!.value.isInitialized) {
            // Capture the image
            final XFile image = await param._cameraController!.takePicture();
            final imageByte = await image.readAsBytes();

            // Store captured image
            param._capturedImage = imageByte;

            // Dismiss dialogs
            Navigator.pop(app.context); // Close loading dialog
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext); // Close camera dialog
            }

            // Navigate immediately
            await Navigator.pushReplacementNamed(
              app.context,
              CoreEnumRoute.aiBook.toString(),
              arguments: <CoreEnumBrs, dynamic>{
                CoreEnumBrs.imageByte: imageByte,
              },
            );

            // Clean up camera resources
            await _stopCamera(app);
          }
        } catch (e) {
          log('Error capturing photo: $e');
          Navigator.pop(app.context); // Close loading dialog if open
          dialogSetState(() {
            param._countdownSeconds = 0;
            param._takePhotoNow = false;
          });
        }
      }
    });
  }

  Future<void> _showCameraPreviewDialog(BrsRoot app) async {
    final selector = app.local.utility._utilitySelector;
    final size = selector.getSize(app);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    app.setState(() {
      CoreStatic.coreVar.ok = false;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        log('No cameras available');
        Navigator.pop(app.context);
        return;
      }

      param._cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium, // Use medium resolution for faster capture
        enableAudio: false,
      );

      await param._cameraController!.initialize();

      await showDialog(
        context: app.context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child:
                        param._cameraController != null &&
                            param._cameraController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                param._cameraController!.value.aspectRatio,
                            child: param._capturedImage != null
                                ? Image.memory(
                                    param._capturedImage!,
                                    fit: BoxFit.cover,
                                    width: param._canvasWidth,
                                    height: param._canvasHeight,
                                  )
                                : CameraPreview(param._cameraController!),
                          )
                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: Text(
                                'Camera not initialized',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                  if (param._countdownSeconds > 0)
                    Positioned(
                      top: param._canvasHeight / 2,
                      left: 0,
                      right: 0,
                      child: Text(
                        '${param._countdownSeconds}',
                        style: TextStyle(
                          fontSize: size.xxl,
                          color: Colors.white, // Inner white color
                          shadows: utility._utilityWidget.widgetShadow(app),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Positioned(
                    bottom: size.s,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        param._capturedImage != null
                            ? NormalButton(
                                app: app,
                                ui: ModelUi(
                                  callback: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pushReplacementNamed(
                                      dialogContext,
                                      CoreEnumRoute.aiBook.toString(),
                                      arguments: <CoreEnumBrs, dynamic>{
                                        CoreEnumBrs.imageByte:
                                            param._capturedImage,
                                      },
                                    );
                                  },
                                  iconData: Icons.add_task,
                                  tooltip: param._textSuggestBook,
                                  data: param._textSuggestBook,
                                  backgroundColor: Colors.lightBlueAccent,
                                  textColor: Colors.black,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: param._countdownSeconds > 0
                                    ? null
                                    : () async => await _startCountdown(
                                        app,
                                        setState,
                                        dialogContext,
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: param._countdownSeconds > 0
                                      ? Colors.grey
                                      : Colors.greenAccent,
                                  foregroundColor: Colors.black,
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.s,
                                    vertical: size.xs,
                                  ),
                                ),
                                child: Text(
                                  param._textTakePhoto,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: eachHeight / 2.5,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: size.xxxs,
                    right: size.xxxs,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        padding: EdgeInsets.all(
                          size.xxxxs,
                        ), // Add padding for button-like feel
                        decoration: BoxDecoration(
                          color:
                              Colors.grey[200], // Light background for button
                          borderRadius: BorderRadius.circular(
                            size.xs,
                          ), // Rounded corners
                          border: Border.all(
                            color: Colors.black54,
                            width: 1,
                          ), // Subtle border
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: size.xxs,
                              offset: Offset(0, 2), // Slight shadow for depth
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: size.l,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).then((_) async => await func._stopCamera(app));
    } catch (e) {
      log('Camera error: $e');
      Navigator.pop(app.context);
    } finally {
      app.setState(() {
        CoreStatic.coreVar.ok = true;
      });
    }
  }
}

class BrsRoot
    extends
        ModelApp<Pager<BrsRoot>, CurrentParam, CurrentUtility, CurrentFunc> {
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

    final size = selector.getSize(this);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(this);

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    final Map<CoreEnumBrs, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments
            as Map<CoreEnumBrs, dynamic>?;

    await func._sync(this);

    setState(() {
      param
        .._canvasHeight = CoreStatic.coreVar.size.height * 0.9
        .._canvasWidth = CoreStatic.coreVar.size.width * 0.9
        .._openDialog = args?[CoreEnumBrs.openDialog] ?? false
        .._countdownSeconds = 0
        .._takePhotoNow = false
        .._capturedImage = null
        .._textDailyBook = localeRouteJson["daily_book"].toString()
        .._textDisclaimer = localeRouteJson["disclaimer"].toString()
        .._textCameraTopic = localeRouteJson["camera_topic"].toString()
        .._textSuggestBook = localeRouteJson["suggest_book"].toString()
        .._textTakePhoto = localeRouteJson["take_photo"].toString();
    });

    if (param._openDialog) {
      await func._showCameraPreviewDialog(this);
    }
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
    await local.utility._utilityActivity.discard(this);
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
