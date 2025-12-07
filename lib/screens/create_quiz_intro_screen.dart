import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puff_route.dart';
import '../widgets/puni_button.dart';
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/backgrround_start.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CenteredLayout(
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'しゃしんをとって じぶんだけの\nシルエットクイズを つくろう！\nさいだい５まい とれるよ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 24),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: PuniButton(
                              text: l10n.createIntroStartButton,
                              color: PuniButtonColors.green,
                              textColor: Colors.white,
                              onPressed: () async {
                                final bool canCreate =
                                    await appState.ensureCanCreateCustomQuizSet();
                                if (!canCreate) {
                                  return;
                                }
                                Navigator.of(context).pushNamed(
                                  CreateQuizCaptureScreen.routeName,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
}
