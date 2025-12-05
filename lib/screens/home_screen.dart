import 'dart:math';
import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import 'challenge_screen.dart';
import 'create_quiz_intro_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  final QuizAppState appState;

  const HomeScreen({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const Alignment _initialAlignment = Alignment(0, -5);
  static const Alignment _dropAlignment = Alignment(0, -0.1);

  String _currentCharacterImage = 'assets/images/character/character.png';
  bool _hasChangedCharacter = false;
  Alignment _characterAlignment = _initialAlignment;
  late final AnimationController _shakeController;
  bool _isChangingCharacter = false;
  bool _shouldAnimateCharacter = false;
  bool _isChallengePressed = false;
  bool _isCreatePressed = false;

  final List<String> _characterImages = [
    'assets/images/character/character.png',
    'assets/images/character/hime.png',
    'assets/images/character/kaiju.png',
    'assets/images/character/kuma.png',
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _changeCharacter() {
    if (_hasChangedCharacter || _isChangingCharacter) return;

    _isChangingCharacter = true;
    _shakeController.repeat(period: const Duration(milliseconds: 140));

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      _shakeController.stop();
      _shakeController.reset();

      setState(() {
        final random = Random();
        String nextImage;
        do {
          nextImage =
              _characterImages[random.nextInt(_characterImages.length)];
        } while (nextImage == _currentCharacterImage);
        _currentCharacterImage = nextImage;
        _hasChangedCharacter = true;
        _characterAlignment = _dropAlignment;
        _shouldAnimateCharacter = false;
      });

      _isChangingCharacter = false;
    });
  }

  void _resetCharacter() {
    setState(() {
      _currentCharacterImage = 'assets/images/character/character.png';
      _hasChangedCharacter = false;
      _characterAlignment = _initialAlignment;
      _shouldAnimateCharacter = false;
      _isChallengePressed = false;
      _isCreatePressed = false;
    });
  }

  void _dropCharacter() {
    setState(() {
      _characterAlignment = _dropAlignment;
      _shouldAnimateCharacter = true;
    });
  }

  Future<void> _onChallengePressed() async {
    if (_isChallengePressed) return;
    setState(() {
      _isChallengePressed = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await Navigator.of(context)
        .pushNamed(ChallengeScreen.routeName)
        .then((_) {
      if (mounted) {
        _resetCharacter();
      }
    });
  }

  Future<void> _onCreatePressed() async {
    if (_isCreatePressed) return;
    setState(() {
      _isCreatePressed = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await Navigator.of(context)
        .pushNamed(CreateQuizIntroScreen.routeName)
        .then((_) {
      if (mounted) {
        _resetCharacter();
      }
    });
  }

  QuizAppState get appState => widget.appState;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _dropCharacter,
                  child: Image.asset(
                    'assets/images/backgrounds/factoryBackground.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              Positioned(
                left: w * 0.16,
                bottom: h * 0.20,
                child: _buildActionObject(
                  width: w * 0.52,
                  imagePath: _isChallengePressed
                      ? 'assets/images/button/challenge_bo_P.png'
                      : 'assets/images/button/challenge_bo.png',
                  semanticsLabel: l10n.homeModeChallenge,
                  onPressed: () => _onChallengePressed(),
                ),
              ),

              Positioned(
                right: w * 0.20,
                bottom: h * 0.24,
                child: _buildActionObject(
                  width: w * 0.40,
                  imagePath: _isCreatePressed
                      ? 'assets/images/button/myself_left_bo.png'
                      : 'assets/images/button/myself_right_bo.png',
                  semanticsLabel: l10n.homeModeCreate,
                  onPressed: () => _onCreatePressed(),
                ),
              ),



              // ② キャラクター（最前面、少し小さく）
              // アニメーションで落ちてくる
              AnimatedAlign(
                duration: _shouldAnimateCharacter
                    ? const Duration(milliseconds: 1800)
                    : Duration.zero,
                curve: Curves.easeOutCubic,
                alignment: _characterAlignment,
                child: GestureDetector(
                  onTap: _changeCharacter,
                  child: AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final double dx =
                          sin(_shakeController.value * 2 * pi) * 8;
                      return Transform.translate(
                        offset: Offset(dx, 0),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      _currentCharacterImage,
                      width: w * 0.5, // 0.635 -> 0.5 に縮小
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionObject({
    required double width,
    required String imagePath,
    required String semanticsLabel,
    required VoidCallback onPressed,
  }) {
    final double buttonWidth = width;
    final double tapWidth = width * 0.6;
    return SizedBox(
      width: buttonWidth,
      height: buttonWidth * 0.6,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: tapWidth,
          height: tapWidth * 0.55,
          child: Semantics(
            button: true,
            label: semanticsLabel,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPressed,
              child: Image.asset(
                imagePath,
                width: buttonWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
