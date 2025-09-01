import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;

  static final Random _random = Random();

  Particle(this.position, this.velocity, this.color, this.size);

  void update(Size parentSize) {
    final drift = Offset(
      (_random.nextDouble() - 0.5) * 0.02,
      (_random.nextDouble() - 0.5) * 0.02,
    );
    velocity += drift;
    position += velocity;

    // Wrap around edges
    if (position.dx < 0) position = Offset(parentSize.width, position.dy);
    if (position.dx > parentSize.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, parentSize.height);
    if (position.dy > parentSize.height) position = Offset(position.dx, 0);
  }
}

class EffectMilky extends StatefulWidget {
  const EffectMilky({Key? key}) : super(key: key);

  @override
  _EffectMilkyState createState() => _EffectMilkyState();
}

class _EffectMilkyState extends State<EffectMilky>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final Random _random = Random();
  Size _currentSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          for (var p in particles) {
            p.update(_currentSize);
          }
        });
      });

    _controller.repeat();
  }

  void _initializeParticles(Size size) {
    final count = (size.width * size.height / 1000).clamp(300, 1500).toInt();
    particles = List.generate(count, (_) {
      final position = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
      final velocity = Offset(
        (_random.nextDouble() - 0.5) * 0.2,
        (_random.nextDouble() - 0.5) * 0.2,
      );
      final color =
          Color((_random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8);
      final sizeVal = 1 + _random.nextDouble() * 3;
      return Particle(position, velocity, color, sizeVal);
    });
  }

  void _resumeAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    });
  }

  void pause() => _controller.stop();
  void resume() => _controller.repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          pause();
          _resumeAfterDelay();
        }
      },
      onPointerMove: (_) {
        pause();
        _resumeAfterDelay();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          pause();
          _resumeAfterDelay();
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);

            if (_currentSize != size) {
              _currentSize = size;
              _initializeParticles(size);
            }

            return CustomPaint(
              painter: _ChaoticPainter(particles, size),
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}

class _ChaoticPainter extends CustomPainter {
  final List<Particle> particles;
  final Size size;

  _ChaoticPainter(this.particles, this.size);

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Optional: draw a black background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color.fromARGB(255, 0, 0, 0),
    );

    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(p.position, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
