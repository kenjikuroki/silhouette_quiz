import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'localization/app_localizations.dart';
import 'state/quiz_app_state.dart';
import 'screens/home_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/custom_quiz_list_screen.dart';
import 'screens/create_quiz_intro_screen.dart';
import 'screens/create_quiz_capture_screen.dart';
import 'screens/create_quiz_confirm_screen.dart';
import 'screens/play_quiz_screen.dart';
import 'widgets/puff_route.dart';
import 'services/audio_service.dart';
import 'widgets/audio_toggle_button.dart';

class MyApp extends StatefulWidget {
  final QuizAppState appState;

  const MyApp({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  QuizAppState get appState => widget.appState;
  bool _hasStartedBgm = false;

  void _startMainBgmIfNeeded() {
    if (_hasStartedBgm) {
      return;
    }
    _hasStartedBgm = true;
    AudioService.instance.playMainBgm();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMainBgmIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_hasStartedBgm) {
      if (state == AppLifecycleState.resumed) {
        _startMainBgmIfNeeded();
      }
      return;
    }
    if (state == AppLifecycleState.paused) {
      AudioService.instance.pauseBgm();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.instance.resumeBgm();
    }
  }

  TextStyle? _applyMinFontSize(TextStyle? style, double minSize) {
    if (style == null) return null;
    final currentSize = style.fontSize ?? 14.0;
    return style.copyWith(
      fontSize: currentSize < minSize ? minSize : currentSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define base text theme with M PLUS Rounded 1c w800 (ExtraBold) as requested
    final baseTextTheme = GoogleFonts.mPlusRounded1cTextTheme(Theme.of(context).textTheme);
    
    // Helper to ensure min 18pt
    TextStyle? applyMin(TextStyle? style) => _applyMinFontSize(style, 22.0);

    final mediumTextTheme = baseTextTheme.copyWith(
      displayLarge: applyMin(baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700)),
      displayMedium: applyMin(baseTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700)),
      displaySmall: applyMin(baseTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
      headlineLarge: applyMin(baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700)),
      headlineMedium: applyMin(baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
      headlineSmall: applyMin(baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
      titleLarge: applyMin(baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      titleMedium: applyMin(baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      titleSmall: applyMin(baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      bodyLarge: applyMin(baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
      bodyMedium: applyMin(baseTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      bodySmall: applyMin(baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
      labelLarge: applyMin(baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
      labelMedium: applyMin(baseTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
      labelSmall: applyMin(baseTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
    );

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).homeTitle,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: mediumTextTheme,
            // Ensure implicit text widgets also get the font family if possible
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily, 
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                const AudioToggleButton(),
              ],
            );
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ChallengeScreen.routeName:
                return PuffRoute(
                  builder: (_) => ChallengeScreen(appState: appState),
                  settings: settings,
                );
              case CustomQuizListScreen.routeName:
                return PuffRoute(
                  builder: (_) => CustomQuizListScreen(appState: appState),
                  settings: settings,
                );
              case CreateQuizIntroScreen.routeName:
                return PuffRoute(
                  builder: (_) => CreateQuizIntroScreen(appState: appState),
                  settings: settings,
                );
              case CreateQuizCaptureScreen.routeName:
                return PuffRoute(
                  builder: (_) => CreateQuizCaptureScreen(appState: appState),
                  settings: settings,
                );
              case CreateQuizConfirmScreen.routeName:
                final CreateQuizConfirmArguments args =
                    settings.arguments as CreateQuizConfirmArguments;
                return PuffRoute(
                  builder: (_) => CreateQuizConfirmScreen(
                    appState: appState,
                    tempQuestions: args.tempQuestions,
                  ),
                  settings: settings,
                );
              case PlayQuizScreen.routeName:
                final PlayQuizArguments args =
                    settings.arguments as PlayQuizArguments;
                return PuffRoute(
                  builder: (_) => PlayQuizScreen(
                    appState: appState,
                    quizSetId: args.quizSetId,
                  ),
                  settings: settings,
                );
              case HomeScreen.routeName:
              default:
                return PuffRoute(
                  builder: (_) => HomeScreen(appState: appState),
                  settings: settings,
                );
            }
          },
        );
      },
    );
  }
}
