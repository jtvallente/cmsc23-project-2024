import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final Function() onTap;
  final String label;
  const PrimaryButton({required this.label, required this.onTap, super.key});

  @override
  State<PrimaryButton> createState() => _SlambookButtonState();
}

class _SlambookButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF6FCC8A), Color(0xFF288242)],
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 5, color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 15,
              offset: Offset(0, 15),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 20,
              offset: Offset(0, 34),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x02000000),
              blurRadius: 24,
              offset: Offset(0, 60),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x00000000),
              blurRadius: 26,
              offset: Offset(0, 94),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 5,
              offset: Offset(2, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            minimumSize:
                const Size(double.infinity, 50), // Set minimum width and height

            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            widget.label),
        ));
    // ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       minimumSize:
    //           Size(double.infinity, 50), // Set minimum width and height
    //     ),
    //     onPressed: widget.onTap,
    //     child: Text(widget.label));
  }
}
