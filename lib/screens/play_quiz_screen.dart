import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../services/silhouette_service.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puni_button.dart';

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
    }
  }

  @override
  void dispose() {
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
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgrounds/background_quiz.png',
                fit: BoxFit.cover,
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
                children: const [
                  Center(
                    child: Text('クイズが みつかりません'),
                  ),
                  CornerBackButton(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final bool isLast = _currentIndex == _questions.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/background_quiz.png',
              fit: BoxFit.cover,
            ),
          ),
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
                              
                              Widget content = Align(
                                alignment: Alignment.bottomCenter,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    maxHeight: 300,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: _buildQuestionVisual(
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
                          height: 80,
                          child: !_revealedIndices.contains(_currentIndex)
                              ? Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 240),
                                    child: PuniButton(
                                      text: l10n.playQuizShowAnswer,
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          _revealedIndices.add(_currentIndex);
                                          _answeredIndices.remove(_currentIndex);
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: PuniButton(
                                          text: l10n.playQuizCorrect,
                                          color: Colors.pink,
                                          onPressed: () => _onSelfJudge(
                                            context,
                                            isCorrect: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: PuniButton(
                                          text: l10n.playQuizIncorrect,
                                          color: Colors.blueGrey,
                                          onPressed: () => _onSelfJudge(
                                            context,
                                            isCorrect: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Independent Answer Text Overlay
                Positioned(
                  top: 100,
                  left: 80,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _revealedIndices.contains(_currentIndex)
                        ? Container(
                            key: ValueKey('answer_$_currentIndex'),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _questions[_currentIndex].answerText ?? '',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
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
      ),
    );
  }

  /// シルエット表示
  /// - 答え表示前: シルエット画像を優先
  /// - 答え表示時: 元の写真を優先（なければシルエット）
  Widget _buildQuestionVisual(
    QuizQuestion question, {
    required bool showOriginalImage,
  }) {
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
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
               return Container(
                decoration: BoxDecoration(
                  color: silhouetteService.randomSilhouetteColor(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Image Load Error', style: TextStyle(color: Colors.white)),
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
          color: Colors.grey[300], // グレー背景で白いシルエットを見やすく
          child: Image.file(
            file,
            fit: BoxFit.cover,
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
          'シルエット ${_currentIndex + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }



  void _onSelfJudge(
    BuildContext context, {
    required bool isCorrect,
  }) {
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
      // 2秒かけて次の問題へスライド
      _pageController.nextPage(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
      // コンベアも振動させる
      _conveyorController.forward(from: 0);
    }
  }

  void _finishQuiz(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int total = _questions.length;
    final String message = l10n.playQuizResultMessage(_correctCount, total);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.playQuizResultTitle),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログ閉じる
                Navigator.of(context).pop(); // クイズ画面を閉じる
              },
              child: Text(l10n.commonOk),
            ),
          ],
        );
      },
    );
  }
}
