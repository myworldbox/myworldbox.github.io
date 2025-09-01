import 'package:flutter/material.dart';

class ClosableLayout extends StatefulWidget {
  const ClosableLayout({super.key});

  @override
  createState() => _ClosableLayoutState();
}

class _ClosableLayoutState extends State<ClosableLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Tab 1", "Tab 2", "Tab 3"]; // List of tabs

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabClosed(int index) {
    setState(() {
      _tabs.removeAt(index);
      _tabController = TabController(length: _tabs.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _tabs
                .map((tab) => Tab(
                      child: Row(
                        children: [
                          Text(tab),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _handleTabClosed(
                                _tabs.indexOf(tab)), // Close button action
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((tab) => Center(
                        child: Text(tab),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
