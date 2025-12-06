import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
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
                  backgroundColor: Colors.transparent,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: customSets.length,
                    itemBuilder: (context, index) {
                      final QuizSet set = customSets[index];
                      return Card(
                        child: ListTile(
                          title: Text(set.title),
                          subtitle: Text('${set.questions.length} もん'),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlayQuizScreen.routeName,
                              arguments: PlayQuizArguments(quizSetId: set.id),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
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
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteQuizConfirmTitle),
          content: Text(l10n.deleteQuizConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonDelete),
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
