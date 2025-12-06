import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/quiz_models.dart';
import '../services/purchase_service.dart';
import '../services/silhouette_service.dart';

class QuizAppState extends ChangeNotifier {
  static const String customQuizBoxName = 'custom_quiz_sets';
  static const String newQuizzesKey = 'new_custom_quiz_ids';

  late Box<QuizSet> _customQuizBox;

  final List<QuizSet> _defaultQuizSets = <QuizSet>[];

  late Box<List> _metaBox;

  final PurchaseService purchaseService = PurchaseService();
  final SilhouetteService silhouetteService = SilhouetteService();

  static const int freeCustomQuizLimit = 3;

  List<QuizSet> get defaultQuizSets => List.unmodifiable(_defaultQuizSets);
  List<QuizSet> get customQuizSets => _customQuizBox.values.toList().cast<QuizSet>().reversed.toList();

  bool get isFullVersionPurchased => purchaseService.isFullVersionPurchased;

  Future<void> initialize() async {
    _customQuizBox = await Hive.openBox<QuizSet>(customQuizBoxName);
    _metaBox = await Hive.openBox<List>('quiz_meta');
    await purchaseService.loadPurchaseState();
    await silhouetteService.initialize();
    _loadDefaultQuizzes();
    notifyListeners();
  }

  void _loadDefaultQuizzes() {
    if (_defaultQuizSets.isNotEmpty) return;

    _defaultQuizSets.addAll([
      QuizSet(
        id: 'vehicle_1',
        title: 'のりものクイズ',
        isCustom: false,
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
      QuizSet(
        id: 'food_1',
        title: 'たべものクイズ',
        isCustom: false,
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
      QuizSet(
        id: 'animal_1',
        title: 'どうぶつクイズ',
        isCustom: false,
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
      QuizSet(
        id: 'home_1',
        title: 'おうちのなかクイズ',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'home_bed',
            silhouetteImagePath: 'assets/images/quiz/home/bed_b.png',
            originalImagePath: 'assets/images/quiz/home/bed.png',
            answerText: 'ベッド',
          ),
          QuizQuestion(
            id: 'home_brush',
            silhouetteImagePath: 'assets/images/quiz/home/brush_b.png',
            originalImagePath: 'assets/images/quiz/home/brush.png',
            answerText: 'はぶらし',
          ),
          QuizQuestion(
            id: 'home_chair',
            silhouetteImagePath: 'assets/images/quiz/home/chair_b.png',
            originalImagePath: 'assets/images/quiz/home/chair.png',
            answerText: 'いす',
          ),
          QuizQuestion(
            id: 'home_cup',
            silhouetteImagePath: 'assets/images/quiz/home/cup_b.png',
            originalImagePath: 'assets/images/quiz/home/cup.png',
            answerText: 'コップ',
          ),
          QuizQuestion(
            id: 'home_phone',
            silhouetteImagePath: 'assets/images/quiz/home/phone_B.png',
            originalImagePath: 'assets/images/quiz/home/phone.png',
            answerText: 'でんわ',
          ),
        ],
      ),
    ]);
  }

  bool canCreateCustomQuizSet() {
    if (isFullVersionPurchased) return true;
    return customQuizSets.length < freeCustomQuizLimit;
  }

  Future<bool> ensureCanCreateCustomQuizSet() async {
    if (canCreateCustomQuizSet()) {
      return true;
    }
    final bool result = await purchaseService.purchaseFullVersion();
    notifyListeners();
    return result;
  }

  Future<void> addCustomQuizSet({
    required String title,
    required List<QuizQuestion> questions,
  }) async {
    final QuizSet set = QuizSet(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      isCustom: true,
      questions: List<QuizQuestion>.from(questions),
    );
    await _customQuizBox.put(set.id, set);
    _addNewQuizId(set.id);
    notifyListeners();
  }

  Future<void> deleteCustomQuizSet(String id) async {
    await _customQuizBox.delete(id);
    _removeNewQuizId(id);
    notifyListeners();
  }

  List<QuizSet> getRecentCustomQuizSets(int limit) {
    final sets = customQuizSets;
    if (sets.length <= limit) {
      return sets;
    }
    return sets.sublist(0, limit);
  }

  QuizSet? findQuizSetById(String id) {
    for (final QuizSet set in _defaultQuizSets) {
      if (set.id == id) return set;
    }
    // Hive box lookup
    if (_customQuizBox.containsKey(id)) {
      return _customQuizBox.get(id);
    }
    return null;
  }

  List<String> get newQuizIds {
    final List? raw = _metaBox.get(newQuizzesKey);
    if (raw == null) return [];
    return raw.cast<String>();
  }

  void markQuizAsViewed(String id) {
    _removeNewQuizId(id);
    notifyListeners();
  }

  void _addNewQuizId(String id) {
    final List<String> ids = newQuizIds;
    if (!ids.contains(id)) {
      ids.add(id);
      _metaBox.put(newQuizzesKey, ids);
    }
  }

  void _removeNewQuizId(String id) {
    final List<String> ids = newQuizIds;
    if (ids.remove(id)) {
      _metaBox.put(newQuizzesKey, ids);
    }
  }
}
