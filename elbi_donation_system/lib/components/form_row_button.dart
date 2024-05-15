import 'package:flutter/material.dart';

class FormRowButton extends StatefulWidget {
  final String label;
  final String buttonLabel;
  final IconData icon;
  final Function() onTap;
  const FormRowButton(
      {required this.buttonLabel,
      required this.icon,
      required this.label,
      required this.onTap,
      super.key});

  @override
  State<FormRowButton> createState() => _FormRowButtonState();
}

class _FormRowButtonState extends State<FormRowButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label),
          ElevatedButton(
            onPressed: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Text(widget.buttonLabel),
                const SizedBox(width: 10),
                Icon(widget.icon)
              ]),
            ),
          )
        ],
      ),
    );
  }
}
