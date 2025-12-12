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
          final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    
    // Scale for iPad
    final double titleSize = isTablet ? 32 : 22;
    final double itemSize = isTablet ? 24 : 16;
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16 * (isTablet ? 1.2 : 1), vertical: 8 * (isTablet ? 1.2 : 1)),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.challengeDefaultSectionTitle,
                                  style: TextStyle(
                                    fontSize: isTablet ? 30 : 18,
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
                                              dense: !isTablet,
                                              contentPadding: isTablet ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8) : const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                              title: Text(
                                                _quizSetTitle(l10n, set),
                                                style: TextStyle(
                                                  fontSize: isTablet ? 30 : 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: isLocked ? Icon(Icons.lock, color: Colors.grey, size: 24 * (isTablet ? 1.5 : 1.0)) : null,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16 * (isTablet ? 1.2 : 1), vertical: 8 * (isTablet ? 1.2 : 1)),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.challengeCustomSectionTitle,
                                  style: TextStyle(
                                    fontSize: isTablet ? 30 : 18,
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
                                              fontSize: 18 * (isTablet ? 1.5 : 1.0),
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
                                              dense: !isTablet,
                                              contentPadding: isTablet ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8) : const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _quizSetTitle(l10n, set),
                                                      style: TextStyle(
                                                        fontSize: isTablet ? 30 : 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isNew)
                                                     _NewBadge(fontScale: isTablet ? 1.5 : 1.0),
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
                                            iconSize: 48 * scale * (isTablet ? 1.2 : 1.0),
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
                                            fontSize: isTablet ? 30 : 18,
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

  String _quizSetTitle(AppLocalizations l10n, QuizSet set) {
    if (set.isCustom) {
      return set.title;
    }
    switch (set.id) {
      case 'animal_1':
        return l10n.quizSetAnimals;
      case 'food_1':
        return l10n.quizSetFood;
      case 'vehicle_1':
        return l10n.quizSetVehicle;
      case 'home_1':
        return l10n.quizSetHomeItems;
      case 'kitchen_1':
        return l10n.quizSetKitchenItems;
      case 'school_supplies_1':
        return l10n.quizSetStationery;
      default:
        return set.title;
    }
  }
}

class _NewBadge extends StatelessWidget {
  final double fontScale;
  const _NewBadge({this.fontScale = 1.0});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * fontScale, vertical: 2 * fontScale),
      decoration: BoxDecoration(
        color: PuniButtonColors.pink,
        borderRadius: BorderRadius.circular(12 * fontScale),
      ),
      child: Text(
        l10n.badgeNewLabel,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14 * fontScale,
        ),
      ),
    );
  }
}
