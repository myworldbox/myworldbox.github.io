import 'package:flutter/material.dart';
import '../../model/atom.dart';

import '../css/default_css.dart';

class DefaultText extends StatefulWidget {
  final Atom fragment;

  const DefaultText({Key? key, required this.fragment}) : super(key: key);

  @override
  createState() => _DefaultTextState();
}

class _DefaultTextState extends State<DefaultText> {
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget word = Text(
      one?.data?.title ?? "",
      style: TextStyle(
        fontSize: one?.style?.font?.size,
        fontWeight: one?.style?.font?.weight,
        color: one?.style?.color,
      ),
    );

    Widget text = widget.fragment.effect?.isCenter == true
        ? Center(child: word)
        : word;

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: text)),
        style: widget.fragment.style,
      ),
    );
  }
}
