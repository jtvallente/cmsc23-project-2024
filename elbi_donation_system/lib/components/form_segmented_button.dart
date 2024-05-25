import 'package:flutter/material.dart';

class FormSegmentedButton extends StatefulWidget {
  final List<String> options;
  final String label;
  final Function(String) onValueChanged; // Callback function for value change
  const FormSegmentedButton({
    required this.options,
    required this.label,
    required this.onValueChanged,
    Key? key, // Add key parameter here
  }) : super(key: key);

  @override
  State<FormSegmentedButton> createState() => _FormSegmentedButtonState();
}

class _FormSegmentedButtonState extends State<FormSegmentedButton> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          Wrap(
            children: widget.options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(option),
                  selected: _selectedOption == option,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedOption = option;
                      });
                      widget.onValueChanged(option);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
