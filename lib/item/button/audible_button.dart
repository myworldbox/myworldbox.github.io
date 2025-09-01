import 'package:flutter/material.dart';
import '../../model/model_app.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_selector.dart';

import '../../model/model_ui.dart';
import 'default_button.dart';

class AudibleButton extends StatelessWidget {
  final ModelApp app;
  final ModelUi ui;

  final UtilitySelector selector = UtilitySelector();
  final UtilityCallback callback = UtilityCallback();

  AudibleButton({super.key, required this.app, required this.ui});

  @override
  Widget build(BuildContext context) {
    final (param, utility, func) = selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return DefaultButton(
      app: app,
      ui: ModelUi(
        callback: ui.callback,
        backgroundColor: Colors.white,
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
        dataList: [
          Icon(ui.iconData, size: eachHeight / 2.5, color: Colors.black),
          Flexible(
            child: Text(
              ui.data,
              style: TextStyle(fontSize: eachHeight / 2.5, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_down_alt, size: eachHeight / 2.5),
            color: Colors.black,
            onPressed: () async {
              callback.speak(app, ModelUi(data: ui.data));
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
