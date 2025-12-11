import 'dart:math';
import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import '../widgets/puff_route.dart';
import '../widgets/audio_toggle_button.dart';
import '../services/audio_service.dart';
import 'challenge_screen.dart';
import 'create_quiz_intro_screen.dart';
import '../widgets/premium_promotion_dialog.dart';

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
    with TickerProviderStateMixin {
  static const Alignment _initialAlignment = Alignment(0, -5);
  static const Alignment _dropAlignment = Alignment(0, -0.1);

  String _currentCharacterImage = 'assets/images/character/character.png';
  bool _hasChangedCharacter = false;
  Alignment _characterAlignment = _initialAlignment;
  late final AnimationController _shakeController;
  late final AnimationController _swayController;
  late final Animation<double> _swayAnimation;
  // 追加: 縦に伸び縮みするアニメーション用
  late final AnimationController _stretchController;
  late final Animation<double> _stretchAnimation;
  bool _hasRequestedInitialBgm = false;

  bool _isChangingCharacter = false;
  bool _shouldAnimateCharacter = false;
  bool _isChallengePressed = false;
  bool _isCreatePressed = false;

  String _helperCharacterImage = 'assets/images/character/３.png';

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

    _swayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _swayAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
    );
    // 初期状態では揺れない (落ちてから伸び縮み、タップで揺れる)
    // _swayController.repeat(reverse: true);

    // 縦に伸び縮みするアニメーションの初期化
    _stretchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // 1.0 (通常) -> 1.05 (少し伸びる)
    _stretchAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _stretchController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasRequestedInitialBgm) {
        _hasRequestedInitialBgm = true;
        AudioService.instance.playMainBgm();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String languageCode = Localizations.localeOf(context).languageCode;
    
    precacheImage(
        AssetImage(_getChallengeButtonPath(false, languageCode)), context);
    precacheImage(
        AssetImage(_getChallengeButtonPath(true, languageCode)), context);
    precacheImage(
        AssetImage(_getCreateButtonPath(false, languageCode)), context);
    precacheImage(
        AssetImage(_getCreateButtonPath(true, languageCode)), context);
    precacheImage(
        AssetImage(_getBackgroundImagePath(languageCode)), context);
    precacheImage(const AssetImage('assets/images/character/３.png'), context);
    precacheImage(const AssetImage('assets/images/character/４.png'), context);
    precacheImage(const AssetImage('assets/images/character/５.png'), context);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _swayController.dispose();
    _stretchController.dispose();
    super.dispose();
  }

  Alignment _getDropAlignment(String imagePath) {
    bool isTablet = false;
    if (mounted) {
       isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    }

    if (imagePath.contains('hime') ||
        imagePath.contains('kaiju') ||
        imagePath.contains('kuma')) {
      // iPad: Slightly higher than default (-0.1) but lower than Phone (-0.35)
      // Phone: Keep -0.35
      return Alignment(0, isTablet ? -0.15 : -0.35); 
    }
    return _dropAlignment;
  }

  void _changeCharacter() {
    if (_hasChangedCharacter || _isChangingCharacter) return;

    _isChangingCharacter = true;
    _shakeController.repeat(period: const Duration(milliseconds: 140));

    // 伸び縮み停止
    _stretchController.stop();
    _stretchController.reset();

    Future.delayed(const Duration(milliseconds: 800), () {
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
        _characterAlignment = _getDropAlignment(nextImage);
        _shouldAnimateCharacter = false;
        AudioService.instance.playCharacterPopSound();
      });

      // ゆらゆら開始
      _swayController.repeat(reverse: true);

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
      _helperCharacterImage = 'assets/images/character/３.png';
    });
    // アニメーションリセット
    _swayController.stop();
    _swayController.reset();
    _stretchController.stop();
    _stretchController.reset();
  }

  void _dropCharacter() {
    final targetAlign = _getDropAlignment(_currentCharacterImage);
    if (_characterAlignment == targetAlign) return;
    setState(() {
      _characterAlignment = targetAlign;
      _shouldAnimateCharacter = true;
    });
    AudioService.instance.playWhistleSound();
  }

  void _onDropFinished() {
    // 落ちきった後にキャラクターが変更されていなければ伸び縮み開始
    if (!_hasChangedCharacter) {
      _stretchController.repeat(reverse: true);
    }
  }

  Future<void> _onChallengePressed() async {
    if (_isChallengePressed || _isCreatePressed) return;
    setState(() {
      _isChallengePressed = true;
      _helperCharacterImage = 'assets/images/character/４.png';
    });
    AudioService.instance.playChallengeSound();
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
    if (_isCreatePressed || _isChallengePressed) return;

    // Check limit
    final appState = widget.appState;
    if (!appState.isFullVersionPurchased && appState.customQuizSets.length >= 2) {
      await PremiumPromotionDialog.show(context, appState);
      return;
    }

    setState(() {
      _isCreatePressed = true;
      _helperCharacterImage = 'assets/images/character/５.png';
    });
    AudioService.instance.playLeverSound();
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

          const double designWidth = 1024;
          const double designHeight = 768;
          const double challengeLeft = 240;
          const double challengeBottom = 190;
          const double challengeWidth = 360;
          const double createLeft = 490;
          const double createBottom = 220;
          const double createWidth = 280;

          // ★ 画面いっぱいに広がる「cover」と同じ計算に変更（max を使う）
          final double scale = max(w / designWidth, h / designHeight);

          // cover した時の 1024x768 キャンバスが、画面内でどこに来るか
          final double horizontalOffset = (w - designWidth * scale) / 2;
          final double verticalOffset = (h - designHeight * scale) / 2;

          double buttonScale = 1.0;
          double challengeOffsetX = 0;
          double challengeOffsetY = 0;
          double createOffsetX = 0;
          double createOffsetY = 0;

          if (l10n.locale.languageCode == 'es' ||
              l10n.locale.languageCode == 'en') {
            buttonScale = 0.6;
            // Scaleダウン(1.0 -> 0.6)による位置ズレ(左下基準)を補正して「右上」へ寄せる
            // 幅の20%分(中心合わせ) + 微調整
            challengeOffsetX = challengeWidth * 0.2;
            challengeOffsetY = challengeWidth * 0.08;
            createOffsetX = createWidth * 0.2;
            createOffsetY = createWidth * 0.08;
          }

          final double challengeBottomPos =
              verticalOffset + (challengeBottom - 60 + challengeOffsetY) * scale;
          final double createBottomPos =
              verticalOffset + (createBottom - 60 + createOffsetY) * scale;

          return Stack(
            children: [
              Positioned(
                left: horizontalOffset,
                top: verticalOffset,
                width: designWidth * scale,
                height: designHeight * scale,
                child: GestureDetector(
                  onTap: _dropCharacter,
                  child: Image.asset(
                    _getBackgroundImagePath(l10n.locale.languageCode),
                    // ここはもう自前で width/height を指定しているので fill でOK
                    fit: BoxFit.fill,
                  ),
                ),
                ),


              // Helper Character (3/4/5) - Behind buttons
              // 5: Square (668x668) -> Width 420, Left -50
              // 4: Tall (~500x700) -> Width 380, Left -30 (User requested larger & left & slow move)
              // 3: Tall (~500x700) -> Width 320, Left 0 (Default)
              Builder(
                builder: (context) {
                  double targetWidth = 320;
                  double targetLeftOffset = 0;
                  Duration posDuration = Duration.zero;
                  Duration sizeDuration = Duration.zero;
                  
                  if (_helperCharacterImage.contains('５')) {
                    // 5: Large instantly, Moves left slowly
                    targetWidth = 460;
                    targetLeftOffset = -60;
                    posDuration = const Duration(milliseconds: 1000);
                    sizeDuration = Duration.zero;
                  } else if (_helperCharacterImage.contains('４')) {
                    // 4: Grows slowly, No slide (keep Left 0)
                    targetWidth = 380; 
                    targetLeftOffset = 0; // Don't move left to avoid slide
                    posDuration = Duration.zero;
                    sizeDuration = const Duration(milliseconds: 1000);
                  } else {
                    // 3: Reset instantly
                    targetWidth = 320;
                    targetLeftOffset = 0;
                    posDuration = Duration.zero;
                    sizeDuration = Duration.zero;
                  }

                  final double charWidth = targetWidth * scale;
                  final double charLeft = horizontalOffset + targetLeftOffset * scale;
                  final double charBottom = verticalOffset - 30 * scale;

                  return AnimatedPositioned(
                    duration: posDuration,
                    curve: Curves.easeInOut,
                    left: charLeft,
                    bottom: charBottom,
                    child: AnimatedContainer(
                      duration: sizeDuration,
                      curve: Curves.easeInOut,
                      width: charWidth,
                      child: Image.asset(
                        _helperCharacterImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }
              ),

              Positioned(
                left: horizontalOffset + (challengeLeft + challengeOffsetX) * scale,
                bottom: challengeBottomPos,
                child: _buildActionObject(
                  width: challengeWidth * scale * buttonScale,
                  imagePath: _getChallengeButtonPath(
                      _isChallengePressed, l10n.locale.languageCode),
                  semanticsLabel: l10n.homeModeChallenge,
                  onPressed: () => _onChallengePressed(),
                ),
              ),

              Positioned(
                left: horizontalOffset + (createLeft + createOffsetX) * scale,
                bottom: createBottomPos,
                child: _buildActionObject(
                  width: createWidth * scale * buttonScale,
                  imagePath: _getCreateButtonPath(
                      _isCreatePressed, l10n.locale.languageCode),
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
                onEnd: _onDropFinished,
                child: GestureDetector(
                  onTap: _changeCharacter,
                  child: Builder(
                    builder: (context) {
                      final bool isMainCharacter =
                          _currentCharacterImage.contains('character.png');
                      return ScaleTransition(
                        scale: isMainCharacter
                            ? _stretchAnimation
                            : const AlwaysStoppedAnimation(1.0),
                        alignment: Alignment.bottomCenter,
                        child: RotationTransition(
                          turns: (_hasChangedCharacter && isMainCharacter)
                              ? _swayAnimation
                              : const AlwaysStoppedAnimation(0),
                          alignment: Alignment.bottomCenter,
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
                              width: (_currentCharacterImage.contains('hime') ||
                                      _currentCharacterImage.contains('kaiju') ||
                                      _currentCharacterImage.contains('kuma'))
                                  ? w * 0.18
                                  : w * 0.5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
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
    final double hitWidth = buttonWidth * 0.45;
    final double hitHeight = buttonWidth * 0.28;
    return SizedBox(
      width: buttonWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            imagePath,
            width: buttonWidth,
            fit: BoxFit.contain,
          ),
          Semantics(
            button: true,
            label: semanticsLabel,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onPressed,
              child: SizedBox(
                width: hitWidth,
                height: hitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getChallengeButtonPath(bool isPressed, String languageCode) {
    if (languageCode == 'en') {
      return isPressed
          ? 'assets/images/button/button_en/challenge_bo_P_bo_en.png'
          : 'assets/images/button/button_en/challenge_bo_en.png';
    } else if (languageCode == 'es') {
      return isPressed
          ? 'assets/images/button/button_se/challenge_bo_P_se.png'
          : 'assets/images/button/button_se/challenge_bo_se.png';
    } else {
      return isPressed
          ? 'assets/images/button/challenge_bo_P.png'
          : 'assets/images/button/challenge_bo.png';
    }
  }

  String _getCreateButtonPath(bool isPressed, String languageCode) {
    if (languageCode == 'en') {
      // For English, Left is pressed, Right is normal
      return isPressed
          ? 'assets/images/button/button_en/myself_left_bo_en.png'
          : 'assets/images/button/button_en/myself_right_bo_en.png';
    } else if (languageCode == 'es') {
      // For Spanish, Left is pressed, Right is normal
      return isPressed
          ? 'assets/images/button/button_se/myself_left_bo_se.png'
          : 'assets/images/button/button_se/myself_right_bo_se.png';
    } else {
      // Default
      return isPressed
          ? 'assets/images/button/myself_left_bo.png'
          : 'assets/images/button/myself_right_bo.png';
    }
  }

  String _getBackgroundImagePath(String languageCode) {
    if (languageCode == 'en') {
      return 'assets/images/backgrounds/background_en.png';
    } else if (languageCode == 'es') {
      return 'assets/images/backgrounds/background_se.png';
    } else {
      return 'assets/images/backgrounds/background.png';
    }
  }
}
