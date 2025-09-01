import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageHighlighter extends StatefulWidget {
  final Uint8List? imageBytes;
  final ValueChanged<Map<Offset, Color>> onHighlightComplete;

  const ImageHighlighter({
    this.imageBytes,
    required this.onHighlightComplete,
    Key? key,
  }) : super(key: key);

  @override
  _ImageHighlighterState createState() => _ImageHighlighterState();
}

class _ImageHighlighterState extends State<ImageHighlighter> {
  final Map<Offset, Color> highlightedAreas = {};
  Color highlightColor = Colors.red.withValues(opacity: 0.3);

  void _onTapDown(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      highlightedAreas[localPosition] = highlightColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Stack(
        children: [
          if (widget.imageBytes != null) Image.memory(widget.imageBytes!),
          CustomPaint(
            painter: HighlightPainter(highlightedAreas),
          ),
        ],
      ),
    );
  }
}

class HighlightPainter extends CustomPainter {
  final Map<Offset, Color> highlightedAreas;

  HighlightPainter(this.highlightedAreas);

  @override
  void paint(Canvas canvas, Size size) {
    highlightedAreas.forEach((offset, color) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromCircle(center: offset, radius: 10), paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
