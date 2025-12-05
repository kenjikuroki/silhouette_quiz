import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/quiz_models.dart';
import 'state/quiz_app_state.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(QuizQuestionAdapter());
  Hive.registerAdapter(QuizSetAdapter());

  final QuizAppState appState = QuizAppState();
  await appState.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp(appState: appState));
}
