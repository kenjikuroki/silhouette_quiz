import 'package:flutter/material.dart';

class CenteredLayout extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? maxContentWidth;

  const CenteredLayout({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.maxContentWidth,
  }) : super(key: key);

  static const double defaultMaxWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: backgroundColor,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth ?? defaultMaxWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
