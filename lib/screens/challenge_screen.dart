import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/factory_plate_card.dart';
import 'custom_quiz_list_screen.dart';
import 'play_quiz_screen.dart';

class ChallengeScreen extends StatelessWidget {
  static const String routeName = '/challenge';

  final QuizAppState appState;

  const ChallengeScreen({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<QuizSet> defaultSets = appState.defaultQuizSets;
    final List<QuizSet> recentCustomSets =
        appState.getRecentCustomQuizSets(6);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/backgrround_start_list.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CenteredLayout(
                  maxContentWidth: double.infinity,
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 左側: みんなのクイズ
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.challengeDefaultSectionTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView(
                                  children: defaultSets
                                      .map(
                                      (set) => FactoryPlateCard(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            PlayQuizScreen.routeName,
                                            arguments: PlayQuizArguments(
                                                quizSetId: set.id),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(set.title),
                                        ),
                                      ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // 右側: きみがつくったクイズ
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.challengeCustomSectionTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView(
                                  children: [
                                      if (recentCustomSets.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Center(
                                            child: Text(
                                              l10n.customListEmpty,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    offset: const Offset(1.0, 1.0),
                                                    blurRadius: 2.0,
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    else
                                      ...recentCustomSets.map(
                                      (set) => FactoryPlateCard(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            PlayQuizScreen.routeName,
                                            arguments: PlayQuizArguments(
                                                quizSetId: set.id),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(set.title),
                                        ),
                                      ),
                                      ),
                                    if (appState.customQuizSets.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            CustomQuizListScreen.routeName,
                                          );
                                        },
                                        child: Text(l10n.challengeMoreButton),
                                      ),
                                  ],
                                ),
                              ),
                            ],
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
