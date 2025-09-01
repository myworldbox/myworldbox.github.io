import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class DefaultImage extends StatelessWidget {
  final Atom fragment;

  const DefaultImage({
    Key? key,
    required this.fragment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
  late Content? one = fragment.thing?.one;
    final path = one?.data?.path?.toString() ?? '';

    Widget image = path.startsWith('http') || path.startsWith('https')
        ? Image.network(path)
        : Image.asset(path);

    return DefaultCss(
        fragment: Atom(
            thing: Thing(one: Content(widget: image)), style: fragment.style));
  }
}
