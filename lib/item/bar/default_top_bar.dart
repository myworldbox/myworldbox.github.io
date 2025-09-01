import 'package:flutter/material.dart';
import '../../model/atom.dart';

class DefaultTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Atom? fragment;

  const DefaultTopBar({Key? key, this.fragment}) : super(key: key);

  @override
  createState() => _DefaultTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DefaultTopBarState extends State<DefaultTopBar> {
  bool _isSmallScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check the screen width after the layout is built
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        _isSmallScreen = screenWidth < 600; // Adjust the threshold as needed
      });
    });
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems() {
    return widget.fragment!.thing!.multiple!.map((e) {
      return PopupMenuItem<String>(
        value: e.data?.title.toString(),
        onTap: e.function! as VoidCallback,
        child: Text(e.data?.title.toString() ?? ""),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.fragment!.thing?.one?.data?.title ?? ""),
      actions: _isSmallScreen
          ? [
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                itemBuilder: (context) => _buildPopupMenuItems(),
              ),
            ]
          : _buildPopupMenuItems(),
    );
  }
}
