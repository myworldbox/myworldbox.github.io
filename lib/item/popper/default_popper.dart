import 'package:flutter/material.dart';
import 'dart:async';

import '../../model/atom.dart';

class DefaultPopper extends StatefulWidget {
  final Atom fragment;

  const DefaultPopper({Key? key, required this.fragment}) : super(key: key);

  @override
  createState() => _DefaultPopperState();
}

class _DefaultPopperState extends State<DefaultPopper>
    with SingleTickerProviderStateMixin {
      
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;
  late OverlayEntry _overlayEntry;
  bool _isPopperVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(builder: (context) => _buildPopper());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    _timer?.cancel(); // Cancel the timer if it's active
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildPopper() {
    return Positioned(
      top: 50,
      right: 20,
      child: FadeTransition(
        opacity: _animation,
        child: Material(
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Text(one?.data?.title ?? ''),
          ),
        ),
      ),
    );
  }

  void _togglePopper() {
    setState(() {
      if (_isPopperVisible) {
        _timer?.cancel(); // Cancel the timer if it's active
        _animationController.reverse().whenComplete(() {
          _overlayEntry.remove();
          setState(() {
            _isPopperVisible = false;
          });
        });
      } else {
        Overlay.of(context).insert(_overlayEntry);
        _animationController.forward();
        _timer = Timer(const Duration(seconds: 5), () {
          setState(() {
            _animationController.reverse().whenComplete(() {
              _overlayEntry.remove();
              setState(() {
                _isPopperVisible = false;
              });
            });
          });
        });
        setState(() {
          _isPopperVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _togglePopper,
      child: const Text('Toggle Popper'),
    );
  }
}
