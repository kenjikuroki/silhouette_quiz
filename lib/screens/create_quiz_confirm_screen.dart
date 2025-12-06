import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/quiz_models.dart';
import '../state/quiz_app_state.dart';
import '../widgets/centered_layout.dart';
import '../widgets/centered_layout.dart';
import '../widgets/corner_back_button.dart';
import '../widgets/puni_button.dart';
import 'challenge_screen.dart';

class CreateQuizConfirmArguments {
  final List<QuizQuestion> tempQuestions;

  CreateQuizConfirmArguments({
    required this.tempQuestions,
  });
}

class CreateQuizConfirmScreen extends StatefulWidget {
  static const String routeName = '/create_confirm';

  final QuizAppState appState;
  final List<QuizQuestion> tempQuestions;

  const CreateQuizConfirmScreen({
    Key? key,
    required this.appState,
    required this.tempQuestions,
  }) : super(key: key);

  @override
  State<CreateQuizConfirmScreen> createState() =>
      _CreateQuizConfirmScreenState();
}

class _CreateQuizConfirmScreenState extends State<CreateQuizConfirmScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  bool _defaultTitleApplied = false;
  bool _isSaving = false;

  late AnimationController _boxDropController;
  late Animation<Offset> _boxDropAnimation;

  late AnimationController _boxSlideController;
  late Animation<Offset> _boxSlideAnimation;

  late AnimationController _conveyorShakeController;
  late Animation<Offset> _conveyorShakeAnimation;

  QuizAppState get appState => widget.appState;

  @override
  void initState() {
    super.initState();

    // Box Drop: 1s
    _boxDropController = AnimationController(
       duration: const Duration(seconds: 1),
       vsync: this,
    );
    _boxDropAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)), // Fall
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05))
            .chain(CurveTween(curve: Curves.easeOut)), // Small bounce up
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)), // Land back
        weight: 15,
      ),
    ]).animate(_boxDropController);

    // Box Slide (Exit): 2s
    _boxSlideController = AnimationController(
       duration: const Duration(seconds: 2),
       vsync: this,
    );
    _boxSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0), // Slide off-screen right
    ).animate(CurvedAnimation(
      parent: _boxSlideController,
      curve: Curves.easeInOut,
    ));

    // Conveyor Shake: 0.1s (repeating)
    _conveyorShakeController = AnimationController(
       duration: const Duration(milliseconds: 100),
       vsync: this,
    );
    _conveyorShakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.05), // Small vertical shake
    ).animate(_conveyorShakeController);

    // Start drop animation immediately
    _boxDropController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _boxDropController.dispose();
    _boxSlideController.dispose();
    _conveyorShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (!_defaultTitleApplied) {
      final int defaultNumber = widget.appState.customQuizSets.length + 1;
      final String defaultTitle =
          l10n.createConfirmDefaultTitle(defaultNumber);
      _titleController.text = defaultTitle;
      _titleController.selection =
          TextSelection.fromPosition(TextPosition(offset: defaultTitle.length));
      _defaultTitleApplied = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/background_name.png',
              fit: BoxFit.cover,
            ),
          ),
          // Removed piping.png
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _conveyorShakeAnimation,
              child: Image.asset(
                'assets/images/conveyor_y.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: Center(
              child: SlideTransition(
                position: _boxSlideAnimation, // Apply slide right AFTER drop
                child: SlideTransition(
                  position: _boxDropAnimation, // Apply drop
                  child: Image.asset(
                    'assets/images/box.png',
                    width: MediaQuery.of(context).size.width * 0.95,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CenteredLayout(
                  backgroundColor: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              l10n.createConfirmMessage,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: l10n.createConfirmTitleLabel,
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: PuniButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    color: Colors.blueGrey,
                                    child: Text(
                                      l10n.createConfirmBackButton,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: PuniButton(
                                    color: Colors.pink,
                                    onPressed: _isSaving
                                        ? null
                                        : () async {
                                            final String title =
                                                _titleController.text.trim();
                                            if (title.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      l10n.createConfirmTitleLabel), // Use label as error or custom string
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            setState(() {
                                              _isSaving = true;
                                            });

                                            try {
                                              // Start Exit Animations
                                              _conveyorShakeController.repeat(
                                                  reverse: true);
                                              _boxSlideController.forward();

                                              // Run Save and Timer in Parallel
                                              // This ensures we wait exactly 2 seconds unless saving is huge,
                                              // but prevents "2s wait + Save Time" accumulation.
                                              await Future.wait([
                                                Future.delayed(
                                                    const Duration(seconds: 2)),
                                                appState.addCustomQuizSet(
                                                  title: title,
                                                  questions: widget.tempQuestions,
                                                ),
                                              ]);

                                              if (!mounted) return;

                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                ChallengeScreen.routeName,
                                                (route) => route.isFirst,
                                              );
                                            } catch (e) {
                                              debugPrint('Error saving quiz: $e');
                                              if (mounted) {
                                                setState(() {
                                                  _isSaving = false;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    height: 48,
                                    child: _isSaving
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(l10n.createConfirmSaveButton, style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
