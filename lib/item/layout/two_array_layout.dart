import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class TwoArrayLayout extends StatelessWidget {
  final Atom fragment;

  const TwoArrayLayout({Key? key, required this.fragment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Content? one = fragment.thing?.one;
    late List<Content>? multiple = fragment.thing?.multiple;

    final screenHeight =
        fragment.style?.height ?? MediaQuery.of(context).size.height;
    final screenWidth =
        fragment.style?.width ?? MediaQuery.of(context).size.width;
    final sectionHeight = screenHeight / fragment.thing?.any.length;
    final maxRowLength = fragment.thing?.any
        .fold(0, (max, row) => row.length > max ? row.length : max);
    final sectionWidth = screenWidth / maxRowLength;

    Widget layout = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: maxRowLength,
        childAspectRatio: sectionWidth / coreVar.sectionHeight,
      ),
      itemCount: maxRowLength * fragment.thing?.any.length,
      itemBuilder: (context, index) {
        final row = index ~/ maxRowLength;
        final column = index % maxRowLength;

        if (row < fragment.thing?.any.length &&
            column < fragment.thing?.any[row].length) {
          return Container(
            height: sectionHeight,
            width: sectionWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.topLeft,
            child: fragment.thing?.any[row][column],
          );
        } else {
          return Container();
        }
      },
    );

    return DefaultCss(
        fragment: Atom(
            thing: Thing(one: Content(widget: layout)), style: fragment.style));
  }
}
