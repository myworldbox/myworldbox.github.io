import 'package:flutter/material.dart';
import 'package:flutter_template/model/model_app.dart';
import 'package:flutter_template/utility/utility_selector.dart';
import '../../model/model_ui.dart';

class GridLayout extends StatelessWidget {
  final ModelApp app;
  final ModelUi ui;

  const GridLayout({super.key, required this.ui, required this.app});

  @override
  Widget build(BuildContext context) {
    // Convert ui.dataList to List<List<Widget>>
    final widgetList = ui.dataList?.cast<List<Widget>>();

    // Get rows (m) and columns (n)
    final m = widgetList!.length;
    final n = widgetList.isNotEmpty ? widgetList[0].length : 1;

    final size = UtilitySelector().getSize(app);

    return GridView.builder(
      padding: EdgeInsets.all(size.xxxs),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: n,
        crossAxisSpacing: size.xxxs,
        mainAxisSpacing: size.xxxs,
        childAspectRatio: 1.0,
      ),
      itemCount: m * n,
      itemBuilder: (context, index) {
        final row = index ~/ n;
        final col = index % n;

        return (row < m && col < widgetList[row].length)
            ? widgetList[row][col]
            : Container();
      },
    );
  }
}
