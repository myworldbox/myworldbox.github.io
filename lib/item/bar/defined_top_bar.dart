import 'package:flutter/material.dart';
import '../../item/bar/default_top_bar.dart';

import '../../page/test/fos_home.dart';
import '../../page/auth/fos_auth_login.dart';
import '../../page/auth/page_register.dart';
import '../../model/atom.dart';

class DefinedTopBar extends DefaultTopBar {
  const DefinedTopBar({Key? key, Atom? fragment})
    : super(key: key, fragment: fragment);

  Widget build(BuildContext context) {
    return DefaultTopBar(
      fragment: Atom(
        thing: Thing(
          one: Content(data: Data(title: "flutter_template")),
          multiple: [
            Content(
              data: Data(title: "home"),
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageHome()),
                );
              },
            ),
            Content(
              data: Data(title: "login"),
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageLogin()),
                );
              },
            ),
            Content(
              data: Data(title: "register"),
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageRegister()),
                );
              },
            ),
          ],
        ),
        style: Style(width: 900, height: 900),
      ),
    );
  }
}
