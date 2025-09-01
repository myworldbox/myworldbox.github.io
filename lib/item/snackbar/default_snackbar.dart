import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class DefaultSnackbar extends StatefulWidget {
  final Atom fragment;

  const DefaultSnackbar({super.key, required this.fragment});

  @override
  createState() => _DefaultSnackbarState();
}

class _DefaultSnackbarState extends State<DefaultSnackbar> {
  
  final _snackBarBehavior = SnackBarBehavior.floating;

  @override
  Widget build(BuildContext context) {
    dynamic snackBar = SnackBar(
      content: Text("label"),
      showCloseIcon: true,
      width: 400,
      behavior: _snackBarBehavior,
      action: SnackBarAction(
            label: 'Long Action Text',
            onPressed: () {
              // Code to execute.
            },
          ),
      duration: const Duration(seconds: 3),
      actionOverflowThreshold: 0.25,
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: snackBar)),
        style: widget.fragment.style,
      ),
    );
  }
}
