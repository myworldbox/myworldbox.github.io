import 'package:flutter/material.dart';
import '../../model/model_app.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_selector.dart';
import '../../model/model_ui.dart';
import 'default_button.dart';

class ExistButton extends StatelessWidget {
  final ModelApp app;
  final ModelUi ui;

  final UtilitySelector selector = UtilitySelector();
  final UtilityCallback callback = UtilityCallback();

  ExistButton({super.key, required this.app, required this.ui});

  @override
  Widget build(BuildContext context) {
    final (param, utility, func) = selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    return DefaultButton(
      app: app,
      ui: ModelUi(
        callback: () {
          Navigator.pop(app.context);
        },
        backgroundColor: Colors.black,
        borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
        dataList: [
          Icon(
            Icons.arrow_back,
            size: eachHeight / 2.5,
            color: Colors.greenAccent,
          ),
          Flexible(
            child: Text(
              ui.data,
              style: TextStyle(
                fontSize: eachHeight / 2.5,
                color: Colors.greenAccent,
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
