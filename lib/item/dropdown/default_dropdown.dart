import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../../core/core_mixin.dart';
import '../css/default_css.dart';

class DefaultDropdown extends StatefulWidget {
  final Atom fragment;

  const DefaultDropdown({Key? key, required this.fragment}) : super(key: key);

  @override
  State<DefaultDropdown> createState() => _DropdownState();
}

class _DropdownState extends State<DefaultDropdown>  with Pitch {
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;
  String? dropDownIndex;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      if (one?.function != null) {
        one?.current = dropDownIndex!;
        one?.function!(dropDownIndex!);
        emit(this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownButton<String>(
        icon: Icon(one?.image?.right?.icon),
        hint: Text(one?.hint ?? ""),
        isExpanded: true,
        enableFeedback: true,
        iconSize: 16,
        style: TextStyle(color: one?.style?.color),
        items: multiple?.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value.data?.title.toString(),
            child: Text(value.data?.title.toString() ?? ''),
          );
        }).toList(),
        onChanged: (String? index) {
          setState(() {
            dropDownIndex = index;
          });
          one?.function?.call(index);
          one?.function?.call();
        },
        value: dropDownIndex,
        underline: null);

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: dropdown)),
        style: widget.fragment.style,
      ),
    );
  }
}
