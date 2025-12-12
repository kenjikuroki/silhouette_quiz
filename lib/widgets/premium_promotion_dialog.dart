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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double w = MediaQuery.of(context).size.width;
    // Revert scaling for Premium Dialog as requested by user.
    final double fontScale = 1.0;

    return FactoryDialog(
      title: l10n.premiumPromotionTitle,
      titleFontSize: 16 * fontScale,
      message: '', // Custom content used below
      forceAspectRatio: false, // Auto height
      borderColor: const Color(0xFFFFD700), // Gold/Yellow for Premium
      backgroundAsset: null, // Set to white as requested
      useSparkle: true,
      actions: [
        _buildContent(context, l10n, fontScale),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n, double fontScale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.premiumPromotionMessage,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 15 * fontScale,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24 * fontScale),
        SizedBox(
          width: 450 * fontScale,
          child: PuniButton(
            child: Text(
              l10n.premiumPromotionBuyButton,
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            color: PuniButtonColors.pink,
            height: 48 * fontScale,
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
        ),
        SizedBox(height: 12 * fontScale),
        SizedBox(
          width: 450 * fontScale,
          child: PuniButton(
             child: Text(
               l10n.commonCancel,
               style: TextStyle(
                 fontSize: 16 * fontScale,
                 fontWeight: FontWeight.bold,
                 color: Colors.white,
               ),
             ),
             color: PuniButtonColors.blueGrey,
             height: 48 * fontScale,
             onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        TextButton(
          onPressed: () async {
            await appState.purchaseService.restorePurchases();
            if (context.mounted) {
               Navigator.of(context).pop();
            }
          },
          child: Text(
            l10n.premiumRestoreButton,
            style: TextStyle(fontSize: 13 * fontScale, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
