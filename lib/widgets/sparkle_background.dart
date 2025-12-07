import 'dart:math';

import 'package:flutter/material.dart';

class SparkleBackground extends StatefulWidget {
  final Widget child;
  final int sparkleCount;

  const SparkleBackground({
    super.key,
    required this.child,
    this.sparkleCount = 12,
  });

  @override
  State<SparkleBackground> createState() => _SparkleBackgroundState();
}

class _SparkleBackgroundState extends State<SparkleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_SparkleData> _sparkles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _sparkles = List<_SparkleData>.generate(
      widget.sparkleCount,
      (_) => _SparkleData(
        top: _random.nextDouble() * 1.4 - 0.2,
        left: _random.nextDouble() * 1.4 - 0.2,
        baseSize: 6 + _random.nextDouble() * 16,
        baseOpacity: 0.3 + _random.nextDouble() * 0.7,
        rotationSpeed: _random.nextDouble() * 2 - 1,
        floatDistance: 10 + _random.nextDouble() * 20, // 10-30px range
        floatOffset: _random.nextDouble() * 2 * pi,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                child!,
                ..._sparkles.map((sparkle) {
                  final double progress =
                      (_controller.value + sparkle.rotationSpeed).abs() % 1.0;
                  final double opacity = sparkle.baseOpacity *
                      (0.5 + 0.5 * sin(progress * 2 * pi));
                  final double size = sparkle.baseSize *
                      (0.7 + 0.3 * sin(progress * 2 * pi));

                  final double dx = sparkle.floatDistance *
                      sin((progress * 2 * pi) + sparkle.floatOffset);
                  final double dy = sparkle.floatDistance *
                      cos((progress * 2 * pi) + sparkle.floatOffset);

                  return Positioned(
                    top: (sparkle.top * height) + dy,
                    left: (sparkle.left * width) + dx,
                    child: IgnorePointer(
                      child: Transform.rotate(
                        angle: progress * 2 * pi,
                        child: Opacity(
                          opacity: opacity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.35),
                                  blurRadius: 8,
                                  spreadRadius: -1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                              size: size,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SparkleData {
  _SparkleData({
    required this.top,
    required this.left,
    required this.baseSize,
    required this.baseOpacity,
    required this.rotationSpeed,
    required this.floatDistance,
    required this.floatOffset,
  });

  final double top;
  final double left;
  final double baseSize;
  final double baseOpacity;
  final double rotationSpeed;
  final double floatDistance;
  final double floatOffset;
}
