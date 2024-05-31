import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool isNum;
  final bool isPassword;
  final bool? readOnly;
  final String? Function(String?)? validator;

  const FormTextField({
    required this.isNum,
    required this.label,
    required this.controller,
    required this.isPassword,
    this.readOnly = false,
    required this.inputType,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
            ),
            ),
          const SizedBox(height: 5),
            TextFormField(
              readOnly: readOnly!,
              keyboardType: inputType,
              obscureText: isPassword,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: validator,
            ),
        ],
      ),
    );
  }
}
