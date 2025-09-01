import '../item/behavior/default_scroll_behavior.dart';
import '../item/provider/default_provider.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'package:flutter/material.dart';

import 'core/core_enum.dart';
import 'core/core_generic.dart';
import 'core/core_static.dart';
import 'model/model_app.dart';

import 'model/model_local.dart';
import 'utility/utility_activity.dart';
import 'utility/utility_http.dart';
import 'utility/utility_selector.dart';
import 'utility/utility_storage.dart';

class CurrentParam {}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilitySelector _utilitySelector;
  final UtilityStorage _utilityStorage;
  final UtilityHttp _utilityHttp;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilitySelector = UtilitySelector(),
      _utilityStorage = UtilityStorage(),
      _utilityHttp = UtilityHttp();
}

class CurrentFunc {
  Widget _build(Main app) {
    final selector = app.local.utility._utilitySelector;

    return DefaultNavigationProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: DefaultScrollBehavior(),
        title:
            "${CoreStatic.coreVar.project.name}: [${CoreStatic.coreVar.env.name}]",
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          return supportedLocales.first;
        },
        theme: selector.getThemeData(CoreEnumTheme.light),
        darkTheme: selector.getThemeData(CoreEnumTheme.dark),
        // highContrastTheme: _themeData(CoreEnumTheme.highContrast),
        // highContrastDarkTheme: _themeData(CoreEnumTheme.highContrastDark),
        themeMode: switch (CoreStatic.coreVar.theme) {
          CoreEnumTheme.light => ThemeMode.light,
          CoreEnumTheme.dark => ThemeMode.dark,
          CoreEnumTheme.highContrast => ThemeMode.light,
          CoreEnumTheme.highContrastDark => ThemeMode.dark,
        },
        routes: Map.fromEntries(
          CoreStatic.coreConst.allRoute.entries.map(
            (entry) => MapEntry(entry.key.toString(), entry.value.builder),
          ),
        ),
      ),
    );
  }
}

class Main
    extends ModelApp<Pager<Main>, CurrentParam, CurrentUtility, CurrentFunc> {
  @override
  Widget build(BuildContext context) => local.func._build(this);

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final main = Main();

  final (CurrentParam param, CurrentUtility utility, CurrentFunc func) = main
      .local
      .utility
      ._utilitySelector
      .getLocal(main);
  await utility._utilityActivity.once();
  runApp(Pager(state: () => main));
}
