import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class OrderedLayout extends StatelessWidget {
  final Atom fragment;

  const OrderedLayout({Key? key, required this.fragment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Content? one = fragment.thing?.one;

    Widget layout = Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: one?.style?.liner?.side?.top?.color ?? Colors.transparent,
            width: one?.style?.liner?.side?.top?.width ?? 0,
          ),
          bottom: BorderSide(
            color: one?.style?.liner?.side?.bottom?.color ?? Colors.transparent,
            width: one?.style?.liner?.side?.bottom?.width ?? 0,
          ),
          left: BorderSide(
            color: one?.style?.liner?.side?.left?.color ?? Colors.transparent,
            width: one?.style?.liner?.side?.left?.width ?? 0,
          ),
          right: BorderSide(
            color: one?.style?.liner?.side?.right?.color ?? Colors.transparent,
            width: one?.style?.liner?.side?.right?.width ?? 0,
          ),
        ),
      ),
      constraints: BoxConstraints(maxWidth: fragment.style?.width ?? 0),
      child: Wrap(direction: Axis.horizontal, children: one?.dataList ?? []),
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: layout)),
        style: fragment.style,
      ),
    );
  }
}
