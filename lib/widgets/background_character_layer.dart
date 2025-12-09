import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundCharacterLayer extends StatefulWidget {
  final int currentIndex;

  const BackgroundCharacterLayer({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BackgroundCharacterLayer> createState() => _BackgroundCharacterLayerState();
}

class _BackgroundCharacterLayerState extends State<BackgroundCharacterLayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  
  String? _currentAsset;
  Alignment _currentAlignment = Alignment.centerLeft;
  
  final Random _random = Random();
  
  // List of available character images
  // Mixed full-width and half-width numbers based on ls output
  final List<String> _assets = [
    '３.png', '４.png', '５.png', '６.png', '７.png', // Full-width 3-7
    '8.png', '9.png', '11.png', '12.png', // Half-width 8,9,11,12 (No 10)
    '13.png', '14.png', '15.png', '16.png', '17.png', '18.png', '19.png', // Half-width 13-19
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000)); // Slower fade for "fuwatto"
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _updateCharacter();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BackgroundCharacterLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      // Trigger change: Fade out -> Update -> Fade in
      _changeCharacter();
    }
  }

  void _changeCharacter() async {
    await _controller.reverse();
    if (!mounted) return;
    _updateCharacter();
    _controller.forward();
  }

  void _updateCharacter() {
    setState(() {
      // Pick random asset (Ensure no consecutive shuffle if possible)
      String? nextAsset;
      if (_assets.length <= 1) {
        nextAsset = _assets.isNotEmpty ? _assets[0] : null;
      } else {
        do {
          nextAsset = _assets[_random.nextInt(_assets.length)];
        } while (nextAsset == _currentAsset);
      }
      
      _currentAsset = nextAsset;
      
      // Pick random position (Left side or Right side)
      // Avoid center (around -0.3 to 0.3) to keep quiz image clear
      
      final bool isLeft = _random.nextBool();
      // Expanded range:
      // Left: -0.9 to -0.4
      // Right: 0.4 to 0.9
      final double x = isLeft 
          ? -0.4 - (_random.nextDouble() * 0.5) 
          : 0.4 + (_random.nextDouble() * 0.5); 
          
      final double y = -0.2 + (_random.nextDouble() * 0.6); // -0.2 to 0.4
      
      _currentAlignment = Alignment(x, y);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentAsset == null) return const SizedBox.shrink();

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide >= 600;

    return Align(
      alignment: _currentAlignment,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: IgnorePointer(
          child: Image.asset(
            'assets/images/character/$_currentAsset',
            height: isTablet ? 480 : 240,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
               // Fallback if image not found (e.g. filename mismatch)
               return const SizedBox(width: 100, height: 100); 
            },
          ),
        ),
      ),
    );
  }
}
