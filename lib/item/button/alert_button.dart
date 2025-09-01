import 'package:flutter/material.dart';

import '../../model/atom.dart';
import 'default_button.dart';

class AlertButton extends DefaultButton {
  const AlertButton({Key? key, Atom? fragment})
      : super(key: key, fragment: fragment);

  @override
  Widget build(BuildContext context) {
    Content? one = fragment?.thing?.one;
    one?.style = Style(
      backgroundColor: Colors.red,
      liner: Liner(side: Side(
                  left: Box(radius: 10),
                  top: Box(radius: 10),
                  right: Box(radius: 10),
                  bottom: Box(radius: 10))),
    );

    return DefaultButton(fragment: fragment);
  }
}
