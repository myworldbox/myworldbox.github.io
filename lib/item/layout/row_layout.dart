import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class RowLayout extends StatelessWidget {
  final Atom? fragment;

  const RowLayout({Key? key, this.fragment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget layout = Wrap(
      direction: Axis.horizontal,
      children: fragment?.thing?.one?.dataList ?? [],
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: layout)),
        style: fragment?.style,
      ),
    );
  }
}
