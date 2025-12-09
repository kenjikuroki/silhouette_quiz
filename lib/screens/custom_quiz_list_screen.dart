import 'dart:math';
import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/factory_plate_card.dart';
import '../widgets/factory_dialog.dart';
import '../widgets/puni_button.dart';
import 'play_quiz_screen.dart';

class CustomQuizListScreen extends StatelessWidget {
  static const String routeName = '/custom_list';

  final QuizAppState appState;

  const CustomQuizListScreen({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<QuizSet> customSets = appState.customQuizSets;

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
              SafeArea(
                child: Stack(
                  children: [
                    CenteredLayout(
                      backgroundColor: Colors.transparent,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                    itemCount: customSets.length,
                    itemBuilder: (context, index) {
                      final QuizSet set = customSets[index];
                      final bool isNew =
                          appState.newQuizIds.contains(set.id);
                      return FactoryPlateCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            PlayQuizScreen.routeName,
                            arguments: PlayQuizArguments(quizSetId: set.id),
                          );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(set.title)),
                              if (isNew) const _NewBadge(),
                            ],
                          ),
                          subtitle: Text('${set.questions.length} もん'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _confirmDelete(context, set.id);
                            },
                          ),
                        ),
                      );
                    },
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

  void _confirmDelete(BuildContext context, String id) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? result = await FactoryDialog.showFadeDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return FactoryDialog(
          title: l10n.deleteQuizConfirmTitle,
          message: l10n.deleteQuizConfirmMessage,
          backgroundAsset: null,
          useSparkle: false,
          forceAspectRatio: false, // Auto height
          messageFontSize: 13,
          borderColor: Colors.lightGreen,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: PuniButton(
                    text: l10n.commonCancel,
                    color: PuniButtonColors.blueGrey,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: PuniButton(
                    text: l10n.commonDelete,
                    color: PuniButtonColors.pink,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == true) {
      appState.deleteCustomQuizSet(id);
    }
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
