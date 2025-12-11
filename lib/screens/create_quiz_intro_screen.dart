import 'dart:math';
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
                  'assets/images/backgrounds/backgrround_start.png',
                  fit: BoxFit.fill,
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
                            l10n.createIntroMessage,
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
          );
        },
      ),
    );
  }
}
