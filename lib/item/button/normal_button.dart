import 'package:flutter/material.dart';
import '../../model/model_app.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_selector.dart';

import '../../model/model_ui.dart';
import 'default_button.dart';

class NormalButton extends StatelessWidget {
  final ModelApp app;
  final ModelUi ui;

  final UtilitySelector selector = UtilitySelector();
  final UtilityCallback callback = UtilityCallback();

  NormalButton({super.key, required this.app, required this.ui});

  @override
  Widget build(BuildContext context) {
    final (param, utility, func) = selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return DefaultButton(
      app: app,
      ui: ModelUi(
        callback: ui.callback,
        backgroundColor: ui.backgroundColor ?? Colors.white,
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
        dataList: [
          if (ui.iconData != null)
            Icon(
              ui.iconData,
              size: ui.iconSize ?? eachHeight / 2.5,
              color: ui.textColor ?? Colors.black,
            ),
          Flexible(
            child: Text(
              ui.data,
              style: TextStyle(
                fontSize: ui.textSize ?? eachHeight / 3,
                color: ui.textColor ?? Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
