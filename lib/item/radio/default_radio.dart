import 'package:flutter/material.dart';
import '../../model/atom.dart';

import '../css/default_css.dart';

class DefaultRadio extends StatefulWidget {
  final Atom fragment;

  const DefaultRadio({Key? key, required this.fragment}) : super(key: key);

  @override
  createState() => _DefaultRadioState();
}

class _DefaultRadioState extends State<DefaultRadio> {
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;
  dynamic selected;

  @override
  void initState() {
    super.initState();
    selected = multiple?.firstWhere(
      (element) => element.data?.selected == true,
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic radio = Column(
      children:
          multiple?.map<RadioListTile>((Content option) {
            return RadioListTile(
              title: Text(option.data?.title ?? ""),
              value: option,
              groupValue: selected,
              onChanged: (value) {
                setState(() {
                  if (value == selected) {
                    selected = null;
                    option.data?.selected = false;
                  } else {
                    selected = value;
                    option.data?.selected = true;
                  }
                });
                one?.function?.call(value);
              },
            );
          }).toList() ??
          [],
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: radio)),
        style: widget.fragment.style,
      ),
    );
  }
}
