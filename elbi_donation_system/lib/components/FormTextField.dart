import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool isNum;
  final bool isPassword;
  final bool? readOnly;

  const FormTextField({
    required this.isNum,
    required this.label,
    required this.controller,
    required this.isPassword,
    this.readOnly = false,
    super.key,
    required this.inputType,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _validateInput(widget.controller.text);
      });
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = "Please enter an input!";
      } else if (widget.isNum && num.tryParse(value) == null) {
        _errorMessage = "Invalid input! Contact number should be a number.";
      } else if (widget.isPassword && value.length < 8) {
        _errorMessage = "Password must be at least 8 characters long!";
      } else {
        _errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          const SizedBox(height: 5),
          TextFormField(
            readOnly: widget.readOnly!,
            keyboardType: widget.inputType,
            obscureText: widget.isPassword,
            onChanged: _validateInput,
            controller: widget.controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}
