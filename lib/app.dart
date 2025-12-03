import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_localizations.dart';
import 'state/quiz_app_state.dart';
import 'screens/home_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/custom_quiz_list_screen.dart';
import 'screens/create_quiz_intro_screen.dart';
import 'screens/create_quiz_capture_screen.dart';
import 'screens/create_quiz_confirm_screen.dart';
import 'screens/play_quiz_screen.dart';

class MyApp extends StatefulWidget {
  final QuizAppState appState;

  const MyApp({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  QuizAppState get appState => widget.appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Silhouette Quiz',
          locale: const Locale('ja'),
          supportedLocales: const [
            Locale('ja'),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ChallengeScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => ChallengeScreen(appState: appState),
                );
              case CustomQuizListScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => CustomQuizListScreen(appState: appState),
                );
              case CreateQuizIntroScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => CreateQuizIntroScreen(appState: appState),
                );
              case CreateQuizCaptureScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => CreateQuizCaptureScreen(appState: appState),
                );
              case CreateQuizConfirmScreen.routeName:
                final CreateQuizConfirmArguments args =
                    settings.arguments as CreateQuizConfirmArguments;
                return MaterialPageRoute(
                  builder: (_) => CreateQuizConfirmScreen(
                    appState: appState,
                    tempQuestions: args.tempQuestions,
                  ),
                );
              case PlayQuizScreen.routeName:
                final PlayQuizArguments args =
                    settings.arguments as PlayQuizArguments;
                return MaterialPageRoute(
                  builder: (_) => PlayQuizScreen(
                    appState: appState,
                    quizSetId: args.quizSetId,
                  ),
                );
              case HomeScreen.routeName:
              default:
                return MaterialPageRoute(
                  builder: (_) => HomeScreen(appState: appState),
                );
            }
          },
        );
      },
    );
  }
}
