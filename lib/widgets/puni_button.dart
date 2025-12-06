import 'package:flutter/material.dart';

class PuniButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? height;

  const PuniButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.color = const Color(0xFFEE4E8B),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    this.borderRadius = 30,
    this.height,
  }) : assert(text != null || child != null,
            'PuniButton requires either text or child.');

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;
    final Widget buttonChild = child ??
        Text(
          text!,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: disabled ? 0.45 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius + 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height ?? 0),
              child: Padding(
                padding: padding,
                child: Center(child: buttonChild),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
