import 'package:flutter/material.dart';

class ProjectColors {
  LinearGradient get greenPrimaryGradient => const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Color(0xFF6FCC8A), Color(0xFF288242)],
      );
  LinearGradient get purplePrimaryGradient => const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Color(0xFFA36FCC), Color(0xFF4F2882)],
      );
  LinearGradient get bluePrimaryGradient => const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Color(0xFF4697E1), Color(0xFF2B679E)],
      );

  LinearGradient get yellowPrimaryGradient => const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [
          Color.fromARGB(255, 255, 234, 0),
          Color.fromRGBO(209, 137, 3, 1)
        ],
      );
  LinearGradient get redPrimaryGradient => const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Color.fromARGB(255, 255, 0, 0), Color.fromRGBO(209, 3, 3, 1)],
      );

  Color get greenPrimary => const Color(0xFF288242);
  Color get purplePrimary => const Color(0xFF4F2882);
  Color get bluePrimary => const Color(0xFF2B679E);
  Color get yellowPrimary => Color.fromRGBO(209, 137, 3, 1);
}
