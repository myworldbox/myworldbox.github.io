import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  const DraggableWidget({super.key});

  @override
  createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  double xPosition = 50;
  double yPosition = 50;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: yPosition,
          left: xPosition,
          child: GestureDetector(
            onPanUpdate: (tapInfo) {
              setState(() {
                xPosition += tapInfo.delta.dx;
                yPosition += tapInfo.delta.dy;
              });
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}