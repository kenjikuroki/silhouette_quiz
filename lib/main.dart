import 'package:flutter/material.dart';
import 'app.dart';
import 'state/quiz_app_state.dart';

void main() {
  final appState = QuizAppState();
  runApp(MyApp(appState: appState));
}
