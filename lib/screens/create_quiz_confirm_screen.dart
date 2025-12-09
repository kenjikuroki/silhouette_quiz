import 'dart:math';
import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puni_button.dart';
import '../widgets/factory_dialog.dart';
import '../services/audio_service.dart';
import 'challenge_screen.dart';

class CreateQuizConfirmArguments {
  final List<QuizQuestion> tempQuestions;

  CreateQuizConfirmArguments({
    required this.tempQuestions,
  });
}

class CreateQuizConfirmScreen extends StatefulWidget {
  static const String routeName = '/create_confirm';

  final QuizAppState appState;
  final List<QuizQuestion> tempQuestions;

  const CreateQuizConfirmScreen({
    Key? key,
    required this.appState,
    required this.tempQuestions,
  }) : super(key: key);

  @override
  State<CreateQuizConfirmScreen> createState() =>
      _CreateQuizConfirmScreenState();
}

class _CreateQuizConfirmScreenState extends State<CreateQuizConfirmScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  bool _defaultTitleApplied = false;
  bool _isSaving = false;
  bool _buttonsEnabled = false;
  bool _buttonsLocked = false;
  bool _fallSoundPlayed = false;

  late AnimationController _boxDropController;
  late Animation<Offset> _boxDropAnimation;

  late AnimationController _boxSlideController;
  late Animation<Offset> _boxSlideAnimation;

  late AnimationController _conveyorShakeController;
  late Animation<Offset> _conveyorShakeAnimation;

  late AnimationController _characterFadeController;
  late Animation<double> _characterFadeAnimation;

  late AnimationController _lieSlideController;
  late Animation<Offset> _lieSlideAnimation;

  QuizAppState get appState => widget.appState;

  @override
  void initState() {
    super.initState();

    // Box Drop: 1.3s
    _boxDropController = AnimationController(
       duration: const Duration(milliseconds: 1300),
       vsync: this,
    );
    _boxDropAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)), // Fall
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05))
            .chain(CurveTween(curve: Curves.easeOut)), // Small bounce up
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)), // Land back
        weight: 15,
      ),
    ]).animate(_boxDropController);

    _boxDropController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.forward && _boxDropController.value == 0) {
        AudioService.instance.playWhistleSound();
      }
      if (status == AnimationStatus.dismissed) {
        _fallSoundPlayed = false;
      }
    });

    _boxDropController.addListener(() {
      if (!_fallSoundPlayed && _boxDropController.value >= 0.75) {
        _fallSoundPlayed = true;
        AudioService.instance.playFallBoxSound();
      }
    });

    // Box Slide (Exit): 2s
    _boxSlideController = AnimationController(
       duration: const Duration(milliseconds: 3600), // Adjusted to match lie.png speed
       vsync: this,
    );
    _boxSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0), // Slide off-screen right
    ).animate(CurvedAnimation(
      parent: _boxSlideController,
      curve: Curves.easeInOut,
    ));

    // Conveyor Shake: 0.1s (repeating)
    _conveyorShakeController = AnimationController(
       duration: const Duration(milliseconds: 100),
       vsync: this,
    );
    _conveyorShakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.05), // Small vertical shake
    ).animate(_conveyorShakeController);

    // Character Fade (8.png): 0.8s
    _characterFadeController = AnimationController(
       duration: const Duration(milliseconds: 800),
       vsync: this,
    );
    _characterFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _characterFadeController, curve: Curves.easeInOut),
    );

    // Lie Slide (lie.png): 2.5s (Slower/Longer to cross screen)
    _lieSlideController = AnimationController(
       duration: const Duration(milliseconds: 5000),
       vsync: this,
    );
    _lieSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0), // Start from left off-screen/edge
      end: const Offset(1.5, 0),   // End right off-screen
    ).animate(CurvedAnimation(
      parent: _lieSlideController,
      curve: Curves.easeInOut,
    ));

    // Start drop animation with 0.5s delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fallSoundPlayed = false;
        _boxDropController.forward().whenComplete(() {
          if (mounted) {
            setState(() {
              _buttonsEnabled = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _boxDropController.dispose();
    _boxSlideController.dispose();
    _conveyorShakeController.dispose();
    _characterFadeController.dispose();
    _lieSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (!_defaultTitleApplied) {
      final int defaultNumber = widget.appState.customQuizSets.length + 1;
      final String defaultTitle =
          l10n.createConfirmDefaultTitle(defaultNumber);
      _titleController.text = defaultTitle;
      _titleController.selection =
          TextSelection.fromPosition(TextPosition(offset: defaultTitle.length));
      _defaultTitleApplied = true;
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;
          const double designWidth = 1024;
          const double designHeight = 768;
          final double scale = max(w / designWidth, h / designHeight);
          final double horizontalOffset = (w - designWidth * scale) / 2;
          final double verticalOffset = (h - designHeight * scale) / 2;

          return Stack(
            children: [
              Positioned(
                left: horizontalOffset,
                top: verticalOffset,
                width: designWidth * scale,
                height: designHeight * scale,
                child: Image.asset(
                  'assets/images/backgrounds/background_name.png',
                  fit: BoxFit.fill,
                ),
              ),
              // 8.png (Behind conveyor, Right side)
              Positioned(
                bottom: h * 0.15, // Adjust vertical position
                right: w * 0.1,  // Right side
                height: h * 0.6, // Size (Doubled)
                child: FadeTransition(
                  opacity: _characterFadeAnimation,
                  child: Image.asset(
                    'assets/images/character/8.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          // Removed piping.png
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _conveyorShakeAnimation,
              child: Image.asset(
                'assets/images/conveyor_y.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // lie.png (Moved to be ABOVE/After conveyor)
          Positioned(
            bottom: h * 0.12, // Same vertical pos
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _lieSlideAnimation,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'assets/images/character/lie.png',
                  height: h * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: Center(
              child: SlideTransition(
                position: _boxSlideAnimation, // Apply slide right AFTER drop
                child: SlideTransition(
                  position: _boxDropAnimation, // Apply drop
                  child: Image.asset(
                    'assets/images/box.png',
                    width: MediaQuery.of(context).size.width * 0.95,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Content: Message
                              Column(
                                children: [
                                  // const SizedBox(height: 16), // Removed to move higher
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      l10n.createConfirmMessage,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Bottom Content: Input and Buttons
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Narrow Input Field (Widened per request)
                                  SizedBox(
                                    width: 320, // Increased from 240
                                    child: TextField(
                                      controller: _titleController,
                                      maxLength: 20,
                                      decoration: InputDecoration(
                                        labelText: l10n.createConfirmTitleLabel,
                                        counterText: '',
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: PuniButton(
                                          onPressed: _buttonsEnabled && !_buttonsLocked
                                              ? () {
                                                  setState(() {
                                                    _buttonsLocked = true;
                                                  });
                                                  Navigator.of(context)
                                                      .pop();
                                                }
                                              : null,
                                          color: PuniButtonColors.blueGrey,
                                          textColor: Colors.white,
                                          child: Text(
                                            l10n.createConfirmBackButton,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          height: 48,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      SizedBox(
                                        width: 160,
                                        child: PuniButton(
                                          color: PuniButtonColors.pink,
                                          textColor: Colors.white,
                                          onPressed: _isSaving || !_buttonsEnabled || _buttonsLocked
                                              ? null
                                              : () async {
                                                  final String title =
                                                      _titleController.text
                                                          .trim();
                                                  if (title.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(l10n
                                                            .createConfirmTitleLabel),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  setState(() {
                                                    _isSaving = true;
                                                    _buttonsLocked = true;
                                                  });

                                                  try {
                                                    _conveyorShakeController
                                                        .repeat(reverse: true);
                                                    _boxSlideController
                                                        .forward();
                                                    _characterFadeController
                                                        .forward();
                                                    _lieSlideController
                                                        .forward();

                                                    await Future.wait([
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 2)),
                                                      appState
                                                          .addCustomQuizSet(
                                                        title: title,
                                                        questions: widget
                                                            .tempQuestions,
                                                      ),
                                                    ]);

                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    _conveyorShakeController
                                                        .stop();
                                                    _conveyorShakeController
                                                        .reset();

                                                  AudioService.instance
                                                      .playCheerSound();

                                                  await FactoryDialog
                                                      .showFadeDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false,
                                                    builder:
                                                        (dialogContext) {
                                                      return FactoryDialog(
                                                        title: l10n
                                                            .createConfirmCompleteTitle,
                                                        message: l10n
                                                            .createConfirmCompleteMessage,
                                                        headerImage:
                                                            Image.asset(
                                                          'assets/images/character/character.png',
                                                          height: 96,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        showCongratulationHeader:
                                                            true,
                                                        backgroundAsset:
                                                            'assets/images/character/completion.png',
                                                        celebrationTitle:
                                                            'かんせい！',
                                                        hideCelebrationMessage:
                                                            true,
                                                        useCelebrationOutline: true,
                                                        celebrationTextColor: Colors.white,
                                                        celebrationOutlineColor: Colors.black,
                                                        useSparkle: false,
                                                        actions: [
                                                          SizedBox(
                                                            width: 160,
                                                            child: PuniButton(
                                                              text: l10n.commonOk,
                                                              color: PuniButtonColors.pink,
                                                              onPressed: () {
                                                                Navigator.of(dialogContext).pop();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                        );
                                                      },
                                                    );

                                                    if (!mounted) return;

                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                      ChallengeScreen
                                                          .routeName,
                                                      (route) =>
                                                          route.isFirst,
                                                    );
                                                  } catch (e) {
                                                    debugPrint(
                                                        'Error saving quiz: $e');
                                                    if (mounted) {
                                                      setState(() {
                                                        _isSaving = false;
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Error: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                    },
                                              height: 48,
                                              child: _isSaving
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Text(
                                                      l10n.createConfirmSaveButton,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                    ],
                                  ),
                                  const SizedBox(height: 0), // Moved lower (was 10)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const CornerBackButton(),
              ],
            ),
          ),
        ],
          );
        },
      ),
    );
  }
}
