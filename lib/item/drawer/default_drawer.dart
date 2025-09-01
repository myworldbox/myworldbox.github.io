import 'package:flutter/material.dart';

import '../../model/model_ui.dart';

class DefaultDrawer extends StatelessWidget {
  final ModelUi ui;

  const DefaultDrawer({super.key, required this.ui});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: ui.dataList ?? []),
    );
  }
}
