import 'dart:math';
import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/factory_plate_card.dart';
import '../widgets/puni_button.dart';
import 'custom_quiz_list_screen.dart';
import 'play_quiz_screen.dart';
import 'create_quiz_intro_screen.dart';
import '../widgets/premium_promotion_dialog.dart';

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
                  'assets/images/backgrounds/background_wall.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: horizontalOffset + 40 * scale,
                bottom: verticalOffset - 180 * scale,
                width: 320 * scale,
                child: Image.asset(
                  'assets/images/character/６.png',
                  fit: BoxFit.contain,
                ),
              ),
              SafeArea(
            child: Stack(
              children: [
                CenteredLayout(
                  maxContentWidth: 900,
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        (set) {
                                          final bool isFree = ['animal_1', 'food_1', 'vehicle_1'].contains(set.id);
                                          final bool isLocked = !isFree && !appState.isFullVersionPurchased;

                                          return FactoryPlateCard(
                                            onTap: () {
                                              if (isLocked) {
                                                PremiumPromotionDialog.show(context, appState);
                                              } else {
                                                Navigator.of(context).pushNamed(
                                                  PlayQuizScreen.routeName,
                                                  arguments: PlayQuizArguments(
                                                      quizSetId: set.id),
                                                );
                                              }
                                            },
                                            child: ListTile(
                                              title: Text(set.title),
                                              trailing: isLocked ? const Icon(Icons.lock, color: Colors.grey) : null,
                                            ),
                                          );
                                        },
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
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
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      ...recentCustomSets.map(
                                        (set) {
                                          final bool isNew =
                                              appState.newQuizIds
                                                  .contains(set.id);
                                          return FactoryPlateCard(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                PlayQuizScreen.routeName,
                                                arguments: PlayQuizArguments(
                                                    quizSetId: set.id),
                                              );
                                            },
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Expanded(child: Text(set.title)),
                                                  if (isNew)
                                                    const _NewBadge(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    if (appState.customQuizSets.length >= 2 && !appState.isFullVersionPurchased)
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8 * scale),
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(Icons.add_circle),
                                            color: Colors.green.shade800,
                                            iconSize: 48 * scale,
                                            onPressed: () {
                                              if (!appState.isFullVersionPurchased) {
                                                PremiumPromotionDialog.show(context, appState);
                                              } else {
                                                Navigator.of(context).pushNamed(
                                                  CreateQuizIntroScreen.routeName,
                                                );
                                              }
                                            },
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
                                        child: Text(
                                          l10n.challengeMoreButton,
                                          style: TextStyle(
                                            fontSize: 18 * scale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
          );
        },
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: PuniButtonColors.pink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
