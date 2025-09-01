import 'package:flutter/material.dart';

class AutoPlayWidget extends StatefulWidget {
  final List<Widget> widgets;

  const AutoPlayWidget({Key? key, required this.widgets}) : super(key: key);

  @override
  createState() => _AutoPlayWidgetState();
}

class _AutoPlayWidgetState extends State<AutoPlayWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToNextPage();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void animateToNextPage() {
    Future.delayed(const Duration(seconds: 10), () {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _pageController.page!.toInt() == widget.widgets.length - 1
              ? 0
              : _pageController.page!.toInt() + 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      animateToNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: widget.widgets,
    );
  }
}
