import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    this.isPreviousButton = true,
    required this.onTap,
  });
  final bool isPreviousButton;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Icon(isPreviousButton ? Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_right_rounded),
        ),
      ),
    );
  }
}
