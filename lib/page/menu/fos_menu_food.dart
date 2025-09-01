import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../../item/button/exist_button.dart';
import '../../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../utility/utility_activity.dart';
import '../../item/button/normal_button.dart';

class CurrentParam {
  late final String _textBreakfast;
  late final String _textLunch;
  late final String _textDinner;
  late final String _textMonday;
  late final String _textTuesday;
  late final String _textWednesday;
  late final String _textThursday;
  late final String _textFriday;
  late final String _textSaturday;
  late final String _textSunday;
  late final String _textPublicHoliday;
  late final String _textSelectAll;
  late final String _textReselect;
  late final String _textFinishOrder;
  late final String _textStart;
  late final String _textTotalMeal;
  late final String _textTotalPrice;
  late final String _textExist;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityConvert _utilityConvert;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityConvert = UtilityConvert(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  Widget _itemPublicHoliday(FosMenuFood app) {
    final selector = app.local.utility._utilitySelector;
    final size = selector.getSize(app);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(size.xxs),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.xxs,
          vertical: size.xxxs,
        ),
        child: Text(
          app.local.param._textPublicHoliday,
          style: TextStyle(fontSize: size.s, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buttonReselect(FosMenuFood app) {
    final selector = app.local.utility._utilitySelector;
    final size = selector.getSize(app);
    return NormalButton(
      app: app,
      ui: ModelUi(
        callback: () {
          Navigator.pushNamed(app.context, CoreEnumRoute.menuFood.toString());
        },
        iconData: Icons.redo_outlined,
        data: app.local.param._textReselect,
      ),
    );
  }

  Widget _buttonFinishOrder(FosMenuFood app) {
    final selector = app.local.utility._utilitySelector;
    final size = selector.getSize(app);
    return NormalButton(
      app: app,
      ui: ModelUi(
        callback: () {
          Navigator.pushNamed(
            app.context,
            CoreEnumRoute.paymentCash.toString(),
          );
        },
        iconData: Icons.check,
        data: app.local.param._textFinishOrder,
      ),
    );
  }

  List<Widget> _layoutMeun(FosMenuFood app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final isMobile = CoreStatic.coreVar.device == CoreEnumDevice.mobile;

    // Define meal labels (columns)
    final meals = [param._textBreakfast, param._textLunch, param._textDinner];

    // Define day labels (rows)
    final dayLabels = [
      param._textSunday,
      param._textMonday,
      param._textTuesday,
      param._textWednesday,
      param._textThursday,
      param._textFriday,
      param._textSaturday,
    ];

    // Sample public holidays for 2025
    final publicHolidays = {
      DateTime(2025, 7, 1), // Hong Kong SAR Establishment Day
      // Add more holidays as needed
    };

    // State for week offset
    final ValueNotifier<int> weekOffset = ValueNotifier(0);

    return [
      ValueListenableBuilder<int>(
        valueListenable: weekOffset,
        builder: (context, offset, child) {
          // Update days based on week offset, starting from today (June 30, 2025, Monday)
          final today = DateTime(2025, 6, 30);
          final weekDays = List.generate(7, (index) {
            final date = today.add(Duration(days: index + offset * 7));
            return {
              'date': date,
              'label': dayLabels[date.weekday % 7],
              'isHoliday': publicHolidays.contains(
                DateTime(date.year, date.month, date.day),
              ),
            };
          });

          return Column(
            children: [
              // Week navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward, size: size.s),
                    onPressed: () => weekOffset.value--,
                    tooltip: 'Previous Week',
                  ),
                  Text(
                    weekDays.isNotEmpty
                        ? '${(weekDays.first['date'] as DateTime).month}/${(weekDays.first['date'] as DateTime).day} - ${(weekDays.last['date'] as DateTime).month}/${(weekDays.last['date'] as DateTime).day}'
                        : 'Week N/A',
                    style: TextStyle(fontSize: size.xs),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward, size: size.s),
                    onPressed: () => weekOffset.value++,
                    tooltip: 'Next Week',
                  ),
                ],
              ),
              // Header row for meal labels
              Row(
                children: [
                  // Meal headers
                  ...meals.map(
                    (meal) => Expanded(
                      child: Center(
                        child: Text(
                          meal,
                          style: TextStyle(
                            fontSize: size.xs,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 7x3 grid (7 days, 3 meals)
              Container(
                height: eachHeight * 3.5,
                width: maxWidth,
                decoration: utility._utilityWidget.border(),
                child: GridView.builder(
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 1 for day labels + 3 for meals
                    childAspectRatio: isMobile ? 2 : 3,
                    mainAxisSpacing: size.xs,
                    crossAxisSpacing: size.xs,
                  ),
                  itemCount: 7 * 4, // 7 rows * (1 day label + 3 meals)
                  itemBuilder: (context, index) {
                    final row = index ~/ 4; // Row index (0 to 6)
                    final col = index % 4; // Column index (0 to 3)
                    final day = weekDays[row];
                    final isHoliday = day['isHoliday'] as bool;

                    if (col == 0) {
                      // Day label column
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(size.xxs),
                        ),
                        child: Center(
                          child: Text(
                            day['label'] as String,
                            style: TextStyle(
                              fontSize: size.s,
                              fontWeight: FontWeight.bold,
                              color: isHoliday
                                  ? Colors.blueGrey
                                  : Colors.blueAccent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    } else {
                      // Meal columns (Breakfast, Lunch, Dinner)
                      if (isHoliday) {
                        return func._itemPublicHoliday(app);
                      }
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(size.xxs),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                meals[col - 1],
                                style: TextStyle(fontSize: size.xs),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: size.xxxs),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.xxs,
                                    vertical: size.xxxs,
                                  ),
                                  minimumSize: Size(0, size.s),
                                ),
                                child: Text(
                                  param._textSelectAll,
                                  style: TextStyle(fontSize: size.xs),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  List<Widget> _layout(FosMenuFood app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final ValueNotifier<int> weekOffset = ValueNotifier(
      0,
    ); // Added for week navigation

    // Calculate week ranges for buttons
    final today = DateTime(2025, 6, 30);
    final weekRanges = [
      {
        'offset': 0,
        'label':
            '${today.month}/${today.day} - ${today.add(Duration(days: 6)).month}/${today.add(Duration(days: 6)).day}',
      },
      {
        'offset': 1,
        'label':
            '${today.add(Duration(days: 7)).month}/${today.add(Duration(days: 7)).day} - ${today.add(Duration(days: 13)).month}/${today.add(Duration(days: 13)).day}',
      },
      {
        'offset': 2,
        'label':
            '${today.add(Duration(days: 14)).month}/${today.add(Duration(days: 14)).day} - ${today.add(Duration(days: 20)).month}/${today.add(Duration(days: 20)).day}',
      },
      {
        'offset': 3,
        'label':
            '${today.add(Duration(days: 21)).month}/${today.add(Duration(days: 21)).day} - ${today.add(Duration(days: 27)).month}/${today.add(Duration(days: 27)).day}',
      },
    ];

    final mainItem = [
      utility._utilityWidget.widgetSectionLogo(app),
      Container(
        height: eachHeight * 4.5,
        width: maxWidth,
        decoration: utility._utilityWidget.border(),
        child: func._layoutMeun(app).first,
      ),
      Container(
        height: eachHeight,
        width: maxWidth,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: weekRanges
                .asMap()
                .entries
                .map(
                  (entry) => [
                    ElevatedButton(
                      onPressed: () {
                        weekOffset.value = entry.value['offset'] as int;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 0),
                        padding: EdgeInsets.all(size.xs),
                      ),
                      child: Text(
                        entry.value['label'] as String,
                        style: TextStyle(fontSize: size.xs),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: size.xs),
                  ],
                )
                .expand((element) => element)
                .toList(),
          ),
        ),
      ),
      Container(
        width: maxWidth,
        padding: EdgeInsets.all(size.xs),
        decoration: BoxDecoration(
          border: utility._utilityWidget.border().border,
        ),
        child: (CoreStatic.coreVar.device == CoreEnumDevice.mobile)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buttonReselect(app),
                  SizedBox(height: size.s),
                  _buttonFinishOrder(app),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buttonReselect(app), _buttonFinishOrder(app)],
              ),
      ),
      Wrap(
        direction: CoreStatic.coreVar.device == CoreEnumDevice.mobile
            ? Axis.vertical
            : Axis.horizontal,
        children: [
          Container(
            height: eachHeight,
            width: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                ? maxWidth
                : maxWidth / 2,
            decoration: BoxDecoration(
              border: utility._utilityWidget.border().border,
            ),
            padding: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                ? null
                : EdgeInsets.only(left: size.m),
            child: Align(
              alignment: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: ExistButton(
                app: app,
                ui: ModelUi(data: CoreStatic.coreUnion.data(param._textExist)),
              ),
            ),
          ),
          Container(
            height: eachHeight,
            width: CoreStatic.coreVar.device == CoreEnumDevice.mobile
                ? maxWidth
                : maxWidth / 2,
            decoration: utility._utilityWidget.border(),
            padding: EdgeInsets.only(right: size.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${param._textTotalMeal}: (100)",
                  style: TextStyle(fontSize: size.xs),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${param._textTotalPrice}: (HKD 10000)",
                  style: TextStyle(fontSize: size.xs),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
    return [
      utility._utilityWidget.widgetBackground(app),
      ListView(children: mainItem),
    ];
  }
}

class FosMenuFood
    extends
        ModelApp<
          Pager<FosMenuFood>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    await local.utility._utilityActivity.init(this);

    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    setState(() {
      local.param
        .._textExist = localeJson["exist"].toString()
        .._textBreakfast = localeRouteJson["breakfast"].toString()
        .._textLunch = localeRouteJson["lunch"].toString()
        .._textDinner = localeRouteJson["dinner"].toString()
        .._textPublicHoliday = localeRouteJson["public_holiday"].toString()
        .._textSelectAll = localeRouteJson["select_all"].toString()
        .._textReselect = localeRouteJson["reselect"].toString()
        .._textFinishOrder = localeRouteJson["finish_order"].toString()
        .._textStart = localeRouteJson["start"].toString()
        .._textTotalMeal = localeRouteJson["total_meal"].toString()
        .._textTotalPrice = localeRouteJson["total_price"].toString()
        .._textMonday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["monday"].toString(),
        )
        .._textTuesday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["tuesday"].toString(),
        )
        .._textWednesday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["wednesday"].toString(),
        )
        .._textThursday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["thursday"].toString(),
        )
        .._textFriday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["friday"].toString(),
        )
        .._textSaturday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["saturday"].toString(),
        )
        .._textSunday = local.utility._utilityConvert.toVerticalText(
          localeRouteJson["sunday"].toString(),
        );
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
  get discard => () async {};

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
