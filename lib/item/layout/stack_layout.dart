import 'package:flutter/material.dart';
import '../../core/core_static.dart';
import '../../model/model_ui.dart';

class StackLayout extends StatelessWidget {
  final ModelUi ui;

  StackLayout({super.key, required this.ui});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = (ui.dataList as List).cast<Widget>();
    final size = CoreStatic.coreVar.size;

    return SizedBox.fromSize(
      size: size,
      child: Stack(children: widgetList),
    );
  }
}
