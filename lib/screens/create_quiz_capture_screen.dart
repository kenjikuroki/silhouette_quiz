import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // For converting asset to file

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puni_button.dart';
import '../widgets/factory_dialog.dart';
import 'create_quiz_confirm_screen.dart';

class CreateQuizCaptureScreen extends StatefulWidget {
  static const String routeName = '/create_capture';

  final QuizAppState appState;

  const CreateQuizCaptureScreen({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<CreateQuizCaptureScreen> createState() =>
      _CreateQuizCaptureScreenState();
}

class _CreateQuizCaptureScreenState extends State<CreateQuizCaptureScreen> {
  static const int maxImages = 5;

  final List<QuizQuestion> _tempQuestions = <QuizQuestion>[];

  final ImagePicker _picker = ImagePicker();

  QuizAppState get appState => widget.appState;

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
                  'assets/images/backgrounds/background_camera.png',
                  fit: BoxFit.fill,
                ),
              ),
              // Back Button (Top Left)
              SafeArea(
                child: const CornerBackButton(),
              ),

              // Photo List (Fixed Position - Aligned with "Take Photo" button top)
              Positioned(
                left: horizontalOffset + 275 * scale,
                top: verticalOffset + 258 * scale, // 768 - (430 bottom + ~80 height)
                width: 250 * scale,
                height: 360 * scale,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _tempQuestions.length,
                  itemBuilder: (context, index) {
                    final QuizQuestion question = _tempQuestions[index];
                    return Card(
                      color: const Color(0xFFFFF9C4),
                      margin: const EdgeInsets.only(bottom: 8),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          _showPreview(context, question);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 16 * scale),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}まいめ',
                                style: TextStyle(
                                  fontSize: 20 * scale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 24 * scale,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                style: IconButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  _confirmRemoveQuestion(context, index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Buttons (Fixed Position)
              // Limit Message
              if (_tempQuestions.length >= maxImages)
                Positioned(
                  right: horizontalOffset + 240 * scale,
                  bottom: verticalOffset + 540 * scale,
                  width: 200 * scale,
                  child: Center(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Text(
                          l10n.createCaptureLimitMessage,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              // Capture Button
              Positioned(
                right: horizontalOffset + 240 * scale,
                bottom: verticalOffset + 430 * scale,
                width: 180 * scale,
                child: PuniButton(
                  text: 'しゃしんをとる',
                  color: PuniButtonColors.green,
                  onPressed: _tempQuestions.length >= maxImages
                      ? null
                      : _captureImageFromCamera,
                ),
              ),
              // Finish Button
              Positioned(
                right: horizontalOffset + 240 * scale,
                bottom: verticalOffset + 340 * scale,
                width: 180 * scale,
                child: PuniButton(
                  text: l10n.createCaptureFinish,
                  color: PuniButtonColors.pink,
                  onPressed: _tempQuestions.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pushNamed(
                            CreateQuizConfirmScreen.routeName,
                            arguments: CreateQuizConfirmArguments(
                              tempQuestions: List<QuizQuestion>.from(
                                _tempQuestions,
                              ),
                            ),
                          );
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _captureImageFromCamera() async {
    const bool isTestMode = bool.fromEnvironment('TEST_MODE');
    String originalPath;

    if (isTestMode) {
      // Test Mode: Simulate capture using an asset
      try {
        final ByteData byteData = await rootBundle.load('assets/images/quiz/animal/cat.png');
        final Directory tempDir = await getTemporaryDirectory();
        final File tempFile = File('${tempDir.path}/test_capture_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
        originalPath = tempFile.path;
      } catch (e) {
        // Fallback or error handling for test mode
        debugPrint('Test Mode Error: $e');
        return;
      }
    } else {
      // Normal Mode: Camera
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (picked == null) {
        // Cancelled
        return;
      }
      originalPath = picked.path;
    }

    String silhouettePath;
    try {
      if (isTestMode) {
        // Test Mode: Bypass ML Kit (which may crash on Simulator)
        // Just copy original to silhouette path
         silhouettePath = originalPath.replaceAll(
          RegExp(r'\.(png|jpg|jpeg)$', caseSensitive: false),
          '_silhouette.png',
        );
        // If they are same (no extension change), append suffix
        if (silhouettePath == originalPath) {
          silhouettePath = '$originalPath.silhouette.png';
        }
        await File(originalPath).copy(silhouettePath);
      } else {
        // Normal Mode: Generate Silhouette using ML Kit
        silhouettePath =
            await appState.silhouetteService.createSilhouette(originalPath);
      }
    } catch (e) {
      debugPrint('Error creating silhouette: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
      return;
    }

    final QuizQuestion question = QuizQuestion(
      id:
          'custom_${DateTime.now().microsecondsSinceEpoch}_${_tempQuestions.length}',
      silhouetteImagePath: silhouettePath,
      originalImagePath: originalPath,
      answerText: null,
    );

    setState(() {
      _tempQuestions.add(question);
    });
  }

  void _confirmRemoveQuestion(BuildContext context, int index) async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool? result = await FactoryDialog.showFadeDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return FactoryDialog(
          title: l10n.captureDeleteTitle,
          message: l10n.captureDeleteMessage,
          backgroundAsset: null,
          useSparkle: false,
          forceAspectRatio: false,
          borderColor: Colors.lightGreen,
          messageFontSize: 13,
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
                    text: l10n.captureDeleteOk,
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
      setState(() {
        _tempQuestions.removeAt(index);
      });
    }
  }

  void _removeQuestion(int index) {
    setState(() {
      _tempQuestions.removeAt(index);
    });
  }

  void _showPreview(BuildContext context, QuizQuestion question) {
    final String? path = question.silhouetteImagePath;
    final bool hasFile =
        path != null && path.isNotEmpty && File(path).existsSync();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: hasFile
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(path!),
                    fit: BoxFit.contain,
                  ),
                )
              : const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(child: Text('シルエットがありません')),
                ),
        );
      },
    );
  }
}
