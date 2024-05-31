import 'package:flutter/material.dart';

class MenuDropDown extends StatefulWidget {
  final List<String> options;
  final String label;
  final Function(String) onValueChanged; // Callback function for value change
  const MenuDropDown({
    required this.options,
    required this.label,
    required this.onValueChanged,
    Key? key, // Add key parameter here
  }) : super(key: key);

  @override
  State<MenuDropDown> createState() => _MenuDropDown();
}

class _MenuDropDown extends State<MenuDropDown> {
  late String _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu(
            label: Text(widget.label),
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            onSelected: (value) {
              setState(() {
                _selectedOption = value!;
              });
              widget.onValueChanged(value!);
            },
            dropdownMenuEntries: widget.options.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
        ],
      ),
    );
  }
}