import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool isNum;
  final bool isPassword;
  final bool? readOnly;
  const FormTextField(
      {required this.isNum,
      required this.label,
      required this.controller,
      required this.isPassword,
      this.readOnly = false,
      super.key,
      required this.inputType});

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  String _textValue = "";

  //called when object is initialized
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _textValue =
            widget.controller.text; //holds input text value of textfield
      });
    });
  }

  //removes remaining data to prevent memory leakage
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.label),
          const SizedBox(height: 5),
          TextFormField(
            readOnly: widget.readOnly!,
            keyboardType: widget.inputType,
            obscureText: widget.isPassword,
            validator: (val) {
              if (val!.isEmpty) return "Please enter an input!";

              if (widget.isNum && num.tryParse(val) == null) {
                return "Invalid input!";
              }
              return null;
            },
            controller: widget.controller,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ]));
  }
}
