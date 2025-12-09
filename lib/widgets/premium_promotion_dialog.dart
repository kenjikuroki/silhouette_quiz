import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import 'factory_dialog.dart';
import 'puni_button.dart';

class PremiumPromotionDialog extends StatelessWidget {
  final QuizAppState appState;

  const PremiumPromotionDialog({super.key, required this.appState});

  static Future<void> show(BuildContext context, QuizAppState appState) async {
    await FactoryDialog.showFadeDialog(
      context: context,
      builder: (context) => PremiumPromotionDialog(appState: appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FactoryDialog(
      title: l10n.premiumPromotionTitle,
      titleFontSize: 18,
      message: '', // Custom content used below
      forceAspectRatio: false, // Auto height
      borderColor: const Color(0xFFFFD700), // Gold/Yellow for Premium
      backgroundAsset: null,
      useSparkle: true,
      actions: [
        _buildContent(context, l10n),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.premiumPromotionMessage,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        PuniButton(
          child: Text(
            l10n.premiumPromotionBuyButton,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          color: PuniButtonColors.pink,
          onPressed: () async {
            // Call purchase
            final success = await appState.purchaseService.purchaseFullVersion();
            if (context.mounted) {
              Navigator.of(context).pop(); // Close dialog
              if (success) {
                  appState.notifyListeners(); // Ensure UI updates
              }
            }
          },
        ),
        const SizedBox(height: 12),
        PuniButton(
           child: Text(
             l10n.commonCancel,
             style: const TextStyle(
               fontSize: 14,
               fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
           color: PuniButtonColors.blueGrey,
           onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
