import 'package:flutter/material.dart';
import 'package:flutter_template/model/model_ui.dart';
import '../../core/core_enum.dart';

class DefaultAccordion extends StatefulWidget {
  const DefaultAccordion({super.key, required this.ui});

  final ModelUi ui;

  @override
  createState() => _DefaultAccordionState();
}

class _DefaultAccordionState extends State<DefaultAccordion> {
  bool _isExpanded = false;

  Map<CoreEnumData, String>? data;

  @override
  Widget build(BuildContext context) {
    data = widget.ui.data;

    Widget accordion = Column(
      children: [
        ListTile(
          title: Text(
            data?[CoreEnumData.title].toString() ?? '',
            softWrap: false,
            maxLines: 1,
          ),
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded) Text(data?[CoreEnumData.content].toString() ?? ''),
      ],
    );

    return accordion;
  }
}
