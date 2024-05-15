import 'package:flutter/material.dart';

class FormSegmentedButton extends StatefulWidget {
  final List<String> options;
  final String label;
  const FormSegmentedButton({required this.options, required this.label, super.key});

  @override
  State<FormSegmentedButton> createState() => _FormSegmentedButtonState();
}

class _FormSegmentedButtonState extends State<FormSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    Set<String> _selected = {widget.options.first};
    void updateSelected(Set<String> newSelection) {
      setState(() {
        _selected = newSelection;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label),
          SegmentedButton(
              multiSelectionEnabled: false,
              segments: widget.options.map((option) {
                return ButtonSegment(value: option, label: Text(option));
              }).toList(),
              selected: _selected,
              onSelectionChanged:
                  updateSelected),
        ],
      ),
    ); //implement to get the selected value
  }
}
