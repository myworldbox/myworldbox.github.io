import 'package:flutter/material.dart';
import '../../model/model_app.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_selector.dart';

import '../../model/model_ui.dart';

class DefaultButton extends StatelessWidget {
  final ModelApp app;
  final ModelUi ui;

  final UtilitySelector selector = UtilitySelector();
  final UtilityCallback callback = UtilityCallback();

  DefaultButton({super.key, required this.app, required this.ui});

  @override
  Widget build(BuildContext context) {
    final (param, utility, func) = selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final List<Widget> widgetList = ui.dataList!
        .whereType<Widget>()
        .toList();

    return ElevatedButton(
      onPressed: ui.callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: ui.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: size.xs, vertical: size.xxs),
        textStyle: TextStyle(fontSize: eachHeight / 2.5),
        side: ui.borderSide,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.xxs), // Rounded corners
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: widgetList),
    );
  }
}
