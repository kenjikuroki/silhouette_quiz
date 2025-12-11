import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../services/silhouette_service.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puni_button.dart';
import '../widgets/factory_dialog.dart';
import '../services/audio_service.dart';
import '../widgets/sparkle_background.dart';
import '../widgets/background_character_layer.dart';

class PlayQuizArguments {
  final String quizSetId;

  PlayQuizArguments({
    required this.quizSetId,
  });
}

class PlayQuizScreen extends StatefulWidget {
  static const String routeName = '/play_quiz';

  final QuizAppState appState;
  final String quizSetId;

  const PlayQuizScreen({
    Key? key,
    required this.appState,
    required this.quizSetId,
  }) : super(key: key);

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final Set<int> _revealedIndices = {}; // Indices where answer is shown
  final Set<int> _answeredIndices = {}; // Indices where user answered (buttons disabled)
  int _correctCount = 0;
  bool _markedViewed = false;
  bool _isImageSettled = false;

  late PageController _pageController;
  late AnimationController _initialSlideController;
  late Animation<Offset> _initialSlideAnimation;
  late AnimationController _conveyorController;
  
  List<QuizQuestion> _questions = []; // Local shuffled copy

  QuizAppState get appState => widget.appState;

  SilhouetteService get silhouetteService => appState.silhouetteService;

