import 'package:flutter/foundation.dart';

import '../models/quiz_models.dart';
import '../services/purchase_service.dart';
import '../services/silhouette_service.dart';

class QuizAppState extends ChangeNotifier {
  final List<QuizSet> _defaultQuizSets = <QuizSet>[];
  final List<QuizSet> _customQuizSets = <QuizSet>[];

  final PurchaseService purchaseService = PurchaseService();
  final SilhouetteService silhouetteService = SilhouetteService();

  static const int freeCustomQuizLimit = 3;

  List<QuizSet> get defaultQuizSets => List.unmodifiable(_defaultQuizSets);
  List<QuizSet> get customQuizSets => List.unmodifiable(_customQuizSets);

  bool get isFullVersionPurchased => purchaseService.isFullVersionPurchased;

  Future<void> initialize() async {
    await purchaseService.loadPurchaseState();
    _loadDefaultQuizzes();
  }

  void _loadDefaultQuizzes() {
    if (_defaultQuizSets.isNotEmpty) return;

    _defaultQuizSets.addAll([
      QuizSet(
        id: 'vehicle_1',
        title: 'のりものクイズ',
        category: QuizCategory.vehicle,
        isCustom: false,
        createdAt: DateTime.now(),
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
      QuizSet(
        id: 'food_1',
        title: 'たべものクイズ',
        category: QuizCategory.food,
        isCustom: false,
        createdAt: DateTime.now(),
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
      QuizSet(
        id: 'animal_1',
        title: 'どうぶつクイズ',
        category: QuizCategory.animal,
        isCustom: false,
        createdAt: DateTime.now(),
        questions: [
          silhouetteService.createDummyQuestion(),
          silhouetteService.createDummyQuestion(),
        ],
      ),
    ]);
  }

  bool canCreateCustomQuizSet() {
    if (isFullVersionPurchased) return true;
    return _customQuizSets.length < freeCustomQuizLimit;
  }

  Future<bool> ensureCanCreateCustomQuizSet() async {
    if (canCreateCustomQuizSet()) {
      return true;
    }
    // 課金してもよいかは UI 側で確認ダイアログを出してから呼ぶ想定でもOKだが、
    // MVPでは「ここで購買を試みる」形にしておく。
    final bool result = await purchaseService.purchaseFullVersion();
    return result;
  }

  void addCustomQuizSet({
    required String title,
    required List<QuizQuestion> questions,
  }) {
    final QuizSet set = QuizSet(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: QuizCategory.custom,
      isCustom: true,
      createdAt: DateTime.now(),
      questions: List<QuizQuestion>.from(questions),
    );
    _customQuizSets.insert(0, set);
    notifyListeners();
  }

  void deleteCustomQuizSet(String id) {
    _customQuizSets.removeWhere((set) => set.id == id);
    notifyListeners();
  }

  List<QuizSet> getRecentCustomQuizSets(int limit) {
    if (_customQuizSets.length <= limit) {
      return List<QuizSet>.from(_customQuizSets);
    }
    return _customQuizSets.sublist(0, limit);
  }

  QuizSet? findQuizSetById(String id) {
    for (final QuizSet set in _defaultQuizSets) {
      if (set.id == id) return set;
    }
    for (final QuizSet set in _customQuizSets) {
      if (set.id == id) return set;
    }
    return null;
  }
}
