import 'package:hive/hive.dart';

part 'quiz_models.g.dart';

@HiveType(typeId: 1)
class QuizQuestion {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? silhouetteImagePath;

  @HiveField(2)
  String? originalImagePath;

  @HiveField(3)
  String? answerText;

  QuizQuestion({
    required this.id,
    this.silhouetteImagePath,
    this.originalImagePath,
    this.answerText,
  });
}

@HiveType(typeId: 2)
class QuizSet {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<QuizQuestion> questions;

  @HiveField(3)
  bool isCustom;

  QuizSet({
    required this.id,
    required this.title,
    required this.questions,
    this.isCustom = false,
  });
}
