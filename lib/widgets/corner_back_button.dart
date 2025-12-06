import 'package:flutter/material.dart';

class CornerBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;

  const CornerBackButton({
    super.key,
    this.onPressed,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              // "Ku-shaped" (chevron) arrow, thick and easy to see.
              // Icons.arrow_back_ios_new is thicker than arrow_back_ios.
              // Added padding to visually center it in the circle.
              icon: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.arrow_back_ios_new),
              ), 
              color: color == Colors.black ? Colors.black87 : color,
              onPressed: onPressed ?? () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
