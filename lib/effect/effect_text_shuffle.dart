import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/model_ui.dart';

class EffectTextShuffle extends StatefulWidget {
  final ModelUi ui;

  const EffectTextShuffle({super.key, required this.ui});

  @override
  State<EffectTextShuffle> createState() => _EffectTextShuffleState();
}

class _EffectTextShuffleState extends State<EffectTextShuffle>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String _text = '';
  String _displayText = '';
  bool _isActive = true;
  bool _isScrolling = false;
  final Random _random = Random();
  ScrollController? _scrollController;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _text = _randomText();
    _displayText = '';
    _charIndex = 0;

    _scrollController = ScrollController();
    _scrollController?.addListener(_handleScroll);

    _loopTyping();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_handleScroll);
    _scrollController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController!.position.isScrollingNotifier.value) {
      if (!_isScrolling) {
        setState(() => _isScrolling = true);
      }
    } else {
      if (_isScrolling) {
        setState(() => _isScrolling = false);
        if (_isActive) _loopTyping();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isActive = state == AppLifecycleState.resumed;
    if (_isActive && !_isScrolling) {
      _loopTyping();
    }
  }

  String _randomText() {
    final data = widget.ui.data;
    return data.isNotEmpty ? data[_random.nextInt(data.length)] : '';
  }

  void _loopTyping() async {
    while (_isActive && !_isScrolling && mounted) {
      await _typeText();
      await Future.delayed(const Duration(seconds: 5)); // Pause between texts
    }
  }

  Future<void> _typeText() async {
    if (widget.ui.data.isEmpty) return;

    // Reset for new text
    _text = _randomText();
    _charIndex = 0;
    _displayText = '';

    // Typing effect
    while (_charIndex < _text.length && _isActive && !_isScrolling && mounted) {
      setState(() {
        _displayText = _text.substring(0, _charIndex + 1);
      });
      _charIndex++;
      await Future.delayed(const Duration(milliseconds: 50)); // Typing speed
    }

    // Ensure full text is displayed
    if (mounted && _isActive && !_isScrolling) {
      setState(() {
        _displayText = _text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ui.data.isEmpty) {
      return const Center(
        child: Text(
          'No mottos available',
          style: TextStyle(fontSize: 30, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Text(
              _displayText,
              key: ValueKey(_displayText),
              style: GoogleFonts.aBeeZee(
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}