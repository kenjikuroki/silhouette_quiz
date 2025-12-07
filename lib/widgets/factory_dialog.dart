import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'sparkle_background.dart';

class FactoryDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final Widget? icon;
  final bool showCongratulationHeader;
  final String backgroundAsset;
  final Widget? headerImage;
  final bool forceAspectRatio;
  final bool useSparkle;
  final String celebrationTitle;
  final bool hideCelebrationMessage;
  final Color borderColor;

  const FactoryDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
    this.icon,
    this.showCongratulationHeader = false,
    this.backgroundAsset = 'assets/images/character/completion.png',
    this.headerImage,
    this.forceAspectRatio = true,
    this.useSparkle = true,
    this.celebrationTitle = 'よくできました！',
    this.hideCelebrationMessage = false,
    this.borderColor = const Color(0xFF757575),
  });

  @override
  Widget build(BuildContext context) {
    Widget child = _buildContent();
    if (useSparkle) {
      child = SparkleBackground(
        sparkleCount: 30,
        child: child,
      );
    }
    if (forceAspectRatio) {
      child = AspectRatio(
        aspectRatio: 4 / 3,
        child: child,
      );
    }
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: child,
    );
  }

  Widget _buildContent() {
    final Widget inner = showCongratulationHeader
        ? _buildCelebrationLayout()
        : _buildStandardLayout();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: borderColor,
              width: 6,
            ),
            image: DecorationImage(
              image: AssetImage(backgroundAsset),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: inner,
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationLayout() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double imageHeight = constraints.maxHeight * 0.92;
        final ValueNotifier<bool> enabledNotifier = ValueNotifier<bool>(true);
        return _CelebrationContent(
          imageHeight: imageHeight,
          headerImage: headerImage,
          celebrationTitle: celebrationTitle,
          icon: icon,
          message: hideCelebrationMessage ? '' : message,
          actions: actions,
          enabledNotifier: enabledNotifier,
        );
      },
    );
  }

  Widget _buildStandardLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(height: 16),
        ],
        if (title.isNotEmpty) ...[
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: actions
              .map(
                (action) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: 180,
                    child: action,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _CelebrationContent extends StatelessWidget {
  final double imageHeight;
  final Widget? headerImage;
  final String celebrationTitle;
  final Widget? icon;
  final String message;
  final List<Widget> actions;
  final ValueNotifier<bool> enabledNotifier;

  const _CelebrationContent({
    required this.imageHeight,
    required this.headerImage,
    required this.celebrationTitle,
    required this.icon,
    required this.message,
    required this.actions,
    required this.enabledNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (headerImage != null)
          Align(
            alignment: Alignment.center,
            child: _AnimatedCharacterImage(
              child: SizedBox(
                height: imageHeight,
                child: headerImage,
              ),
            ),
          ),
        Align(
            alignment: const Alignment(0, -0.9),
          child: _buildOutlineText(
            celebrationTitle,
            fontSize: 32,
            strokeWidth: 6,
            textColor: Colors.black,
            strokeColor: Colors.white,
          ),
        ),
        if (icon != null)
          Align(
            alignment: const Alignment(0, -0.1),
            child: icon!,
          ),
        if (message.isNotEmpty)
        Align(
          alignment: const Alignment(0, 0.35),
          child: _buildOutlineText(
            message,
            fontSize: 18,
            strokeWidth: 3,
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder<bool>(
            valueListenable: enabledNotifier,
            builder: (BuildContext context, bool enabled, Widget? child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: actions
                    .map(
                      (Widget action) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: SizedBox(
                          width: 180,
                          child: AbsorbPointer(
                            absorbing: !enabled,
                            child: Opacity(
                              opacity: enabled ? 1.0 : 0.4,
                              child: action,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildOutlineText(
  String text, {
  required double fontSize,
  double strokeWidth = 4,
  Color textColor = Colors.white,
  Color strokeColor = Colors.black,
}) {
  final TextStyle baseStyle = TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  return Stack(
    children: [
      Text(
        text,
        textAlign: TextAlign.center,
        style: baseStyle.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = strokeColor,
        ),
      ),
      Text(
        text,
        textAlign: TextAlign.center,
        style: baseStyle,
      ),
    ],
  );
}

class _AnimatedCharacterImage extends StatefulWidget {
  final Widget child;

  const _AnimatedCharacterImage({
    required this.child,
  });

  @override
  State<_AnimatedCharacterImage> createState() =>
      _AnimatedCharacterImageState();
}

class _AnimatedCharacterImageState extends State<_AnimatedCharacterImage>
    with TickerProviderStateMixin {
  late final AnimationController _swayController;
  late final Animation<double> _swayAnimation;
  late final AnimationController _stretchController;
  late final Animation<double> _stretchAnimation;

  @override
  void initState() {
    super.initState();
    _stretchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _stretchAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _stretchController, curve: Curves.easeInOut),
    );

  }

  @override
  void dispose() {
    _stretchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _stretchAnimation,
      alignment: Alignment.bottomCenter,
      child: widget.child,
    );
  }
}
