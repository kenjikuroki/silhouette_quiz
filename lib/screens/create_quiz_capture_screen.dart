import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
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
  static const int maxImages = 10;

  final List<QuizQuestion> _tempQuestions = <QuizQuestion>[];

  final ImagePicker _picker = ImagePicker();

  QuizAppState get appState => widget.appState;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createCaptureTitle),
      ),
      body: CenteredLayout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(l10n.createCaptureCount(_tempQuestions.length)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _tempQuestions.length,
                  itemBuilder: (context, index) {
                    final QuizQuestion question = _tempQuestions[index];
                    return Card(
                      child: ListTile(
                        leading: (question.originalImagePath != null &&
                                File(question.originalImagePath!).existsSync())
                            ? Image.file(
                                File(question.originalImagePath!),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.photo),
                        title: Text('もんだい ${index + 1}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            _confirmRemoveQuestion(context, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _tempQuestions.length >= maxImages
                    ? null
                    : _captureImageFromCamera,
                child: Text(l10n.createCaptureAddDummy),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
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
                child: Text(l10n.createCaptureFinish),
              ),
              if (_tempQuestions.length >= maxImages)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.createCaptureLimitMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
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
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.captureDeleteTitle),
          content: Text(l10n.captureDeleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.captureDeleteOk),
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
}
