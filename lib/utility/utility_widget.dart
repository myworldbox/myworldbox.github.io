import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/core/core_const.dart';
import '../../core/core_enum.dart';
import '../../core/core_record.dart';
import 'package:flutter/services.dart';

import 'package:flutter_library/@core/core_enum.dart';
import '../core/core_static.dart';
import '../item/button/normal_button.dart';
import '../item/layout/default_layout.dart';
import '../../model/model_app.dart';
import '../../model/model_ui.dart';
import 'utility_selector.dart';

class UtilityWidget {
  final UtilitySelector _utilitySelector = UtilitySelector();

  List<Shadow> widgetShadow(ModelApp app) {
    final selector = _utilitySelector;
    final size = selector.getSize(app);

    return [
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 2,
        color: Colors.black, // Outer black color
      ),
      Shadow(offset: Offset(-2, 2), blurRadius: 2, color: Colors.black),
      Shadow(offset: Offset(2, -2), blurRadius: 2, color: Colors.black),
      Shadow(offset: Offset(-2, -2), blurRadius: 2, color: Colors.black),
    ];
  }

  Widget widgetBackground(ModelApp app) {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Image.asset(
        height: maxHeight,
        width: maxWidth,
        CoreStatic.coreConst.asset.background,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget widgetSectionLogo(ModelApp app) {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    return Container(
      height: eachHeight,
      width: maxWidth,
      decoration: const BoxDecoration(color: Colors.greenAccent),
      child: Center(
        child: Image.asset(
          'assets/png/${CoreStatic.coreVar.project.name}_logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget widgetDialog(ModelApp app, ModelUi ui) {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    return AlertDialog(
      title: Text(ui.data[CoreEnumData.title.name]),
      content: Text(ui.data[CoreEnumData.content.name]),
      actions: [
        TextButton(
          onPressed: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: const Text('Close'),
        ),
      ],
    );
  }

  SnackBar widgetSnackBar(ModelApp app) {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    final changeSize = _utilitySelector.changeSize();

    return SnackBar(
      // backgroundColor: CoreStatic.coreVar.ok ? Colors.blue : Colors.red,
      content: Text(
        CoreStatic.coreVar.message!,
        style: TextStyle(fontSize: size.xxs),
      ),
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
    );
  }

  BoxDecoration border() {
    return BoxDecoration();
  }

  Widget padding() => const SizedBox(width: 16.0);

  List<Widget> widgetField(ModelApp app, ModelUi ui) {
    final core = _utilitySelector.getCore(app);
    final size = _utilitySelector.getSize(app);
    final Map<CoreEnumInput, TextEditingController> controllerList =
        ui.controller!;

    return controllerList.entries.map((entry) {
      final field = entry.key;
      final controller = entry.value;
      final regex = CoreStatic.coreVar.inputExtend![field]!;

      // Set default value if controller is empty
      if (controller.text.isEmpty && regex.defaultValue != null) {
        controller.text = regex.defaultValue!;
      }

      final localeJson =
          CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
      final String emptyMessage =
          '${regex.name} - ${localeJson["alert"]["empty"]}';

      final decoration = InputDecoration(
        labelText: regex.name,
        hintText: regex.hint,
        prefixIcon: Icon(regex.iconData ?? Icons.text_fields),
        border: const OutlineInputBorder(),
      );

      // Autocomplete field for select options
      if (regex.select?.isNotEmpty ?? false) {
        final displayOptions = regex.select!
            .map((option) => option.displayText)
            .toList();
        final displayToValue = {
          for (var option in regex.select!) option.displayText: option.value,
        };

        return Autocomplete<String>(
          initialValue: TextEditingValue(
            text: controller.text.isNotEmpty
                ? controller.text
                : regex.defaultValue ?? '',
          ),
          optionsBuilder: (TextEditingValue value) {
            if (value.text.isEmpty) return displayOptions;
            return displayOptions
                .where(
                  (option) =>
                      option.toLowerCase().contains(value.text.toLowerCase()),
                )
                .toList();
          },
          onSelected: regex.readOnly
              ? null
              : (String selection) {
                  controller.text = displayToValue[selection]!;
                  FocusManager.instance.primaryFocus?.unfocus();
                  app.setState(() {});
                },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                if (controller.text != textEditingController.text) {
                  textEditingController.text = controller.text;
                }
                textEditingController.addListener(() {
                  controller.text = textEditingController.text;
                });
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: decoration,
                  readOnly: regex.readOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) return emptyMessage;
                    if (!RegExp(regex.pattern).hasMatch(value))
                      return regex.hint;
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    focusNode.unfocus();
                    onFieldSubmitted();
                  },
                );
              },
          optionsViewBuilder: regex.readOnly
              ? (context, onSelected, options) => const SizedBox.shrink()
              : (context, onSelected, options) => Material(
                  elevation: 4,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      );
                    },
                  ),
                ),
        );
      }

      // Date picker field for datetime or dateOfBirth
      if (field == CoreEnumInput.datetime ||
          field == CoreEnumInput.dateOfBirth) {
        return TextFormField(
          controller: controller,
          readOnly: true,
          decoration: decoration,
          onTap: regex.readOnly
              ? null
              : () async {
                  final pickedDate = await showDatePicker(
                    context: app.context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    controller.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    app.setState(() {});
                  }
                },
          validator: (value) => value == null || value.isEmpty
              ? emptyMessage
              : !RegExp(regex.pattern).hasMatch(value)
              ? regex.hint
              : null,
        );
      }

      // Standard text field
      return TextFormField(
        controller: controller,
        decoration: decoration,
        obscureText: field == CoreEnumInput.password,
        readOnly: regex.readOnly,
        validator: (value) => value == null || value.isEmpty
            ? emptyMessage
            : !RegExp(regex.pattern).hasMatch(value)
            ? regex.hint
            : null,
      );
    }).toList();
  }

  void showQuitConfirmationDialog(ModelApp app) {
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];

    showDialog(
      context: app.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localeJson['alert']['quit_app_title']),
          content: Text(localeJson['alert']['quit_app_content']),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Quit the entire app
              },
              child: Text(localeJson['confirm']),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(localeJson['cancel']),
            ),
          ],
        );
      },
    );
  }

  Widget widgetCloseButton(ModelApp app) {
    final selector = _utilitySelector;
    final size = selector.getSize(app);
    final (param, utility, func) = selector.getLocal(app);

    return Positioned(
      top: size.xxxs,
      right: size.xxxs,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showQuitConfirmationDialog(app),
        child: Container(
          padding: EdgeInsets.all(
            size.xxxxs,
          ), // Add padding for button-like feel
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light background for button
            borderRadius: BorderRadius.circular(size.xs), // Rounded corners
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
          child: Icon(Icons.close, color: Colors.black, size: size.l),
        ),
      ),
    );
  }

  Widget widgetLoading(ModelApp app) {
    final selector = _utilitySelector;

    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);
    final (param, utility, func) = selector.getLocal(app);

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Center(
        child: Image.asset(
          height: maxHeight / 2,
          width: maxWidth / 2,
          CoreStatic.coreConst.asset.ghostRunGif,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
