import 'package:flutter/material.dart';
import 'dart:math' as math;

class EffectNeon extends StatefulWidget {
  const EffectNeon({super.key});

  @override
  EffectNeonState createState() => EffectNeonState();
}

class EffectNeonState extends State<EffectNeon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: EffectNeonPainter(_controller),
      child: Container(),
    );
  }
}

class EffectNeonPainter extends CustomPainter {
  final Animation<double> animation;

  EffectNeonPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate dynamic colors based on animation value
    final hue = (animation.value * 360).toInt(); // Cycle through hues (0-360)
    final color1 = HSVColor.fromAHSV(1.0, hue % 360, 1.0, 1.0).toColor();
    final color2 = HSVColor.fromAHSV(1.0, (hue + 120) % 360, 1.0, 1.0).toColor();
    final color3 = HSVColor.fromAHSV(1.0, (hue + 240) % 360, 1.0, 1.0).toColor();

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = LinearGradient(
        colors: [color1, color2, color3],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = color1.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

    final path = Path();
    final shadowPath = Path();

    for (double x = 0; x < size.width; x++) {
      final y = size.height / 2 +
          math.sin((x / size.width * 4 * math.pi) + animation.value * 2 * math.pi) * 50;
      if (x == 0) {
        path.moveTo(x, y);
        shadowPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        shadowPath.lineTo(x, y);
      }
    }

    // Draw shadow first for glow effect
    canvas.drawPath(shadowPath, shadowPaint);
    // Draw main neon wave
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}