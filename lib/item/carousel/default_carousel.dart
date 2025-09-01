import 'dart:async';
import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class DefaultCarousel extends StatefulWidget {
  final Atom fragment;

  const DefaultCarousel({Key? key, required this.fragment}) : super(key: key);

  @override
  createState() => _DefaultCarouselState();
}

class _DefaultCarouselState extends State<DefaultCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage <
          (widget.fragment.thing?.one?.dataList?.length ?? 0) - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final one = widget.fragment.thing?.one;
    Widget view = PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemCount: one?.dataList?.length,
      itemBuilder: (context, index) {
        return one?.dataList?[index];
      },
    );

    Widget carousel = Stack(
      alignment: Alignment.center,
      children: [
        view,
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              one?.dataList?.length ?? 0,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: carousel)),
        style: widget.fragment.style,
      ),
    );
  }
}
