import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/quiz_models.dart';
import 'state/quiz_app_state.dart';
import 'app.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();

  Hive.registerAdapter(QuizQuestionAdapter());
  Hive.registerAdapter(QuizSetAdapter());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  QuizAppState? _appState;

  @override
  Widget build(BuildContext context) {
    if (_appState == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          onInitializationComplete: (appState) async {
            setState(() {
              _appState = appState;
            });
          },
        ),
      );
    } else {
      return MyApp(appState: _appState!);
    }
  }
}
