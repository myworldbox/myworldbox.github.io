import 'dart:math';
import 'package:flutter/material.dart';

class LightBeam {
  Offset start;
  Offset control;
  Offset end;
  Color color;
  double width;

  LightBeam(this.start, this.control, this.end, this.color, this.width);

  void update(Offset center) {
    final direction = (center - start).direction;
    final distance = (center - start).distance;

    // 模擬重力扭曲：控制點會偏移
    final curveOffset = Offset.fromDirection(direction + 0.5, distance * 0.3);
    control = Offset.lerp(control, curveOffset, 0.05)!;

    // 終點慢慢靠近中心
    end = Offset.lerp(end, center, 0.02)!;
  }
}

class EffectBlackhole extends StatefulWidget {
  const EffectBlackhole({Key? key}) : super(key: key);

  @override
  State<EffectBlackhole> createState() => _EffectBlackholeState();
}

class _EffectBlackholeState extends State<EffectBlackhole>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<LightBeam> beams = [];
  final random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(() {
        setState(() {
          final center = MediaQuery.of(context).size.center(Offset.zero);
          for (var beam in beams) {
            beam.update(center);
          }
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBeams();
      _controller.repeat();
    });
  }

  void _initializeBeams() {
    final size = MediaQuery.of(context).size;
    final center = size.center(Offset.zero);
    final count = 60;

    for (int i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = max(size.width, size.height) * 1.2;
      final start = center + Offset.fromDirection(angle, radius);
      final control = Offset.lerp(start, center, 0.5)!;
      final end = Offset.lerp(start, center, 0.8)!;
      final color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.4);
      final width = 1.5 + random.nextDouble() * 2;

      beams.add(LightBeam(start, control, end, color, width));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlackholeLightPainter(beams),
      child: Container(),
    );
  }
}

class _BlackholeLightPainter extends CustomPainter {
  final List<LightBeam> beams;

  _BlackholeLightPainter(this.beams);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // 背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    // 光束
    for (var beam in beams) {
      final paint = Paint()
        ..color = beam.color
        ..strokeWidth = beam.width
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(beam.start.dx, beam.start.dy)
        ..quadraticBezierTo(
          beam.control.dx,
          beam.control.dy,
          beam.end.dx,
          beam.end.dy,
        );

      canvas.drawPath(path, paint);
    }

    // 黑洞核心
    canvas.drawCircle(
      center,
      30,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.deepPurple.shade900,
            Colors.black,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 30)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
