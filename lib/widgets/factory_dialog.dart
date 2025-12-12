import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'sparkle_background.dart';

class FactoryDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final Widget? icon;
  final bool showCongratulationHeader;
  final String? backgroundAsset;
  final Widget? headerImage;
  final bool forceAspectRatio;
  final bool useSparkle;
  final String celebrationTitle;
  final bool hideCelebrationMessage;
  final Color borderColor;
  final double? celebrationFontSize;
  final double? messageFontSize;
  final bool useCelebrationOutline;
  final Color? celebrationTextColor;
  final Color? celebrationOutlineColor;
  final double? titleFontSize;

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
    this.celebrationFontSize,
    this.messageFontSize,
    this.useCelebrationOutline = false,
    this.celebrationTextColor,
    this.celebrationOutlineColor,
    this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate scaling factor based on width
    // Base width around 800 (standard phone landscape).
    // iPad 10.2 is 1080px width (logical).
    // iPad Pro 12.9 is 1366px.
    // Scale will be applied to fonts and padding.
    final double screenWidth = MediaQuery.of(context).size.width;
    // Use shortestSide to correctly identify tablets vs large phones
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double scale = isTablet
        ? (screenWidth / 850).clamp(1.0, 1.4) // Tablet scale (Increased)
        : (screenWidth / 380).clamp(0.8, 1.3); // Phone scale
    final double fontScale = isTablet ? 1.5 : 1.0;

    Widget child = _buildContent(context, scale, fontScale);
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
      insetPadding: EdgeInsets.symmetric(
        horizontal: 24 * scale,
        vertical: 24 * scale,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: child,
      ),
    );
  }

  static Future<T?> showFadeDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, double scale, double fontScale) {
    // Pass scale to layouts
    final Widget inner = showCongratulationHeader
        ? _buildCelebrationLayout(scale, fontScale)
        : _buildStandardLayout(context, scale, fontScale);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundAsset == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(32 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 24 * scale,
            offset: Offset(0, 12 * scale),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32 * scale),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32 * scale),
            border: Border.all(
              color: borderColor,
              width: 6 * scale,
            ),
            image: backgroundAsset != null
                ? DecorationImage(
                    image: AssetImage(backgroundAsset!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.3),
                      BlendMode.lighten,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scale,
              vertical: 10 * scale,
            ),
            child: inner,
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationLayout(double scale, double fontScale) {
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
          scale: scale,
          fontScale: fontScale,
          celebrationFontSize: celebrationFontSize,
          useCelebrationOutline: useCelebrationOutline,
          celebrationTextColor: celebrationTextColor,
          celebrationOutlineColor: celebrationOutlineColor,
        );
      },
    );
  }

  Widget _buildStandardLayout(BuildContext context, double scale, double fontScale) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Hug content vertically
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            // Determine if icon is a simple Icon or Image and try to scale?
            // Since icon is a Widget, we can't easily scale it unless we wrap it.
            // For now, let's wrap in Transform.scale, or just leave it.
            // Often icons are sized explicitly. Let's wrap in scale.
            Transform.scale(scale: scale, child: icon!),
            SizedBox(height: 16 * scale),
          ],
          if (title.isNotEmpty) ...[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (titleFontSize ?? 22) * scale * fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12 * scale),
          ],
          if (message.isNotEmpty) ...[
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (messageFontSize ?? 18) * scale * fontScale,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20 * scale),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            children: actions
                .map(
                  (action) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 * scale),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(scale),
                      ),
                      child: action,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
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
  final double scale;
  final double fontScale;
  final double? celebrationFontSize;
  final bool useCelebrationOutline;
  final Color? celebrationTextColor;
  final Color? celebrationOutlineColor;

  const _CelebrationContent({
    required this.imageHeight,
    required this.headerImage,
    required this.celebrationTitle,
    required this.icon,
    required this.message,
    required this.actions,
    required this.enabledNotifier,
    required this.scale,
    this.fontScale = 1.0,
    this.celebrationFontSize,
    required this.useCelebrationOutline,
    this.celebrationTextColor,
    this.celebrationOutlineColor,
  });

  @override
  Widget build(BuildContext context) {
    // Always use Column for equal spacing
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTitleText(),
        if (headerImage != null)
           _AnimatedCharacterImage(
              child: SizedBox(
                height: imageHeight * 0.55, // Adjusted to prevent overflow (0.65 -> 0.55)
                child: headerImage,
              ),
            ),
        if (icon != null) Transform.scale(scale: scale, child: icon!),
        if (message.isNotEmpty) _buildMessageText(),
        _buildActions(context),
      ],
    );
  }

  Widget _buildTitleText() {
    final fontSize = (celebrationFontSize ?? 24) * scale * fontScale;
    return useCelebrationOutline
        ? _buildOutlineText(
            celebrationTitle,
            fontSize: fontSize,
            strokeWidth: 8 * scale,
            textColor: celebrationTextColor ?? Colors.white,
            strokeColor: celebrationOutlineColor ?? Colors.black,
          )
        : Text(
            celebrationTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: celebrationTextColor ?? Colors.black,
            ),
          );
  }

  Widget _buildMessageText() {
    return _buildOutlineText(
      message,
      fontSize: (celebrationFontSize ?? 24) * scale * fontScale, // Match title size
      strokeWidth: 8 * scale, // Match title stroke
    );
  }

  Widget _buildActions(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: enabledNotifier,
      builder: (BuildContext context, bool enabled, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: actions
              .map(
                (Widget action) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4 * scale),
                  child: AbsorbPointer(
                    absorbing: !enabled,
                    child: Opacity(
                      opacity: enabled ? 1.0 : 0.4,
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(scale),
                        ),
                        child: action,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
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
