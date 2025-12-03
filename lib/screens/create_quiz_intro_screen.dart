import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import 'create_quiz_capture_screen.dart';

class CreateQuizIntroScreen extends StatelessWidget {
  static const String routeName = '/create_intro';

  final QuizAppState appState;

  const CreateQuizIntroScreen({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createIntroTitle),
      ),
      body: CenteredLayout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.createIntroMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final bool canCreate =
                      await appState.ensureCanCreateCustomQuizSet();
                  if (!canCreate) {
                    // ここで何かエラー表示してもよい
                    return;
                  }
                  Navigator.of(context).pushNamed(
                    CreateQuizCaptureScreen.routeName,
                  );
                },
                child: Text(l10n.createIntroStartButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
