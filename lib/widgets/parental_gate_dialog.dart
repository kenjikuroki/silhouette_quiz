import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/app_localizations.dart';
import 'factory_dialog.dart';
import 'puni_button.dart';

class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final bool? result = await FactoryDialog.showFadeDialog<bool>(
      context: context,
      builder: (context) => const ParentalGateDialog(),
    );
    return result ?? false;
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late int _a;
  late int _b;
  String _input = '';
  bool _isIncorrect = false;

  bool _orientationLocked = false;
  bool _isTablet = false;

  @override
  void initState() {
    super.initState();
    // Use numbers 2-9 to avoid too easy 1x questions
    final random = Random();
    _a = random.nextInt(8) + 2; // 2-9
    _b = random.nextInt(8) + 2; // 2-9

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = MediaQuery.of(context).size;
      _isTablet = size.shortestSide >= 600;
      if (!_isTablet) {
        // Force Portrait for phones
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    // Revert to Landscape if we changed it (Phones)
    // We can't rely on _isTablet being perfectly stable if context died, 
    // but usually it is fine. To be safe, always restore landscape on dispose
    // if we are on a device that *might* have rotated.
    // Or just always restore for this app's requirement.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _onKeyPress(String key) {
    if (_isIncorrect) {
      setState(() {
        _isIncorrect = false;
        _input = '';
      });
    }

    if (key == 'DEL') {
      if (_input.isNotEmpty) {
        setState(() {
          _input = _input.substring(0, _input.length - 1);
        });
      }
    } else {
      if (_input.length < 3) {
        setState(() {
          _input += key;
        });
      }
    }

    // Auto-check if length matches solution length? No, require 'OK' or full match?
    // Let's check when they've typed enough digits or allow them to press enter?
    // Or just simple check on change?
    // For simplicity, let's just input. We don't have an "OK" button in the keypad,
    // but we can check if the value matches the answer.
  }

  void _validate() {
    final int answer = _a * _b;
    if (_input == answer.toString()) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
         _isIncorrect = true;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
         if (mounted) {
             setState(() {
                 _input = '';
                 _isIncorrect = false;
             });
         }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Adjust scale based on device type
    // Phone (Portrait): width ~360-400. Scale base 380.
    // Tablet (Landscape): width ~1000+. Scale base 1000? or 800?
    final double width = MediaQuery.of(context).size.width;
    final double scale = _isTablet 
        ? (width / 1300).clamp(0.7, 1.0) // Tablet scale
        : (width / 380).clamp(0.8, 1.3); // Phone scale

    return FactoryDialog(
      title: '',
      message: '',
      titleFontSize: 0,
      messageFontSize: 0,
      showCongratulationHeader: false,
      backgroundAsset: null, // No background image
      borderColor: const Color(0xFFFFC107), // Amber/Yellow
      useSparkle: false,
      forceAspectRatio: false,
      actions: [
        SizedBox(
          width: double.maxFinite,
          child: _buildVerticalLayout(l10n, scale),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(AppLocalizations l10n, double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.parentalGateTitle,
          style: TextStyle(
            fontSize: 18 * scale, // Reduced from 22
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          l10n.parentalGateMessage,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16 * scale), // Reduced from 22
        ),
        SizedBox(height: 16 * scale),
        // Problem and Input
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '$_a × $_b = ?',
                style: TextStyle(
                  fontSize: 22 * scale, // Reduced from 24
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4 * scale),
              Container(
                width: 90 * scale,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _input.isEmpty ? '' : _input,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20 * scale, // Reduced from 22
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isIncorrect)
          Padding(
            padding: EdgeInsets.only(top: 4 * scale),
            child: Text(
              l10n.parentalGateFailed,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18 * scale, // Reduced from 22
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 24 * scale),
        _buildKeypad(scale),
        SizedBox(height: 24 * scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: PuniButton(
                  child: Text(
                    l10n.commonCancel,
                    style: TextStyle(
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: PuniButtonColors.blueGrey,
                  onPressed: () => Navigator.of(context).pop(false),
                  height: 40 * scale,
                ),
              ),
            ),
            SizedBox(width: 16 * scale),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: PuniButton(
                  child: Text(
                    l10n.commonOk,
                    style: TextStyle(
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: PuniButtonColors.pink,
                  onPressed: _validate,
                  height: 40 * scale,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypad(double scale) {
    Widget gap() => SizedBox(width: 12 * scale);
    Widget vGap() => SizedBox(height: 12 * scale);

    Widget buildRow(List<String> keys) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildKey(keys[0], scale),
          gap(),
          _buildKey(keys[1], scale),
          gap(),
          _buildKey(keys[2], scale),
        ],
      );
    }

    return Column(
      children: [
        buildRow(['1', '2', '3']),
        vGap(),
        buildRow(['4', '5', '6']),
        vGap(),
        buildRow(['7', '8', '9']),
        vGap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 56 * scale), // Placeholder
            gap(),
            _buildKey('0', scale),
            gap(),
            _buildKey('DEL', scale, icon: Icons.backspace_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String key, double scale, {IconData? icon}) {
    return SizedBox(
      width: 56 * scale,
      height: 56 * scale,
      child: PuniButton(
        onPressed: () => _onKeyPress(key),
        color: PuniButtonColors.green,
        padding: EdgeInsets.zero,
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.white, size: 20 * scale)
              : Text(
                  key,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18 * scale, // Reduced from 22
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
