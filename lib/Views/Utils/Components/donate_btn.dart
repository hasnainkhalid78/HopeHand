import 'package:flutter/material.dart';

class DonationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? buttonColor;
  const DonationButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: buttonColor,
        ),
        child: Center(child: child),
      ),
    );
  }
}
