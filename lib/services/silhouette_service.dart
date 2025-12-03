import 'dart:math';

import 'package:flutter/material.dart';
import '../models/quiz_models.dart';

class SilhouetteService {
  int _dummyCounter = 0;
  final Random _random = Random();

  /// 本来は画像パスを渡してシルエットを作るが、
  /// MVP では「ダミー画像パス」を生成しておく。
  QuizQuestion createDummyQuestion() {
    _dummyCounter++;
    final String id = 'dummy_$_dummyCounter';

    // 本当ならファイルパスだが、とりあえず ID をパスとして扱う
    final String silhouettePath = 'silhouette_$id';

    return QuizQuestion(
      id: id,
      silhouetteImagePath: silhouettePath,
      originalImagePath: null,
      answerText: 'こたえ$_dummyCounter',
    );
  }

  Color randomSilhouetteColor() {
    // ダミー表示用の色（実際には黒シルエットになる想定）
    return Color.fromARGB(
      255,
      _random.nextInt(200),
      _random.nextInt(200),
      _random.nextInt(200),
    );
  }
}
