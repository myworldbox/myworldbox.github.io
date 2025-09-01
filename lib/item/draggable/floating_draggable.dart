import 'dart:developer';

import 'package:flutter/material.dart';

class FloatingDraggableWidget extends StatefulWidget {
  final Widget child;
  final double childWidth;
  final double childHeight;

  const FloatingDraggableWidget({super.key, 
    required this.child,
    required this.childWidth,
    required this.childHeight,
  });

  @override
  createState() =>
      _FloatingDraggableWidgetState();
}

class _FloatingDraggableWidgetState extends State<FloatingDraggableWidget> {
  late double _xOffset;
  late double _yOffset;
  late bool _focused;

  @override
  void initState() {
    super.initState();
    _xOffset = 0.0;
    _yOffset = 0.0;
    _focused = false;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _focused = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset = details.globalPosition.dx - (widget.childWidth / 2);
      _yOffset = details.globalPosition.dy - (widget.childHeight / 2);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _focused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _xOffset,
      top: _yOffset,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Draggable(
          feedback: widget.child,
          childWhenDragging: Container(),
          onDragStarted: () {
            setState(() {
              _focused = true;
            });
          },
          onDraggableCanceled: (_, __) {
            setState(() {
              _focused = false;
            });
          },
          child: _focused
              ? _FloatingDraggableFocusIndicator(child: widget.child)
              : widget.child,
        ),
      ),
    );
  }
}

class _FloatingDraggableFocusIndicator extends StatelessWidget {
  final Widget child;

  const _FloatingDraggableFocusIndicator({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              // Handle the close button tap
              log('Close button tapped');
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
