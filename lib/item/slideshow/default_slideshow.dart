import 'package:flutter/material.dart';
import 'dart:async';
import '../../model/model_ui.dart';

class DefaultSlideshow extends StatefulWidget {
  final ModelUi ui;
  const DefaultSlideshow({super.key, required this.ui});

  @override
  State<DefaultSlideshow> createState() => _DefaultSlideshowState();
}

class _DefaultSlideshowState extends State<DefaultSlideshow> {
  int _currentSlide = 0;
  Timer? _timer;
  bool _isPaused = false;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.ui.data.isNotEmpty) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      List<dynamic> data = widget.ui.data;
      if (!_isPaused && data.isNotEmpty) {
        _currentSlide = (_currentSlide + 1) % data.length;
        _pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      _isPaused ? _timer?.cancel() : _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: GestureDetector(
          onTap: _togglePause,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                if (!_isPaused) {
                  setState(() => _isPaused = true);
                  _timer?.cancel();
                }
              } else if (notification is ScrollEndNotification) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (_isPaused) {
                    setState(() => _isPaused = false);
                    _startTimer();
                  }
                });
              }
              return true;
            },
            child: PageView.builder(
              controller: _pageController,
              physics: const ClampingScrollPhysics(), // Enables user scroll
              itemCount: widget.ui.data.length,
              onPageChanged: (index) => setState(() => _currentSlide = index),
              itemBuilder: (context, index) => Image.network(
                widget.ui.data[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('Failed to load image',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ),
        ),
      );
}
