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
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: color,
            onPressed: onPressed ?? () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }
}
