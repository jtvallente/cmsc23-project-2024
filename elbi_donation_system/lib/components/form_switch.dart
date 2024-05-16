import 'package:elbi_donation_system/components/controllers.dart';
import 'package:flutter/material.dart';

class FormSwitch extends StatefulWidget {
  final String label;
  final SwitchController controller;
  final ValueChanged<bool>? onChanged; // Add this line

  const FormSwitch({
    required this.label,
    required this.controller,
    this.onChanged, // Add this line
    super.key,
  });

  @override
  State<FormSwitch> createState() => _FormSwitchState();
}

class _FormSwitchState extends State<FormSwitch> {
  @override
  void initState() {
    super.initState();
    widget.controller.setValue(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(widget.label)),
          Flexible(
            child: Switch(
              value: widget.controller.isSwitchOn,
              activeColor: Colors.red,
              onChanged: (bool value) {
                setState(() {
                  widget.controller.setValue(value);
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
