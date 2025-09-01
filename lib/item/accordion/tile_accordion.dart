import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../model/model_ui.dart';

class TileAccordion extends StatefulWidget {
  const TileAccordion({super.key, required this.ui});

  final ModelUi ui;

  @override
  createState() => _TileAccordionState();
}

class _TileAccordionState extends State<TileAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Map<CoreEnumData, String>? data = widget.ui.data;

    Widget accordion = Column(
      children: [
        ExpansionTile(
          title: Text(data?[CoreEnumData.title].toString() ?? ''),
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          children: [Text(data?[CoreEnumData.content].toString() ?? '')],
        ),
      ],
    );

    return accordion;
  }
}
