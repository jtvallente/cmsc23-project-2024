import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String label;
  final LinearGradient gradient;
  final bool fillWidth;
  final IconData? icon;
  const PrimaryButton(
      {required this.label,
      required this.onTap,
      required this.gradient,
      required this.fillWidth,
      this.icon,
      super.key});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        decoration: ShapeDecoration(
          gradient: widget.gradient,
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
            minimumSize: widget.fillWidth
                ? const Size(double.infinity, 50)
                : null, // Set minimum width and height
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    fontFamily: 'WorkSans',
                  ),
                  widget.label),
              widget.icon == null ? Container() : const SizedBox(width: 10),
              widget.icon == null
                  ? Container()
                  : Icon(widget.icon, color: Colors.white, size: 25),
            ],
          ),
        ));
  }
}
