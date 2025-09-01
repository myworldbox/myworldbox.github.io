import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/effect/effect_milky.dart';
import 'package:flutter_template/utility/utility_http.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';
import '../../effect/effect_galaxy.dart';
import '../../item/button/normal_button.dart';
import '../../item/layout/overlay_layout.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {
  late final int _totalDuration;
  String? _textScan;
  String? _textDailyBook;
  Uint8List _imageByte = Uint8List(0);
  Uint8List _faceScanByte = Uint8List(0);

  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<Offset>? _positionAnimation;
  Animation<double>? _rotationAnimation;
  Animation<double>? _opacityAnimation;
  Animation<double>? _bookScaleAnimation;
  Animation<double>? _bookShakeAnimation;
  Animation<Color?>? _glowColorAnimation;
  Animation<double>? _beamAnimation;
  Animation<double>? _flashAnimation;

  CurrentParam(); // Constructor for initialization
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;
  final UtilityHttp _utilityHttp;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp();
}

class CurrentFunc {
  List<Widget> _layout(BrsTransitionScan app) {
    final selector = app.local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    const aspectRatio = 9 / 16;
    final containerHeight = eachHeight * 6;
    final imageHeight = containerHeight * 0.95;
    final imageWidth = imageHeight * aspectRatio;
    final constrainedWidth = min(imageWidth, maxWidth);
    final constrainedHeight = min(
      imageHeight,
      maxHeight,
    ); // Ensure height is constrained

    List<Widget> mainItem = [
      if (param._textDailyBook != null)
        Container(
          height: eachHeight,
          width: maxWidth,
          alignment: Alignment.center,
          child: Text(
            param._textDailyBook!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: eachHeight / 2.5,
              color: Colors.lightGreenAccent,
              shadows: utility._utilityWidget.widgetShadow(app),
            ),
          ),
        ),
      SizedBox(height: eachHeight * 6, width: maxWidth),
      if (param._textScan != null)
        Container(
          height: eachHeight * 1,
          width: maxWidth,
          alignment: Alignment.center,
          child: Text(
            param._textScan!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: eachHeight / 2.5,
              color: Colors.lightGreenAccent,
              shadows: utility._utilityWidget.widgetShadow(app),
            ),
          ),
        ),
    ];

    return [
      SizedBox(height: maxHeight, width: maxWidth, child: EffectGalaxy()),
      Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.hardEdge,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: param._animationController!,
              builder: (context, child) {
                return Transform.scale(
                  scale: param._bookScaleAnimation?.value ?? 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              param._glowColorAnimation?.value ??
                              Colors.white.withAlpha(128),
                          blurRadius: 10, // Reduced by half from 20
                          spreadRadius: 2.5, // Reduced by half from 5
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      CoreStatic.coreConst.asset.bookFoldGif,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedBuilder(
                animation: param._animationController!,
                builder: (context, child) {
                  return Opacity(
                    opacity: param._opacityAnimation?.value ?? 1.0,
                    child: Transform.translate(
                      offset: Offset(
                        (param._positionAnimation?.value.dx ?? 0.0) *
                            constrainedWidth *
                            0.5, // Limit translation
                        (param._positionAnimation?.value.dy ?? 0.0) *
                            constrainedHeight *
                            0.5, // Limit translation
                      ),
                      child: Transform.rotate(
                        angle: param._rotationAnimation?.value ?? 0.0,
                        child: Transform.scale(
                          scale: param._scaleAnimation?.value ?? 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              image: param._imageByte.isNotEmpty
                                  ? DecorationImage(
                                      image: MemoryImage(param._imageByte),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withAlpha(128),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset.zero,
                                ),
                              ],
                            ),
                            // Fallback if imageByte is empty
                            child: param._imageByte.isEmpty
                                ? Center(child: Text('No Image'))
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          AnimatedBuilder(
            animation: param._animationController!,
            builder: (context, child) {
              return Container(
                color: Colors.white.withOpacity(
                  param._flashAnimation?.value ?? 0.0,
                ),
              );
            },
          ),
        ],
      ),
      Column(mainAxisSize: MainAxisSize.min, children: mainItem),
      utility._utilityWidget.widgetCloseButton(app),
    ];
  }
}

class BrsTransitionScan
    extends
        ModelApp<
          Pager<BrsTransitionScan>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        >
    with SingleTickerProviderStateMixin {
  BrsTransitionScan() : super();

  @override
  get init => () async {
    final selector = local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    final gifFaceScan =
        CoreStatic.coreVar.file![(CoreEnumAsset.faceScan, CoreEnumFile.gif)];
    final Map<CoreEnumBrs, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments
            as Map<CoreEnumBrs, dynamic>?;
    final Uint8List? userByte = args?[CoreEnumBrs.imageByte];
    final Uint8List faceScanByte = Uint8List.fromList(utf8.encode(gifFaceScan));

    // Initialize animations

    setState(() {
      param
        .._totalDuration = 10
        .._imageByte = userByte ?? Uint8List(0)
        .._faceScanByte = faceScanByte
        .._animationController
            ?.dispose() // Dispose previous controller if exists
        .._animationController = AnimationController(
          duration: Duration(
            seconds: param._totalDuration,
          ), // Total duration 8 seconds
          vsync: this,
        )
        .._scaleAnimation =
            TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween<double>(begin: 1.0, end: 0.5),
                weight: 33.33,
              ),
              TweenSequenceItem(
                tween: Tween<double>(begin: 0.5, end: 0.025),
                weight: 33.33,
              ),
              TweenSequenceItem(
                tween: ConstantTween<double>(0.025),
                weight: 33.33,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
              ),
            )
        .._positionAnimation =
            TweenSequence<Offset>([
              TweenSequenceItem(
                tween: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.2, -0.2),
                ),
                weight: 33.33,
              ),
              TweenSequenceItem(
                tween: Tween<Offset>(
                  begin: const Offset(0.2, -0.2),
                  end: Offset.zero,
                ),
                weight: 33.33,
              ),
              TweenSequenceItem(
                tween: ConstantTween<Offset>(Offset.zero),
                weight: 33.33,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
              ),
            )
        .._rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
          CurvedAnimation(
            parent: param._animationController!,
            curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
          ),
        )
        .._opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: param._animationController!,
            curve: const Interval(0.6, 0.7, curve: Curves.easeOut),
          ),
        )
        .._bookScaleAnimation =
            TweenSequence<double>([
              TweenSequenceItem(
                tween: ConstantTween<double>(1), // Start smaller
                weight: 75.0,
              ),
              TweenSequenceItem(
                tween: Tween<double>(begin: 1.4, end: 1.8), // Grow larger
                weight: 12.5,
              ),
              TweenSequenceItem(
                tween: Tween<double>(
                  begin: 1.8,
                  end: 2.2,
                ), // Hold at larger scale
                weight: 12.5,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
              ),
            )
        .._bookShakeAnimation =
            TweenSequence<double>([
              TweenSequenceItem(
                tween: ConstantTween<double>(0.0),
                weight: 75.0,
              ),
              TweenSequenceItem(
                tween: Tween<double>(begin: 0.0, end: 0.05),
                weight: 6.25,
              ),
              TweenSequenceItem(
                tween: Tween<double>(begin: 0.05, end: -0.05),
                weight: 6.25,
              ),
              TweenSequenceItem(
                tween: Tween<double>(begin: -0.05, end: 0.05),
                weight: 6.25,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
              ),
            )
        .._glowColorAnimation =
            TweenSequence<Color?>([
              TweenSequenceItem(
                tween: ConstantTween<Color?>(Colors.transparent),
                weight: 75.0,
              ),
              TweenSequenceItem(
                tween: ColorTween(
                  begin: Colors.transparent,
                  end: Colors.lightGreenAccent.withAlpha(
                    200,
                  ), // Start with pale green
                ),
                weight: 5.0,
              ),
              TweenSequenceItem(
                tween: ColorTween(
                  begin: Colors.lightGreenAccent.withAlpha(200),
                  end: Colors.white.withAlpha(200), // Transition to white
                ),
                weight: 5.0,
              ),
              TweenSequenceItem(
                tween: ColorTween(
                  begin: Colors.white.withAlpha(200),
                  end: Colors.transparent,
                ),
                weight: 5.0,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(
                  0.8,
                  1.0,
                  curve: Curves.easeInOut,
                ), // Adjusted interval
              ),
            )
        .._flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: param._animationController!,
            curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
          ),
        )
        .._animationController!.forward();
    });
    if (mounted) {
      Future.delayed(const Duration(seconds: 6)).then((_) {
        setState(() {
          param
            .._textScan = "${localeRouteJson["scan"]}..."
            .._textDailyBook = localeRouteJson["daily_book"];
        });
      });
      Future.delayed(const Duration(seconds: 8)).then((_) {
        setState(() {
          param
            .._textScan = ""
            .._textDailyBook = "";
        });
      });
      Future.delayed(Duration(seconds: param._totalDuration)).then((_) {
        Navigator.pushNamed(context, CoreEnumRoute.suggestionBook.toString());
      });
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
    final selector = local.utility._utilitySelector;
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);

    param._animationController?.dispose();
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
