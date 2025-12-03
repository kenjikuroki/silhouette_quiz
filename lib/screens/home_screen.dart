import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool _started = false;

  QuizAppState get appState => widget.appState;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: CenteredLayout(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.homeTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (!_started)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _started = true;
                    });
                  },
                  child: Text(l10n.homeStartButton),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          CreateQuizIntroScreen.routeName,
                        );
                      },
                      child: Text(l10n.homeModeCreate),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ChallengeScreen.routeName,
                        );
                      },
                      child: Text(l10n.homeModeChallenge),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
