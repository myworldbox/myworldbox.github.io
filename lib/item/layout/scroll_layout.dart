import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class ScrollLayout extends StatelessWidget {
  final Atom? fragment;

  const ScrollLayout({Key? key, this.fragment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    Widget layout = SizedBox(
      width: fragment?.style?.width,
      height: fragment?.style?.height,
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: fragment?.thing?.one?.dataList ?? [],
        ),
      ),
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: layout)),
        style: fragment?.style,
      ),
    );
  }
}
