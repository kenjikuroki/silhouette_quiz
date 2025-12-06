import 'package:flutter/material.dart';

class FactoryPlateCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const FactoryPlateCard({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // "Very light grey"
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Content with padding to avoid overlapping screws
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: child,
            ),
            // Screws (Rivets)
            // Top Left
            const Positioned(
              top: 4,
              left: 4,
              child: _Screw(),
            ),
            // Top Right
            const Positioned(
              top: 4,
              right: 4,
              child: _Screw(),
            ),
            // Bottom Left
            const Positioned(
              bottom: 4,
              left: 4,
              child: _Screw(),
            ),
            // Bottom Right
            const Positioned(
              bottom: 4,
              right: 4,
              child: _Screw(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Screw extends StatelessWidget {
  const _Screw();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle,
          // "A little bigger" -> Increased from 8 to 13
          size: 13,
          color: Colors.grey[300],
        ),
        // Minus driver mark
        Container(
          width: 8,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}
