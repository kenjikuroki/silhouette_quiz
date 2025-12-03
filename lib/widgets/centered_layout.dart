import 'package:flutter/material.dart';

class CenteredLayout extends StatelessWidget {
  final Widget child;

  const CenteredLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  static const double maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: Colors.white, // TODO: 後で背景をいい感じに
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
