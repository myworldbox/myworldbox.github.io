import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class BottomDraggable extends StatefulWidget {
  final Atom? fragment;

  const BottomDraggable({super.key, required this.fragment});

  @override
  createState() => _BottomDraggableState();
}

class _BottomDraggableState extends State<BottomDraggable> {
  DraggableScrollableController scrollController =
      DraggableScrollableController();
  bool isDraggedDown = false;

  @override
  Widget build(BuildContext context) {
    final one = widget.fragment?.thing?.one;
    final multiple = widget.fragment?.thing?.multiple;
    Widget draggable = GestureDetector(
      onVerticalDragUpdate: (details) {
        double dragOffset = details.primaryDelta!;
        setState(() {
          if (dragOffset > 0) {
            isDraggedDown = true;
          } else {
            isDraggedDown = false;
          }
        });
      },
      child: DraggableScrollableActuator(
        child: DraggableScrollableSheet(
          controller: scrollController,
          initialChildSize: .5,
          minChildSize: .5,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: one?.style?.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(one?.style
                          ?.border?.topLeft?.radius ??
                      0),
                  topRight: Radius.circular(one?.style
                          ?.border?.topRight?.radius ??
                      0),
                  bottomLeft: Radius.circular(one?.style
                          ?.border?.bottomLeft?.radius ??
                      0),
                  bottomRight: Radius.circular(one
                          ?.style?.border?.bottom?.radius ??
                      0),
                ),
              ),
              child: ListView.builder(
                controller: scrollController,
                reverse: isDraggedDown,
                itemCount: multiple?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  int reversedIndex = isDraggedDown
                      ? (multiple!.length - 1 - index)
                      : index;
                  return multiple?[reversedIndex].widget ??
                      Container();
                },
              ),
            );
          },
        ),
      ),
    );
    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: draggable)),
        style: widget.fragment?.style,
      ),
    );
  }
}
