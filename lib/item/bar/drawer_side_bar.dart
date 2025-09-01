import 'package:flutter/material.dart';
import '../../page/auth/fos_auth_login.dart';
import 'package:provider/provider.dart';

import '../../page/auth/page_forget_password.dart';
import '../../page/test/fos_home.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }
}

final itemsFirst = [
  const DrawerItem(title: 'Get Started', icon: Icons.people),
  const DrawerItem(title: 'Samples & Tutorials', icon: Icons.phone_android),
  const DrawerItem(
    title: 'Testing & Debugging',
    icon: Icons.settings_applications,
  ),
  const DrawerItem(title: 'Performance & Optimization', icon: Icons.build),
];

final itemsSecond = [
  const DrawerItem(title: 'Deployment', icon: Icons.cloud_upload),
  const DrawerItem(title: 'Resources', icon: Icons.extension),
];

class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({required this.title, required this.icon});
}

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea = EdgeInsets.only(
      top: MediaQuery.of(context).viewPadding.top,
    );

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return SizedBox(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: const Color(0xFF1a2f45),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 10),
              buildList(items: itemsFirst, isCollapsed: isCollapsed),
              const SizedBox(height: 10),
              const Divider(color: Colors.white70),
              const SizedBox(height: 10),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              const Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) => ListView.separated(
    padding: isCollapsed ? EdgeInsets.zero : padding,
    shrinkWrap: true,
    primary: false,
    itemCount: items.length,
    separatorBuilder: (context, index) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final item = items[index];

      return buildMenuItem(
        isCollapsed: isCollapsed,
        text: item.title,
        icon: item.icon,
        onClicked: () => selectItem(context, indexOffset + index),
      );
    },
  );

  void selectItem(BuildContext context, int index) {
    navigateTo(page) => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => page));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(PageHome());
        break;
      case 1:
        navigateTo(PageForgetPassword());
        break;
      case 2:
        navigateTo(PageLogin());
        break;
      case 3:
        navigateTo(PageLogin());
        break;
      case 4:
        navigateTo(PageLogin());
        break;
      case 5:
        navigateTo(PageLogin());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(title: leading, onTap: onClicked)
          : ListTile(
              leading: leading,
              title: Text(
                text,
                style: const TextStyle(color: color, fontSize: 16),
              ),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    const double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider = Provider.of<NavigationProvider>(
              context,
              listen: false,
            );

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? const FlutterLogo(size: 48)
      : const Row(
          children: [
            SizedBox(width: 24),
            FlutterLogo(size: 48),
            SizedBox(width: 16),
            Text(
              'Flutter',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}
