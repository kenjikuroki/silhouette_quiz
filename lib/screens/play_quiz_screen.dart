import 'dart:io';

import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../services/silhouette_service.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';

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

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _hasAnsweredCurrent = false;
  int _correctCount = 0;

  QuizAppState get appState => widget.appState;
  SilhouetteService get silhouetteService => appState.silhouetteService;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final QuizSet? quizSet = appState.findQuizSetById(widget.quizSetId);

    if (quizSet == null || quizSet.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.playQuizTitle),
        ),
        body: const Center(
          child: Text('クイズが みつかりません'),
        ),
      );
    }

    final QuizQuestion question = quizSet.questions[_currentIndex];
    final bool isLast = _currentIndex == quizSet.questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(quizSet.title),
      ),
      body: CenteredLayout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 何問目か
              Text(
                '${_currentIndex + 1} / ${quizSet.questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _buildQuestionVisual(question),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_showAnswer)
                Column(
                  children: [
                    Text(
                      l10n.playQuizAnswerLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // デフォルトクイズには answerText が入っている想定
                    // 自作クイズはとりあえず「（こたえは じぶんたちで おはなし）」などでもOK
                    Text(
                      question.answerText ?? 'こたえは じぶんたちで おはなししてね！',
                    ),
                    const SizedBox(height: 16),
                    // セルフ○×ボタン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _hasAnsweredCurrent
                              ? null
                              : () => _onSelfJudge(isCorrect: true),
                          child: Text(l10n.playQuizCorrect),
                        ),
                        ElevatedButton(
                          onPressed: _hasAnsweredCurrent
                              ? null
                              : () => _onSelfJudge(isCorrect: false),
                          child: Text(l10n.playQuizIncorrect),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // 操作ボタン列
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showAnswer
                        ? null
                        : () {
                            setState(() {
                              _showAnswer = true;
                              _hasAnsweredCurrent = false;
                            });
                          },
                    child: Text(l10n.playQuizShowAnswer),
                  ),
                  ElevatedButton(
                    onPressed: (!_hasAnsweredCurrent)
                        ? null
                        : () {
                            if (isLast) {
                              _finishQuiz(context, quizSet);
                            } else {
                              setState(() {
                                _currentIndex++;
                                _showAnswer = false;
                                _hasAnsweredCurrent = false;
                              });
                            }
                          },
                    child:
                        Text(isLast ? l10n.playQuizFinish : l10n.playQuizNext),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// シルエット表示（MVP版）
  /// - 自作クイズ: 撮った写真を黒っぽくフィルタして「なんとなくシルエット」にする
  /// - デフォルトクイズ: これまでのカラフルダミーを継続
  Widget _buildQuestionVisual(QuizQuestion question) {
    final String? path = question.silhouetteImagePath.isNotEmpty
        ? question.silhouetteImagePath
        : question.originalImagePath;

    final bool hasFile =
        path != null && path.isNotEmpty && File(path).existsSync();

    if (hasFile) {
      final File file = File(path!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColorFiltered(
          // 真っ黒ではないけど、暗めでシルエットっぽく見せる
          colorFilter: const ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        ),
      );
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

  void _onSelfJudge({required bool isCorrect}) {
    setState(() {
      if (!_hasAnsweredCurrent && isCorrect) {
        _correctCount++;
      }
      _hasAnsweredCurrent = true;
    });
  }

  void _finishQuiz(BuildContext context, QuizSet quizSet) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int total = quizSet.questions.length;
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
