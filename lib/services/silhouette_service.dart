import 'dart:math';

import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import '../utils/mlkit_silhouette_processor.dart';

class SilhouetteService {
  int _dummyCounter = 0;
  final Random _random = Random();
  final MLKitSilhouetteProcessor _mlkitProcessor = MLKitSilhouetteProcessor();

  /// ML Kitの初期化
  Future<void> initialize() async {
    await _mlkitProcessor.initialize();
  }

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

  /// 写真からシルエット画像を生成（ML Kit使用）
  Future<String> createSilhouette(String originalImagePath) async {
    return await _mlkitProcessor.createSilhouette(originalImagePath);
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

  /// リソースの解放
  Future<void> dispose() async {
    await _mlkitProcessor.dispose();
  }
}
