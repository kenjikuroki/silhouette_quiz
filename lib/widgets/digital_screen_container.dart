import 'package:flutter/material.dart';

class DigitalScreenContainer extends StatelessWidget {
  final Widget child;
  // Slightly bluish white for backlight feel
  final Color backlightColor;
  final double borderRadius;

  const DigitalScreenContainer({
    Key? key,
    required this.child,
    this.backlightColor = const Color(0xFFF0F8FF), // AliceBlue
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backlightColor,
        borderRadius: BorderRadius.circular(borderRadius),
        // Bezel (Frame) - using a simple border for now
        border: Border.all(
          color: Colors.grey[400]!,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 2), // Adjust for border width
        child: Stack(
          children: [
            // Content
            child,
            
            // Inner Shadow overlays
            // Top Shadow
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 12, // Depth of shadow
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Shadow
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 12,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Left Shadow
             Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: 12,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Right Shadow
             Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 12,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
