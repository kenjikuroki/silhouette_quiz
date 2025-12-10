import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../state/quiz_app_state.dart';
import 'factory_dialog.dart';
import 'parental_gate_dialog.dart';
import 'puni_button.dart';

class PremiumPromotionDialog extends StatelessWidget {
  final QuizAppState appState;

  const PremiumPromotionDialog({super.key, required this.appState});

  static Future<void> show(BuildContext context, QuizAppState appState) async {
    final bool? result = await FactoryDialog.showFadeDialog<bool>(
      context: context,
      builder: (context) => PremiumPromotionDialog(appState: appState),
    );

    if (result == true && context.mounted) {
        await _showThankYouDialog(context);
    }
  }

  static Future<void> _showThankYouDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await FactoryDialog.showFadeDialog(
      context: context,
      builder: (context) => FactoryDialog(
        title: l10n.purchaseCompleteTitle,
        message: l10n.purchaseCompleteMessage,
        showCongratulationHeader: true,
        backgroundAsset: 'assets/images/character/completion.png',
        celebrationTitle: l10n.purchaseCompleteCelebration,
        celebrationFontSize: 20,
        useCelebrationOutline: true,
        useSparkle: true,
        actions: [
          SizedBox(
            width: 160,
            child: PuniButton(
              text: l10n.commonOk,
              color: PuniButtonColors.pink,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
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
            // Parental Gate
            final bool authorized = await ParentalGateDialog.show(context);
            if (!authorized || !context.mounted) return;

            // Call purchase
            final success = await appState.purchaseService.purchaseFullVersion();
            if (context.mounted) {
              Navigator.of(context).pop(success); // Close dialog with result
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
        TextButton(
          onPressed: () async {
            await appState.purchaseService.restorePurchases();
            // Restore handling is done via stream listener in PurchaseService.
            // If successful, it updates the state.
            // We might want to close the dialog or show a message, but the service handles it.
            // For now, just call the method.
            if (context.mounted) {
               Navigator.of(context).pop();
            }
          },
          child: const Text(
            '購入を復元する',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
