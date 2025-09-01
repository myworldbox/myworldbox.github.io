import 'package:flutter/material.dart';
import '../../core/core_mixin.dart';

import '../../model/atom.dart';
import '../css/default_css.dart';

class AutocompleteDropdown extends StatefulWidget {
  final Atom fragment;

  const AutocompleteDropdown({Key? key, required this.fragment})
    : super(key: key);

  @override
  State<AutocompleteDropdown> createState() => _DropdownState();
}

class _DropdownState extends State<AutocompleteDropdown> with Pitch {
  late Content? one = widget.fragment.thing?.one;
  late List<Content>? multiple = widget.fragment.thing?.multiple;
  String? dropDownIndex;
  final TextEditingController _textController = TextEditingController();
  late List<String> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions =
        multiple?.map((value) => value.data?.title.toString() ?? "").toList() ??
        [];

    _textController.addListener(() {
      if (one?.function != null) {
        one?.current = dropDownIndex!;
        one?.function!(dropDownIndex!);
        one?.function!();
        emit(this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // Filter the suggestions based on the entered text
        return _suggestions.where(
          (suggestion) => suggestion.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      onSelected: (String selectedValue) {
        setState(() {
          dropDownIndex = selectedValue;
        });
        one?.function?.call(selectedValue);
        one?.function?.call();
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(labelText: one?.hint ?? ""),
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: widget.fragment.style?.width,
                  height: 50.0 * _suggestions.length,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: options
                        .map(
                          (String option) => ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
    );

    return DefaultCss(
      fragment: Atom(
        thing: Thing(one: Content(widget: dropdown)),
        style: widget.fragment.style,
      ),
    );
  }
}
