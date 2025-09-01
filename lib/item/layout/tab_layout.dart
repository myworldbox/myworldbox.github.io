import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class TabLayout extends StatefulWidget {
  final Atom fragment;

  const TabLayout({Key? key, required this.fragment}) : super(key: key);
  @override
  createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout>
    with SingleTickerProviderStateMixin {
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: multiple?.length ?? 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget layout = Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: multiple?.map((e) => Tab(text: e.data?.title)).toList() ?? [],
          indicator: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blue, width: 1)),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                multiple
                    ?.map((e) => ListView(children: e.dataList ?? []))
                    .toList() ??
                [],
          ),
        ),
      ],
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: layout)),
        style: widget.fragment.style,
      ),
    );
  }
}
