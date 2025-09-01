import 'package:flutter/material.dart';

import '../../core/core_enum.dart';
import '../../model/model_ui.dart';

class DefaultAlert extends StatelessWidget {
  final ModelUi ui;

  const DefaultAlert({Key? key, required this.ui}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Map<CoreEnumData, String>? data = ui.data;
    return AlertDialog(
      title: Text(data?[CoreEnumData.title] ?? ""),
      content: Text(data?[CoreEnumData.content] ?? ""),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(data?[CoreEnumData.body] ?? ""),
        ),
      ],
    );
  }
}
