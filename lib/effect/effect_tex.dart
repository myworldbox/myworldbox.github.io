import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../core/core_record.dart';
import 'dart:async';

class EffectTex extends StatefulWidget {
  final List<CoreRecordTex> theories;

  const EffectTex({Key? key, required this.theories}) : super(key: key);

  @override
  EffectTexState createState() => EffectTexState();
}

class EffectTexState extends State<EffectTex>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _controller.reset();
          _currentIndex = Random().nextInt(widget.theories.length);
          _controller.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theory = widget.theories[_currentIndex];
    final cleanedTex = theory.tex;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              theory.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Auto-size LaTeX to fit width without scrolling
            SizedBox(
              width: double.infinity, // give FittedBox a concrete width
              child: FittedBox(
                fit: BoxFit.scaleDown, // only scales down, never up
                alignment: Alignment.center,
                child: Math.tex(
                  cleanedTex,
                  mathStyle: MathStyle.display,
                  textStyle: const TextStyle(
                    fontSize: 24, // base size; will scale down as needed
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
