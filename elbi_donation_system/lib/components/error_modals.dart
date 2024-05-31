import 'package:flutter/material.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';

class CustomModal {
  static Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
    Color? iconColor,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColor,
                ),
              SizedBox(width: 8),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showCustomDialog(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.info,
      iconColor: Colors.blue,
      onPressed: onPressed,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showCustomDialog(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.error,
      iconColor: Colors.red,
      onPressed: onPressed,
    );
  }
}
