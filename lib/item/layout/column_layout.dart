import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class ColumnLayout extends StatelessWidget {
  final Atom? fragment;

  const ColumnLayout({Key? key, this.fragment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget layout = Wrap(
      direction: Axis.vertical,
      children: fragment?.thing?.one?.dataList ?? [],
      // fragment?.thing?.multiple?.map((e) => e.widget ?? Container()).toList() ?? []
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: layout)),
        style: fragment?.style,
      ),
    );
  }
}
