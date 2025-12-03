import 'package:flutter/foundation.dart';

enum QuizCategory {
  vehicle,
  food,
  animal,
  custom,
}

@immutable
class QuizQuestion {
  final String id;
  final String silhouetteImagePath;
  final String? originalImagePath;
  final String? answerText;

  const QuizQuestion({
    required this.id,
    required this.silhouetteImagePath,
    this.originalImagePath,
    this.answerText,
  });

  QuizQuestion copyWith({
    String? silhouetteImagePath,
    String? originalImagePath,
    String? answerText,
  }) {
    return QuizQuestion(
      id: id,
      silhouetteImagePath: silhouetteImagePath ?? this.silhouetteImagePath,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      answerText: answerText ?? this.answerText,
    );
  }
}

@immutable
class QuizSet {
  final String id;
  final String title;
  final QuizCategory category;
  final List<QuizQuestion> questions;
  final bool isCustom;
  final DateTime createdAt;

  const QuizSet({
    required this.id,
    required this.title,
    required this.category,
    required this.questions,
    required this.isCustom,
    required this.createdAt,
  });

  QuizSet copyWith({
    String? title,
    List<QuizQuestion>? questions,
  }) {
    return QuizSet(
      id: id,
      title: title ?? this.title,
      category: category,
      questions: questions ?? this.questions,
      isCustom: isCustom,
      createdAt: createdAt,
    );
  }
}
