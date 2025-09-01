import '../../model/model_ui.dart';

import '../../model/model_app.dart';
import '../core/core_static.dart';
import 'utility_selector.dart';

class UtilityCallback {
  UtilitySelector _utilitySelector = UtilitySelector();

  void speak(ModelApp app, ModelUi ui) async {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    CoreStatic.coreVar.flutterTts.stop();
    await CoreStatic.coreVar.flutterTts.speak(ui.data.toString());
  }
}
