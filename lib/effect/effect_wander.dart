import 'dart:math' hide log;
import 'dart:developer';
import 'package:flutter/material.dart';

class Particle {
  double angle;
  double radius;
  double speed;
  double baseSpeed;
  double drift;
  Color color;
  bool clockwise;
  double size;
  double z;

  Particle(this.angle, this.radius, this.speed, this.color, this.clockwise,
      this.size)
      : baseSpeed = speed,
        drift = Random().nextDouble() * 0.01,
        z = Random().nextDouble();

  void update(double time) {
    double oscillation = sin(time + radius) * 0.0002;
    speed = baseSpeed + oscillation;
    angle += clockwise ? speed : -speed;
    radius += sin(time + drift) * 0.05; // subtle radial drift
  }
}

class EffectGalaxy extends StatefulWidget {
  const EffectGalaxy({Key? key}) : super(key: key);

  @override
  _EffectGalaxyState createState() => _EffectGalaxyState();
}

class _EffectGalaxyState extends State<EffectGalaxy>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  List<Particle> particles = [];
  final random = Random();
  bool _isAppActive = true;
  bool _isWidgetLikelyVisible = true;

  final colors = [
    Colors.white.withOpacity(0.8),
    Colors.blue.shade300,
    Colors.purple.shade300,
    Colors.cyanAccent.withOpacity(0.6),
    Colors.pinkAccent.withOpacity(0.5),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeParticles();
      if (_isAppActive && _isWidgetLikelyVisible) {
        _animationController.repeat();
      }
    });
  }

  void initializeParticles() {
    final screenSize = MediaQuery.of(context).size;
    final particleCount =
        (screenSize.width * screenSize.height / 1000).clamp(500, 2000).toInt();

    particles = List.generate(particleCount, (i) {
      final spiralAngle = random.nextDouble() * pi * 4;
      final radius = 10 + random.nextDouble() * 1000;
      final speed = 0.0001 + random.nextDouble() * 0.0003;
      final color = colors[random.nextInt(colors.length)];
      final clockwise = random.nextBool();
      final size = 1 + random.nextDouble() * 2;

      return Particle(spiralAngle, radius, speed, color, clockwise, size);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isAppActive = state == AppLifecycleState.resumed;
      _updateAnimationState();
    });
  }

  void _updateAnimationState() {
    if (_isAppActive && _isWidgetLikelyVisible) {
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else {
      if (_animationController.isAnimating) {
        _animationController.stop();
      }
    }
  }

  void _handleScrollNotification(ScrollNotification notification) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final double screenHeight = MediaQuery.of(context).size.height;

    bool isLikelyVisible =
        position.dy + size.height > 0 && position.dy < screenHeight;

    if (_isWidgetLikelyVisible != isLikelyVisible) {
      setState(() {
        _isWidgetLikelyVisible = isLikelyVisible;
        _updateAnimationState();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            _handleScrollNotification(scrollNotification);
            return false;
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
              if (_isAppActive && _isWidgetLikelyVisible) {
                particles.forEach((p) => p.update(time));
              }
              return ClipRect(
                child: CustomPaint(
                  painter: _GalaxyPainter(particles: particles),
                  size: Size(width, height),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  final List<Particle> particles;

  _GalaxyPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF101020),
    );

    for (var p in particles) {
      final position = Offset(
        cos(p.angle) * p.radius + center.dx,
        sin(p.angle) * p.radius + center.dy,
      );
      paint.color = p.color.withOpacity(0.5 + 0.5 * p.z);
      canvas.drawCircle(position, p.size * (0.5 + p.z), paint);
    }

    canvas.drawCircle(
      center,
      40,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.blue.shade900.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 50)),
    );
  }

  @override
  bool shouldRepaint(_GalaxyPainter oldDelegate) => true;
}
