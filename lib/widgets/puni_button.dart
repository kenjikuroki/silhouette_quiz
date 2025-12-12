import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class PuniButtonColors {
  static const Color pink = Color(0xFFE91E63);
  static const Color green = Color(0xFF388E3C);
  static const Color blueGrey = Color(0xFF455A64);
}

class PuniButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? height;
  final bool playSound;

  const PuniButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.color = PuniButtonColors.pink,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    this.borderRadius = 30,
    this.height,
    this.playSound = true,
  }) : assert(text != null || child != null,
            'PuniButton requires either text or child.');

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;
    final Widget buttonChild = child ??
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text!,
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
            onTap: disabled
                ? null
                : () {
                    if (playSound) {
                      AudioService.instance.playButtonSound();
                    }
                    onPressed?.call();
                  },
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
