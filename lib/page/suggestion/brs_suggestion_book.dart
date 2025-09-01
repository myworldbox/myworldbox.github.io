import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/utility/utility_http.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_generic.dart';
import '../../core/core_static.dart';
import '../../item/button/normal_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_storage.dart';
import '../../utility/utility_widget.dart';

class CurrentParam {
  late final int _totalDuration;
  late final String _textDailyBook;
  late final String _textBookName;
  late final String _textBookAuthor;
  late final String _textBookIsbn;
  late final String _textDescription;
  late final String _textRefresh;
  late final String _textDope;

  late final dynamic _pickedBook;

  AnimationController? _animationController;
  Animation<double>? _bookScaleAnimation;

  String? _textValueBookName;
  String? _textValueBookAuthor;
  String? _textValueBookIsbn;
  int? _textValueBookId;
  String? _textValueDescription;

  Uint8List? _imageByte;
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;
  final UtilityHttp _utilityHttp;
  final UtilityStorage _utilityStorage;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback(),
      _utilityHttp = UtilityHttp(),
      _utilityStorage = UtilityStorage();
}

class CurrentFunc {
  List<Widget> _layout(BrsSuggestionBook app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    List<Widget> mainItem = [
      Container(
        height: eachHeight,
        padding: EdgeInsets.all(size.xxs),
        alignment: Alignment.center,
        width: maxWidth,
        child: Text(
          param._textDailyBook,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.xl,
            color: Colors.lightGreenAccent, // Inner white color
            shadows: utility._utilityWidget.widgetShadow(app),
          ),
        ),
      ),
      Container(
        height: eachHeight * 3,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                width: maxWidth * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withAlpha(180),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image container
                    Container(
                      width:
                          (maxWidth * 0.95) *
                          0.4, // Reduced to 40% to give text more space
                      padding: EdgeInsets.symmetric(horizontal: size.xxxs),
                      child: Image.memory(
                        param._imageByte!,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                    // Text container
                    Flexible(
                      // Use Flexible to prevent overflow
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.xxxxs,
                        ), // Reduced padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (param._textValueBookName != null)
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${param._textBookName}: ",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: param._textValueBookName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                            if (param._textValueBookAuthor != null)
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${param._textBookAuthor}: ",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: param._textValueBookAuthor,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                            if (param._textValueBookIsbn != null)
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${param._textBookIsbn}: ",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: param._textValueBookIsbn,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.s,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Container(
        height: eachHeight * 3,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: EdgeInsets.all(size.xxxs),
                width: maxWidth * 0.95, // 80% of outer container width
                height:
                    (eachHeight * 3) * 0.95, // 80% of outer container height
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withAlpha(180),
                    width: 1,
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: (param._textValueDescription != null)
                        ? [
                            Text(
                              param._textDescription,
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: size.s,
                              ),
                            ),
                            Text(
                              param._textValueDescription!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.s,
                              ),
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Container(
        height: eachHeight * 1,
        width: maxWidth,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NormalButton(
              app: app,
              ui: ModelUi(
                callback: () {
                  List<dynamic> bookPerferenceList =
                      utility._utilityStorage.read(
                        CoreEnumStorage.bookPreferenceList,
                      ) ??
                      [];

                  bookPerferenceList.add({
                    "BookId": param._textValueBookId,
                    "Preference": "DISLIKE",
                    "LastSyncDate": DateTime.now().toIso8601String(),
                  });

                  utility._utilityStorage.create({
                    CoreEnumStorage.bookPreferenceList: bookPerferenceList,
                  });

                  Navigator.pushNamed(
                    app.context,
                    CoreEnumRoute.root.toString(),
                    arguments: {CoreEnumBrs.openDialog: true},
                  );
                  /*
                  int? dislike = utility._utilityStorage.read(
                    CoreEnumStorage.dislike,
                  );
                  utility._utilityStorage.create(<CoreEnumStorage, dynamic>{
                    CoreEnumStorage.dislike: dislike ?? 0 + 1,
                  });
                  */
                },
                // iconData: Icons.refresh,
                data: param._textRefresh,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
              ),
            ),
            NormalButton(
              app: app,
              ui: ModelUi(
                callback: () {
                  List<dynamic> bookPerferenceList =
                      utility._utilityStorage.read(
                        CoreEnumStorage.bookPreferenceList,
                      ) ??
                      [];

                  bookPerferenceList.add({
                    "BookId": param._textValueBookId,
                    "Preference": "LIKE",
                    "LastSyncDate": DateTime.now().toIso8601String(),
                  });

                  utility._utilityStorage.create({
                    CoreEnumStorage.bookPreferenceList: bookPerferenceList,
                  });

                  Navigator.pushNamed(
                    app.context,
                    CoreEnumRoute.root.toString(),
                  );
                  /*
                  int? like = utility._utilityStorage.read(
                    CoreEnumStorage.like,
                  );
                  utility._utilityStorage.create(<CoreEnumStorage, dynamic>{
                    CoreEnumStorage.like: like ?? 0 + 1,
                  });
                  */
                },
                iconData: Icons.favorite,
                data: param._textDope,
              ),
            ),
          ],
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
            color: Colors.black.withAlpha(0), // Add a dark overlay
            child: AnimatedBuilder(
              animation: param._animationController!,
              builder: (context, child) {
                return Transform.scale(
                  scale: param._bookScaleAnimation?.value ?? 1.0,
                  child: ListView(children: mainItem),
                );
              },
            ),
          ),
        ),
      ),
      utility._utilityWidget.widgetCloseButton(app),
    ];
  }
}

