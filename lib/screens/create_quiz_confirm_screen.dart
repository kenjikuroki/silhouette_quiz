import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
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

class _CreateQuizConfirmScreenState extends State<CreateQuizConfirmScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _defaultTitleApplied = false;

  QuizAppState get appState => widget.appState;

  @override
  void dispose() {
    _titleController.dispose();
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
      body: SafeArea(
        child: Stack(
          children: [
            CenteredLayout(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.createConfirmMessage,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: l10n.createConfirmTitleLabel,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.createConfirmBackButton),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final String title = _titleController.text.trim();
                              if (title.isEmpty) {
                                return;
                              }
                              appState.addCustomQuizSet(
                                title: title,
                                questions: widget.tempQuestions,
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                ChallengeScreen.routeName,
                                (route) => route.isFirst,
                              );
                            },
                            child: Text(l10n.createConfirmSaveButton),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const CornerBackButton(),
          ],
        ),
      ),
    );
  }
}
