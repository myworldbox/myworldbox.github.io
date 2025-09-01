import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/@core/core_enum.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';
import '../../model/model_ui.dart';

class DefaultLayout extends StatefulWidget {
  final ModelUi ui;

  DefaultLayout({super.key, required this.ui});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final double _velocityThreshold = kIsWeb ? 500.0 : 1000.0;
  final double _topThreshold = 100.0;
  final double _bottomThreshold = 100.0;
  late List<Widget> widgetList;
  double _lastOffset = 0.0;
  DateTime _lastScrollTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    final coreVar = CoreStatic.coreVar;
    coreVar.display[CoreEnumDisplay.appBar] = false;
    coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleNavBars() {
    setState(() {
      final coreVar = CoreStatic.coreVar;
      bool isAnyNavBarOpen =
          coreVar.display[CoreEnumDisplay.appBar] == true ||
          coreVar.display[CoreEnumDisplay.bottomNavigationBar] == true;
      coreVar.display[CoreEnumDisplay.appBar] = !isAnyNavBarOpen;
      coreVar.display[CoreEnumDisplay.bottomNavigationBar] = !isAnyNavBarOpen;
    });
  }

  void _closeNavBars() {
    setState(() {
      final coreVar = CoreStatic.coreVar;
      coreVar.display[CoreEnumDisplay.appBar] = false;
      coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
    });
  }

  void _handleScroll() {
    final coreVar = CoreStatic.coreVar;
    final currentOffset = _scrollController.offset;
    final currentTime = DateTime.now();
    final timeDiff = currentTime.difference(_lastScrollTime).inMilliseconds;

    if (timeDiff > 0) {
      final velocity = ((currentOffset - _lastOffset) / timeDiff) * 1000.0;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final isNearTop = currentOffset < _topThreshold;
      final isNearBottom =
          maxScrollExtent > 0 &&
          (maxScrollExtent - currentOffset) < _bottomThreshold;

      if (velocity.abs() > _velocityThreshold) {
        setState(() {
          if (velocity < 0 && isNearTop) {
            coreVar.display[CoreEnumDisplay.appBar] = true;
            coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
          } else if (velocity < 0 && isNearBottom) {
            coreVar.display[CoreEnumDisplay.bottomNavigationBar] = true;
            coreVar.display[CoreEnumDisplay.appBar] = false;
          } else if (velocity > 0) {
            coreVar.display[CoreEnumDisplay.appBar] = false;
            coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
          }
        });
      }
    }

    _lastOffset = currentOffset;
    _lastScrollTime = currentTime;
  }

  void _handleMouseMove(PointerHoverEvent event, BuildContext context) {
    final coreVar = CoreStatic.coreVar;
    final screenHeight = MediaQuery.of(context).size.height;
    final cursorY = event.position.dy;

    if (coreVar.env != CoreEnumEnv.dev) {
      return;
    }

    setState(() {
      if (cursorY < _topThreshold) {
        coreVar.display[CoreEnumDisplay.appBar] = true;
        coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
      } else if (cursorY > screenHeight - _bottomThreshold) {
        coreVar.display[CoreEnumDisplay.bottomNavigationBar] = true;
        coreVar.display[CoreEnumDisplay.appBar] = false;
      } else {
        coreVar.display[CoreEnumDisplay.appBar] = false;
        coreVar.display[CoreEnumDisplay.bottomNavigationBar] = false;
      }
    });
  }

  Widget _buildDrawer() {
    final (coreConst, coreVar) = (CoreStatic.coreConst, CoreStatic.coreVar);
    return Drawer(
      child: ListView(
        children: coreConst.allRoute.entries
            .map(
              (e) => ListTile(
                leading: Icon(
                  e.value.icon,
                  color: e.value.enable
                      ? (coreVar.route == e.key
                            ? Colors.indigoAccent
                            : Colors.greenAccent)
                      : Colors.grey,
                ),
                title: Text(
                  e.key.name,
                  style: TextStyle(
                    color: e.value.enable
                        ? (coreVar.route == e.key
                              ? Colors.indigoAccent
                              : Colors.greenAccent)
                        : Colors.grey,
                  ),
                ),
                onTap: e.value.enable
                    ? () {
                        Navigator.pushNamed(context, e.key.toString());
                        _closeNavBars();
                      }
                    : null,
                selectedColor: const Color(0xff6200ee),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBody() => GestureDetector(
    onTap: _closeNavBars,
    child: Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(overscroll: false, scrollbars: false),
        child: ListView(controller: _scrollController, children: widgetList),
      ),
    ),
  );

  Widget _buildActionButton() {
    final coreVar = CoreStatic.coreVar;
    bool isAnyNavBarOpen =
        coreVar.display[CoreEnumDisplay.appBar] == true ||
        coreVar.display[CoreEnumDisplay.bottomNavigationBar] == true;
    return FloatingActionButton(
      onPressed: _toggleNavBars,
      tooltip: isAnyNavBarOpen ? 'Close Navigation' : 'Open Navigation',
      child: Icon(isAnyNavBarOpen ? Icons.close : Icons.menu),
    );
  }

  Widget _buildBottomNavBar() {
    final (coreConst, coreVar) = (CoreStatic.coreConst, CoreStatic.coreVar);
    currentColor(e) =>
        (coreVar.route == e.key ? Colors.indigoAccent : Colors.greenAccent);
    return BottomAppBar(
      child: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: coreConst.allRoute.entries
                  .map(
                    (e) => TextButton(
                      onPressed: e.value.enable
                          ? () {
                              Navigator.pushNamed(context, e.key.value);
                              _closeNavBars();
                            }
                          : null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        foregroundColor: e.value.enable
                            ? currentColor(e)
                            : Colors.grey,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(e.value.icon),
                          Text(
                            e.key.name,
                            style: TextStyle(
                              color: e.value.enable
                                  ? currentColor(e)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() => SizedBox(
    height: kToolbarHeight,
    child: AppBar(actions: []),
  );

  @override
  Widget build(BuildContext context) {
    final coreVar = CoreStatic.coreVar;
    widgetList = (widget.ui.dataList as List).cast<Widget>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: SafeArea(
        child: MouseRegion(
          onHover: kIsWeb ? (event) => _handleMouseMove(event, context) : null,
          child: Stack(
            children: [
              _buildBody(),
              if (coreVar.display[CoreEnumDisplay.appBar] == true)
                Positioned(top: 0, left: 0, right: 0, child: _buildAppBar()),
            ],
          ),
        ),
      ),
      drawer: coreVar.display[CoreEnumDisplay.drawer] == true
          ? _buildDrawer()
          : null,
      floatingActionButton:
          coreVar.display[CoreEnumDisplay.floatingActionButton] == true
          ? _buildActionButton()
          : null,
      bottomNavigationBar:
          coreVar.display[CoreEnumDisplay.bottomNavigationBar] == true
          ? _buildBottomNavBar()
          : null,
    );
  }
}
