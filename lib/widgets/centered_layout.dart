import 'package:flutter/material.dart';

class CenteredLayout extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const CenteredLayout({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  static const double maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: backgroundColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
