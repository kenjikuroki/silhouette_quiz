import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/background_camera.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CenteredLayout(
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // List on the Left
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _tempQuestions.length,
                                  itemBuilder: (context, index) {
                                    final QuizQuestion question =
                                        _tempQuestions[index];
                                    return Card(
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16, 0, 0, 0),
                                        leading: (question.originalImagePath !=
                                                    null &&
                                                File(question
                                                        .originalImagePath!)
                                                    .existsSync())
                                            ? Image.file(
                                                File(question
                                                    .originalImagePath!),
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.photo),
                                        title: Text('${index + 1}まいめ'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _confirmRemoveQuestion(
                                                context, index);
                                          },
                                        ),
                                        onTap: () {
                                          _showPreview(context, question);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Buttons on the Right
                              SizedBox(
                                width: 180,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                  if (_tempQuestions.length >= maxImages)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: SizedBox(
                                        width: 120, // Constrain width to avoid pushing list
                                        child: DecoratedBox(
                                           decoration: BoxDecoration(
                                             color: Color.fromRGBO(255, 255, 255, 0.8),
                                             borderRadius: BorderRadius.all(Radius.circular(8)),
                                           ),
                                           child: Padding(
                                             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                             child: Text(
                                               'さつえいは5まいまでだよ。',
                                               style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                                               textAlign: TextAlign.center,
                                             ),
                                           ),
                                        ),
                                      ),
                                    ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: 180,
                                      child: PuniButton(
                                        text: 'しゃしんをとる',
                                        color: PuniButtonColors.green,
                                        onPressed:
                                            _tempQuestions.length >= maxImages
                                                ? null
                                                : _captureImageFromCamera,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: 180,
                                      child: PuniButton(
                                        text: l10n.createCaptureFinish,
                                        color: PuniButtonColors.pink,
                                        onPressed: _tempQuestions.isEmpty
                                            ? null
                                            : () {
                                                Navigator.of(context)
                                                    .pushNamed(
                                                  CreateQuizConfirmScreen
                                                      .routeName,
                                                  arguments:
                                                      CreateQuizConfirmArguments(
                                                    tempQuestions:
                                                        List<QuizQuestion>.from(
                                                      _tempQuestions,
                                                    ),
                                                  ),
                                                );
                                              },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 80), // Added spacing to lift buttons
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

  Future<void> _captureImageFromCamera() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (picked == null) {
      // キャンセルされた
      return;
    }

    final String originalPath = picked.path;

    // シルエット画像を生成
    final String silhouettePath =
        await appState.silhouetteService.createSilhouette(originalPath);

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

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return FactoryDialog(
          title: l10n.captureDeleteTitle,
          message: l10n.captureDeleteMessage,
          actions: [
            PuniButton(
              text: l10n.commonCancel,
              color: PuniButtonColors.blueGrey,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            PuniButton(
              text: l10n.captureDeleteOk,
              color: PuniButtonColors.pink,
              onPressed: () => Navigator.of(dialogContext).pop(true),
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
