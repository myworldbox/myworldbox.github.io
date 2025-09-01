import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import '../../core/core_static.dart';
import '../../model/model_ui.dart';

class OverlayLayout extends StatelessWidget {
  final ModelUi ui;

  OverlayLayout({super.key, required this.ui});

  @override
  Widget build(BuildContext context) {
    final widgetList = (ui.dataList as List).cast<Widget>();
    final coreVar = CoreStatic.coreVar;
    final size = coreVar.size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.fromSize(
          size: size,
          child: CustomMultiChildLayout(
            delegate: _OverlayLayoutDelegate(
              widgetList.length,
              size.width.toInt(),
              size.height.toInt(),
            ),
            children: widgetList
                .map(
                  (child) =>
                      LayoutId(id: widgetList.indexOf(child), child: child),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _OverlayLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  final int width;
  final int height;

  _OverlayLayoutDelegate(this.itemCount, this.width, this.height);

  @override
  void performLayout(Size size) {
    int x = 0;
    int y = 0;
    int maxHeightInRow = 0;

    for (int i = 0; i < itemCount; i++) {
      if (hasChild(i)) {
        final childSize = layoutChild(i, BoxConstraints.loose(size));
        final childWidth = childSize.width.toInt();
        final childHeight = childSize.height.toInt();

        if (x + childWidth > width && x > 0) {
          x = 0;
          y += maxHeightInRow;
          maxHeightInRow = 0;
        }

        if (y + childHeight > height) {
          x = 0;
          y = 0;
          maxHeightInRow = 0;
        }

        positionChild(i, Offset(x.toDouble(), y.toDouble()));
        x += childWidth;
        maxHeightInRow = max(maxHeightInRow, childHeight);
      }
    }
  }

  @override
  bool shouldRelayout(_OverlayLayoutDelegate oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