  @override
  void initState() {
    super.initState();
    AudioService.instance.playQuizBgm();
    _pageController = PageController();

    // Initial slide-in animation (Right to Center)
    _initialSlideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _initialSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _initialSlideController,
      curve: Curves.easeInOut,
    ));
    _initialSlideController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _isImageSettled = true;
        });
      }
    });

    // Conveyor vibration controller
    _conveyorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start the initial animations
    _initialSlideController.forward();
    _conveyorController.forward();

    // Load and shuffle questions
    final QuizSet? quizSet = appState.findQuizSetById(widget.quizSetId);
    if (quizSet != null && quizSet.questions.isNotEmpty) {
      _questions = List<QuizQuestion>.from(quizSet.questions)..shuffle();
      if (_questions.length > 5) {
        _questions = _questions.sublist(0, 5);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final QuizSet? set = appState.findQuizSetById(widget.quizSetId);
      if (!_markedViewed && set != null && set.isCustom) {
        appState.markQuizAsViewed(set.id);
        _markedViewed = true;
      }
    });
  }

  @override
  void dispose() {
    AudioService.instance.playMainBgm();
    _pageController.dispose();
    _initialSlideController.dispose();
    _conveyorController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);


    // Use local shuffled questions
    if (_questions.isEmpty) {
      return Scaffold(
        body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;
          const double designWidth = 1024;
          const double designHeight = 768;
          final double scale = Math.max(w / designWidth, h / designHeight);
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
                  'assets/images/backgrounds/background_quiz.png',
                  fit: BoxFit.fill,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/conveyor.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Text(l10n.playQuizNotFound),
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

    final bool isLast = _currentIndex == _questions.length - 1;
    final bool currentAnswerRevealed =
        _revealedIndices.contains(_currentIndex);
    final bool hasCurrentAnswered =
        _answeredIndices.contains(_currentIndex);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;
          const double designWidth = 1024;
          const double designHeight = 768;
          final double scale = Math.max(w / designWidth, h / designHeight);
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
                  'assets/images/backgrounds/background_quiz.png',
                  fit: BoxFit.fill,
                ),
              ),
              BackgroundCharacterLayer(currentIndex: _currentIndex),
              Positioned(
                left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _conveyorController,
              builder: (context, child) {
                // Simple vibration logic: sin wave
                // 10 cycles over 2 seconds, amplitude 3.0
                final double offset = 
                    Math.sin(_conveyorController.value * 2 * Math.pi * 10) * 3.0;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/conveyor.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            bottom: false, // Allow overlap with conveyor
            child: Stack(
              children: [
                CenteredLayout(
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 0, // No bottom padding to allow overlap
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_currentIndex + 1} / ${_questions.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: OverflowBox(
                            maxWidth: MediaQuery.of(context).size.width,
                            minWidth: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _questions.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                              final question = _questions[index];
                              final bool showAnswer = _revealedIndices.contains(index);
                              final bool hasAnswered = _answeredIndices.contains(index);

                              // 画面サイズに応じてクイズ画像の最大サイズを調整
                              final Size screenSize = MediaQuery.of(context).size;
                              final double shortestSide = screenSize.shortestSide;
                              // 画面の短辺の 60% をベースにして、最小300〜最大520にクランプ
                              final double baseSize = shortestSide * 0.6;
                              final double visualSize =
                                  baseSize.clamp(300.0, 520.0);

                              Widget content = Align(
                                alignment: Alignment.bottomCenter,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: visualSize,
                                    maxHeight: visualSize,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                  child: _buildQuestionVisual(
                                    context,
                                    question,
                                    showOriginalImage: showAnswer,
                                  ),
                                  ),
                                ),
                              );

                              // Apply initial slide-in only for the first item
                              if (index == 0) {
                                return SlideTransition(
                                  position: _initialSlideAnimation,
                                  child: content,
                                );
                              }
                              return content;
                            },
                          ), // PageView
                        ), // OverflowBox
                      ), // Expanded
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 60,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: !currentAnswerRevealed
                                ? (_isImageSettled
                                    ? Center(
                                        key: ValueKey<int>(
                                            _currentIndex),
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 220),
                                          child: PuniButton(
                                            text: l10n.playQuizShowAnswer,
                                            color: PuniButtonColors.green,
                                            height: 44,
                                            onPressed: () {
                                              setState(() {
                                                _revealedIndices
                                                    .add(_currentIndex);
                                                _answeredIndices.remove(
                                                    _currentIndex);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink())
                                : Row(
                                    key: ValueKey<String>(
                                        'judge_buttons_$_currentIndex'),
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                          child: PuniButton(
                                            text: l10n.playQuizIncorrect,
                                            color: PuniButtonColors.blueGrey,
                                            height: 44,
                                            playSound: false,
                                            onPressed: hasCurrentAnswered
                                                ? null
                                                : () {
                                                    AudioService.instance
                                                        .playWrongSound();
                                                    _onSelfJudge(
                                                      context,
                                                      isCorrect: false,
                                                    );
                                                  },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                          child: PuniButton(
                                            text: l10n.playQuizCorrect,
                                            color: PuniButtonColors.pink,
                                            height: 44,
                                            playSound: false,
                                            onPressed: hasCurrentAnswered
                                                ? null
                                                : () {
                                                    AudioService.instance
                                                        .playClearSound();
                                                    _onSelfJudge(
                                                      context,
                                                      isCorrect: true,
                                                    );
                                                  },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16), // Adjusted to lower buttons
                      ],
                    ),
                  ),
                ),
                // Independent Answer Text Overlay
                Positioned(
                  top: 80, // Moved up from 100
                  left: 24,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: currentAnswerRevealed
                        ? Container(
                            key: ValueKey('answer_$_currentIndex'),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: _buildFormattedAnswer(
                              context,
                              _questions[_currentIndex].answerText,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
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

  Widget _buildFormattedAnswer(BuildContext context, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final List<String> parts = text.split('|');
    final String localeCode = Localizations.localeOf(context).languageCode;

    Text _large(String value) => Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        );

    Text _small(String value) => Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        );

    if (localeCode == 'en') {
      final String english =
          parts.length > 2 ? parts[2] : parts.last;
      return _large(english);
    }

    if (localeCode == 'es') {
      final String spanish = parts.length > 3
          ? parts[3]
          : (parts.length > 2 ? parts[2] : parts.first);
      final String? english = parts.length > 2 ? parts[2] : null;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _large(spanish),
          if (english != null) _small(english),
        ],
      );
    }

    if (parts.length == 1) {
      return _large(parts.first);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _large(parts[0]),
        if (parts.length > 1) _small(parts[1]),
        if (parts.length > 2) _large(parts[2]),
      ],
    );
  }

  /// シルエット表示
  /// - 答え表示前: シルエット画像を優先
  /// - 答え表示時: 元の写真を優先（なければシルエット）
  Widget _buildQuestionVisual(
    BuildContext context,
    QuizQuestion question, {
    required bool showOriginalImage,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    String? path;
    if (showOriginalImage && (question.originalImagePath?.isNotEmpty == true)) {
      path = question.originalImagePath;
    } else if (question.silhouetteImagePath?.isNotEmpty == true) {
      path = question.silhouetteImagePath;
    } else {
      path = question.originalImagePath;
    }

    // Check for Asset path
    if (path != null && path.startsWith('assets/')) {
       final imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.transparent, 
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
               return Container(
                decoration: BoxDecoration(
                  color: silhouetteService.randomSilhouetteColor(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).imageLoadError,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      );
      
      return imageWidget;
    }

    // Check for File path
    bool hasFile = false;
    if (path != null && path.isNotEmpty) {
      try {
        hasFile = File(path).existsSync();
      } catch (e) {
        // パスが無効な場合などはファイルなしとみなす
        hasFile = false;
      }
    }

    if (hasFile) {
      final File file = File(path!);
      final imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          // Background removed for transparency
          child: Image.file(
            file,
            fit: BoxFit.contain,
          ),
        ),
      );
      return imageWidget;
    }

    // デフォルトクイズ用（画像がない場合）
    return Container(
      decoration: BoxDecoration(
        color: silhouetteService.randomSilhouetteColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          l10n.playQuizPlaceholderTitle(_currentIndex + 1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }



  Future<void> _onSelfJudge(
    BuildContext context, {
    required bool isCorrect,
  }) async {
    // 正解数カウント
    if (isCorrect) {
      _correctCount++;
    }

    _answeredIndices.add(_currentIndex);

    // 次へ進む判定
    final bool isLast = _currentIndex == _questions.length - 1;
    if (isLast) {
      _finishQuiz(context);
    } else {
      setState(() {
        _isImageSettled = false;
      });

      final Future<void> pageTransition = _pageController.nextPage(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
      // 2秒かけて次の問題へスライド
      _conveyorController.forward(from: 0);

      await pageTransition;
      if (!mounted) {
        return;
      }
      setState(() {
        _isImageSettled = true;
      });
      // コンベアも振動させる
    }
  }

  void _finishQuiz(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int total = _questions.length;
    final String message = l10n.playQuizResultMessage(_correctCount, total);

    AudioService.instance.playCheerSound();

    FactoryDialog.showFadeDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return FactoryDialog(
          title: l10n.playQuizResultTitle,
          message: message,
          showCongratulationHeader: true,
          backgroundAsset: 'assets/images/character/result.png',
          borderColor: const Color(0xFFE49A00),
          celebrationTitle: l10n.playQuizCelebrationTitle,
          celebrationFontSize: 20,
          useCelebrationOutline: true,
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (int index) {
              final bool filled = index < _correctCount;
              final Color fillColor = filled
                  ? const Color(0xFFFFF176)
                  : Colors.white.withOpacity(0.8);
              final IconData fillIcon = Icons.star;
              final IconData outlineIcon = Icons.star_border;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 54,
                    ),
                    Icon(
                      filled ? fillIcon : outlineIcon,
                      color: fillColor,
                      size: 34,
                    ),
                  ],
                ),
              );
            }),
          ),
          actions: [
            SizedBox(
              width: 160,
              child: PuniButton(
                text: l10n.commonOk,
                color: PuniButtonColors.pink,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
