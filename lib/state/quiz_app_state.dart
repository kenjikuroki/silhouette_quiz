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
      // 1. Animal
      QuizSet(
        id: 'animal_1',
        title: 'どうぶつ',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'animal_butterfly',
            silhouetteImagePath: 'assets/images/quiz/animal/butterfly_b.png',
            originalImagePath: 'assets/images/quiz/animal/butterfly.png',
            answerText: 'ちょうちょ|ばたふらい|butterfly',
          ),
          QuizQuestion(
            id: 'animal_cat',
            silhouetteImagePath: 'assets/images/quiz/animal/cat_b.png',
            originalImagePath: 'assets/images/quiz/animal/cat.png',
            answerText: 'ねこ|きゃっと|cat',
          ),
          QuizQuestion(
            id: 'animal_dog',
            silhouetteImagePath: 'assets/images/quiz/animal/dog_b.png',
            originalImagePath: 'assets/images/quiz/animal/dog.png',
            answerText: 'いぬ|どっぐ|dog',
          ),
          QuizQuestion(
            id: 'animal_elephant',
            silhouetteImagePath: 'assets/images/quiz/animal/elephant_b.png',
            originalImagePath: 'assets/images/quiz/animal/elephant.png',
            answerText: 'ぞう|えれふぁんと|elephant',
          ),
          QuizQuestion(
            id: 'animal_giraffe',
            silhouetteImagePath: 'assets/images/quiz/animal/giraffe_b.png',
            originalImagePath: 'assets/images/quiz/animal/giraffe.png',
            answerText: 'きりん|じらふ|giraffe',
          ),
          QuizQuestion(
            id: 'animal_penguin',
            silhouetteImagePath: 'assets/images/quiz/animal/penguin_b.png',
            originalImagePath: 'assets/images/quiz/animal/penguin.png',
            answerText: 'ぺんぎん|ぺんぎん|penguin',
          ),
          QuizQuestion(
            id: 'animal_rabbit',
            silhouetteImagePath: 'assets/images/quiz/animal/rabbit_b.png',
            originalImagePath: 'assets/images/quiz/animal/rabbit.png',
            answerText: 'うさぎ|らびっと|rabbit',
          ),
          QuizQuestion(
            id: 'animal_snake',
            silhouetteImagePath: 'assets/images/quiz/animal/snake_b.png',
            originalImagePath: 'assets/images/quiz/animal/snake.png',
            answerText: 'へび|すねーく|snake',
          ),
          QuizQuestion(
            id: 'animal_turtle',
            silhouetteImagePath: 'assets/images/quiz/animal/turtle_b.png',
            originalImagePath: 'assets/images/quiz/animal/turtle.png',
            answerText: 'かめ|たーとる|turtle',
          ),
        ],
      ),

      // 2. Food
      QuizSet(
        id: 'food_1',
        title: 'たべもの',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'food_apple',
            silhouetteImagePath: 'assets/images/quiz/food/apple_b.png',
            originalImagePath: 'assets/images/quiz/food/apple.png',
            answerText: 'りんご|あっぷる|apple',
          ),

          QuizQuestion(
            id: 'food_candy',
            silhouetteImagePath: 'assets/images/quiz/food/candy_b.png',
            originalImagePath: 'assets/images/quiz/food/candy.png',
            answerText: 'あめ|きゃんでぃ|candy',
          ),
          QuizQuestion(
            id: 'food_croissant',
            silhouetteImagePath: 'assets/images/quiz/food/croissant_b.png',
            originalImagePath: 'assets/images/quiz/food/croissant.png',
            answerText: 'くろわっさん|くろわっさん|croissant',
          ),
          QuizQuestion(
            id: 'food_donut',
            silhouetteImagePath: 'assets/images/quiz/food/donut_b.png',
            originalImagePath: 'assets/images/quiz/food/donut.png',
            answerText: 'どーなつ|どーなつ|donut',
          ),
          QuizQuestion(
            id: 'food_grapes',
            silhouetteImagePath: 'assets/images/quiz/food/grapes_b.png',
            originalImagePath: 'assets/images/quiz/food/grapes.png',
            answerText: 'ぶどう|ぐれーぷす|grapes',
          ),
          QuizQuestion(
            id: 'food_hamburger',
            silhouetteImagePath: 'assets/images/quiz/food/hamburger_b.png',
            originalImagePath: 'assets/images/quiz/food/hamburger.png',
            answerText: 'はんばーがー|はんばーがー|hamburger',
          ),
          QuizQuestion(
            id: 'food_ice_cream',
            silhouetteImagePath: 'assets/images/quiz/food/ice_cream_b.png',
            originalImagePath: 'assets/images/quiz/food/ice_cream.png',
            answerText: 'あいす|あいすくりーむ|ice cream',
          ),
          QuizQuestion(
            id: 'food_pineapple',
            silhouetteImagePath: 'assets/images/quiz/food/pineapple_b.png',
            originalImagePath: 'assets/images/quiz/food/pineapple.png',
            answerText: 'ぱいなっぷる|ぱいなっぷる|pineapple',
          ),
          QuizQuestion(
            id: 'food_pizza',
            silhouetteImagePath: 'assets/images/quiz/food/pizza_b.png',
            originalImagePath: 'assets/images/quiz/food/pizza.png',
            answerText: 'ぴざ|ぴざ|pizza',
          ),
        ],
      ),

      // 3. Vehicle
      QuizSet(
        id: 'vehicle_1',
        title: 'のりもの',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'vehicle_airplane',
            silhouetteImagePath: 'assets/images/quiz/vehicle/airplane_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/airplane.png',
            answerText: 'ひこうき|えあぷれーん|airplane',
          ),
          QuizQuestion(
            id: 'vehicle_bicycle',
            silhouetteImagePath: 'assets/images/quiz/vehicle/bicycle_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/bicycle.png',
            answerText: 'じてんしゃ|ばいしくる|bicycle',
          ),
          QuizQuestion(
            id: 'vehicle_bus',
            silhouetteImagePath: 'assets/images/quiz/vehicle/bus_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/bus.png',
            answerText: 'バス|ばす|bus',
          ),
          QuizQuestion(
            id: 'vehicle_car',
            silhouetteImagePath: 'assets/images/quiz/vehicle/car_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/car.png',
            answerText: 'くるま|かー|car',
          ),
          QuizQuestion(
            id: 'vehicle_helicopter',
            silhouetteImagePath: 'assets/images/quiz/vehicle/helicopter_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/helicopter.png',
            answerText: 'へりこぷたー|へりこぷたー|helicopter',
          ),
          QuizQuestion(
            id: 'vehicle_motorcycle',
            silhouetteImagePath: 'assets/images/quiz/vehicle/motorcycle_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/motorcycle.png',
            answerText: 'ばいく|もーたーさいくる|motorcycle',
          ),
          QuizQuestion(
            id: 'vehicle_rocket',
            silhouetteImagePath: 'assets/images/quiz/vehicle/rocket_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/rocket.png',
            answerText: 'ろけっと|ろけっと|rocket',
          ),
          QuizQuestion(
            id: 'vehicle_train',
            silhouetteImagePath: 'assets/images/quiz/vehicle/train_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/train.png',
            answerText: 'きしゃ|とれいん|train',
          ),
          QuizQuestion(
            id: 'vehicle_yacht',
            silhouetteImagePath: 'assets/images/quiz/vehicle/yacht_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/yacht.png',
            answerText: 'よっと|よっと|yacht',
          ),
        ],
      ),

      // 4. Home
      QuizSet(
        id: 'home_1',
        title: 'いえにあるもの',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'home_clothes_hanger',
            silhouetteImagePath: 'assets/images/quiz/home/clothes_hanger_b.png',
            originalImagePath: 'assets/images/quiz/home/clothes_hanger.png',
            answerText: 'はんがー|はんがー|hanger',
          ),
          QuizQuestion(
            id: 'home_comb',
            silhouetteImagePath: 'assets/images/quiz/home/comb_b.png',
            originalImagePath: 'assets/images/quiz/home/comb.png',
            answerText: 'くし|くし|comb',
          ),
          QuizQuestion(
            id: 'home_glasses',
            silhouetteImagePath: 'assets/images/quiz/home/glasses_b.png',
            originalImagePath: 'assets/images/quiz/home/glasses.png',
            answerText: 'めがね|めがね|glasses',
          ),
          QuizQuestion(
            id: 'home_key',
            silhouetteImagePath: 'assets/images/quiz/home/kye_b.png',
            originalImagePath: 'assets/images/quiz/home/kye.png',
            answerText: 'かぎ|かぎ|key',
          ),
          QuizQuestion(
            id: 'home_light_bulb',
            silhouetteImagePath: 'assets/images/quiz/home/light_bulb_b.png',
            originalImagePath: 'assets/images/quiz/home/light bulb.png',
            answerText: 'でんきゅう|らいとばるぶ|light bulb',
          ),
          QuizQuestion(
            id: 'home_safety_pin',
            silhouetteImagePath: 'assets/images/quiz/home/safetyz_pin_b.png',
            originalImagePath: 'assets/images/quiz/home/safetyz_pin.png',
            answerText: 'あんぜんぴん|せーふてぃぴん|safety pin',
          ),
          QuizQuestion(
            id: 'home_toothbrush',
            silhouetteImagePath: 'assets/images/quiz/home/toothbrush_b.png',
            originalImagePath: 'assets/images/quiz/home/toothbrush.png',
            answerText: 'はぶらし|つーすぶらし|toothbrush',
          ),
          QuizQuestion(
            id: 'home_umbrella',
            silhouetteImagePath: 'assets/images/quiz/home/umbrella_b.png',
            originalImagePath: 'assets/images/quiz/home/umbrella.png',
            answerText: 'かさ|あんぶれら|umbrella',
          ),
        ],
      ),

      // 5. Kitchen (New)
      QuizSet(
        id: 'kitchen_1',
        title: 'だいどころにあるもの',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'kitchen_cutting_board',
            silhouetteImagePath: 'assets/images/quiz/kitchen/cutting_board_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/cutting_board.png',
            answerText: 'まないた|かってぃんぐぼーど|cutting board',
          ),
          QuizQuestion(
            id: 'kitchen_frying_pan',
            silhouetteImagePath: 'assets/images/quiz/kitchen/frying_pan_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/frying_pan.png',
            answerText: 'ふらいぱん|ふらいぱん|frying pan',
          ),
          QuizQuestion(
            id: 'kitchen_knife',
            silhouetteImagePath: 'assets/images/quiz/kitchen/kitchen_knife_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/kitchen_knife.png',
            answerText: 'ほうちょう|ないふ|knife',
          ),
          QuizQuestion(
            id: 'kitchen_ladle',
            silhouetteImagePath: 'assets/images/quiz/kitchen/ladle_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/ladle.png',
            answerText: 'おたま|れーどる|ladle',
          ),
          QuizQuestion(
            id: 'kitchen_oven_mitt',
            silhouetteImagePath: 'assets/images/quiz/kitchen/oven_mitt_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/oven_mitt.png',
            answerText: 'みとん|おーぶんみっと|oven mitt',
          ),
          QuizQuestion(
            id: 'kitchen_peeler',
            silhouetteImagePath: 'assets/images/quiz/kitchen/peeler_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/peeler.png',
            answerText: 'ぴーらー|ぴーらー|peeler',
          ),
          QuizQuestion(
            id: 'kitchen_pot',
            silhouetteImagePath: 'assets/images/quiz/kitchen/pot_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/pot.png',
            answerText: 'なべ|ぽっと|pot',
          ),
          QuizQuestion(
            id: 'kitchen_spatula',
            silhouetteImagePath: 'assets/images/quiz/kitchen/spatula_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/spatula.png',
            answerText: 'ふらいがえし|すぱちゅら|spatula',
          ),
        ],
      ),

      // 6. School Supplies (New)
      QuizSet(
        id: 'school_supplies_1',
        title: 'ぶんぼうぐ',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'school_compass',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/compass_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/compass.png',
            answerText: 'こんぱす|こんぱす|compass',
          ),
          QuizQuestion(
            id: 'school_fountain_pen',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/fountain_pen_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/fountain_pen.png',
            answerText: 'まんねんひつ|ふぁうんてんぺん|fountain pen',
          ),
          QuizQuestion(
            id: 'school_paint_palette',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/paint_palette_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/paint_palette.png',
            answerText: 'ぱれっと|ぱれっと|palette',
          ),

          QuizQuestion(
            id: 'school_pencil',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/pencil_enpithu_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/pencil_enpithu.png',
            answerText: 'えんぴつ|ぺんしる|pencil',
          ),
          QuizQuestion(
            id: 'school_protractor',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/protractor_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/protractor.png',
            answerText: 'ぶんどき|ぷろとらくたー|protractor',
          ),
          QuizQuestion(
            id: 'school_scissors',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/scissors_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/scissors.png',
            answerText: 'はさみ|しざーず|scissors',
          ),
          QuizQuestion(
            id: 'school_stapler',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/stapler_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/stapler.png',
            answerText: 'ほっちきす|すてーぷらー|stapler',
          ),
          QuizQuestion(
            id: 'school_thumbtack',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/thumbtack_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/thumbtack.png',
            answerText: 'がびょう|さむたっく|thumbtack',
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
