import 'package:flutter/material.dart';

import '../../model/atom.dart';
import '../../core/core_mixin.dart';
import '../css/default_css.dart';

class DefaultDatePicker extends StatefulWidget {
  final Atom fragment;

  const DefaultDatePicker({Key? key, required this.fragment}) : super(key: key);

  @override
  createState() => _DefaultDatePickerState();
}

class _DefaultDatePickerState extends State<DefaultDatePicker>  with Pitch {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final one = widget.fragment.thing?.one;

    Future<void> selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime((one?.data?.from)!.toInt()),
          lastDate: DateTime((one?.data?.to)!.toInt()));

      if (pickedDate != null && pickedDate != selectedDate) {
        selectedDate = pickedDate;
        one?.function!(selectedDate!.toIso8601String().substring(0, 10));
        emit(this);
      }
    }

    final buttonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.only(
        left: one?.style?.padding?.left?.width ?? 0,
        top: one?.style?.padding?.top?.width ?? 0,
        right: one?.style?.padding?.right?.width ?? 0,
        bottom: one?.style?.padding?.bottom?.width ?? 0,
      ),
      backgroundColor: one?.style?.backgroundColor,
      foregroundColor: one?.style?.font?.color,
    );

    Widget datapicker = SizedBox(
      height: one?.style?.height,
      width: one?.style?.width,
      child: ElevatedButton(
        onPressed: selectDate,
        style: buttonStyle,
        child: Text(selectedDate != null
            ? selectedDate!.toIso8601String().substring(0, 10)
            : "Please Select"),
      ),
    );

    return DefaultCss(
        fragment: Atom(
            thing: Thing(one: Content(widget: datapicker)),
            style: widget.fragment.style));
  }
}