class BrsSuggestionBook
    extends
        ModelApp<
          Pager<BrsSuggestionBook>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        >
    with SingleTickerProviderStateMixin {
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

    final size = selector.getSize(this);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    final List<dynamic>? bookList = utility._utilityStorage.read(
      CoreEnumStorage.bookList,
    );

    if (bookList == null || bookList.isEmpty) {
      Navigator.pushNamed(context, CoreEnumRoute.root.toString());
      return;
    }

    int? pickedIndex = Random().nextInt(bookList!.length);

    final pickedBook = bookList[pickedIndex];

    final defaultImage = await utility._utilityReader.readFile(
      'assets/png/no_image.png',
    );

    List<dynamic>? newBookList = bookList..removeAt(pickedIndex);

    String? image = pickedBook["image"];

    utility._utilityStorage.create(<CoreEnumStorage, dynamic>{
      CoreEnumStorage.bookList: newBookList,
    });

    setState(() {
      param
        .._totalDuration = 500
        .._textDailyBook = localeRouteJson["daily_book"].toString()
        .._textBookName = localeRouteJson["book_name"].toString()
        .._textBookAuthor = localeRouteJson["book_author"].toString()
        .._textBookIsbn = localeRouteJson["book_isbn"].toString()
        .._textDescription = localeRouteJson["book_intro"].toString()
        .._textRefresh = localeRouteJson["refresh"].toString()
        .._textDope = localeRouteJson["dope"].toString()
        .._textValueBookName = pickedBook["name"]
        .._textValueBookAuthor = pickedBook["author"]
        .._textValueDescription = pickedBook["description"]
        .._textValueBookIsbn = pickedBook["isbn"]
        .._textValueBookId = pickedBook["id"]
        .._pickedBook = pickedBook
        .._imageByte = base64Decode(
          image?.isNotEmpty == true ? image : defaultImage,
        )
        .._animationController
            ?.dispose() // Dispose previous controller if exists
        .._animationController = AnimationController(
          duration: Duration(
            milliseconds: param._totalDuration,
          ), // Total duration 8 seconds
          vsync: this,
        )
        .._bookScaleAnimation =
            TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween<double>(begin: 0.05, end: 1), // Grow larger
                weight: 100,
              ),
            ]).animate(
              CurvedAnimation(
                parent: param._animationController!,
                curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
              ),
            )
        .._animationController!.forward();
    });
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