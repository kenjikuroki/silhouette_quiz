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

  static const int freeCustomQuizLimit = 2;

  List<QuizSet> get defaultQuizSets => List.unmodifiable(_defaultQuizSets);
  List<QuizSet> get customQuizSets => _customQuizBox.values.toList().cast<QuizSet>().reversed.toList();

  bool get isFullVersionPurchased => purchaseService.isFullVersionPurchased;

  Future<void> initialize() async {
    _customQuizBox = await Hive.openBox<QuizSet>(customQuizBoxName);
    _metaBox = await Hive.openBox<List>('quiz_meta');
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
            answerText: 'ちょうちょ|ばたふらい|butterfly|mariposa',
          ),
          QuizQuestion(
            id: 'animal_cat',
            silhouetteImagePath: 'assets/images/quiz/animal/cat_b.png',
            originalImagePath: 'assets/images/quiz/animal/cat.png',
            answerText: 'ねこ|きゃっと|cat|gato',
          ),
          QuizQuestion(
            id: 'animal_dog',
            silhouetteImagePath: 'assets/images/quiz/animal/dog_b.png',
            originalImagePath: 'assets/images/quiz/animal/dog.png',
            answerText: 'いぬ|どっぐ|dog|perro',
          ),
          QuizQuestion(
            id: 'animal_elephant',
            silhouetteImagePath: 'assets/images/quiz/animal/elephant_b.png',
            originalImagePath: 'assets/images/quiz/animal/elephant.png',
            answerText: 'ぞう|えれふぁんと|elephant|elefante',
          ),
          QuizQuestion(
            id: 'animal_giraffe',
            silhouetteImagePath: 'assets/images/quiz/animal/giraffe_b.png',
            originalImagePath: 'assets/images/quiz/animal/giraffe.png',
            answerText: 'きりん|じらふ|giraffe|jirafa',
          ),
          QuizQuestion(
            id: 'animal_penguin',
            silhouetteImagePath: 'assets/images/quiz/animal/penguin_b.png',
            originalImagePath: 'assets/images/quiz/animal/penguin.png',
            answerText: 'ぺんぎん|ぺんぎん|penguin|pingüino',
          ),
          QuizQuestion(
            id: 'animal_rabbit',
            silhouetteImagePath: 'assets/images/quiz/animal/rabbit_b.png',
            originalImagePath: 'assets/images/quiz/animal/rabbit.png',
            answerText: 'うさぎ|らびっと|rabbit|conejo',
          ),
          QuizQuestion(
            id: 'animal_snake',
            silhouetteImagePath: 'assets/images/quiz/animal/snake_b.png',
            originalImagePath: 'assets/images/quiz/animal/snake.png',
            answerText: 'へび|すねーく|snake|serpiente',
          ),
          QuizQuestion(
            id: 'animal_turtle',
            silhouetteImagePath: 'assets/images/quiz/animal/turtle_b.png',
            originalImagePath: 'assets/images/quiz/animal/turtle.png',
            answerText: 'かめ|たーとる|turtle|tortuga',
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
            answerText: 'りんご|あっぷる|apple|manzana',
          ),
          QuizQuestion(
            id: 'food_banana',
            silhouetteImagePath: 'assets/images/quiz/food/banana_b.png',
            originalImagePath: 'assets/images/quiz/food/banana.png',
            answerText: 'ばなな|ばなな|banana|banana',
          ),

          QuizQuestion(
            id: 'food_candy',
            silhouetteImagePath: 'assets/images/quiz/food/candy_b.png',
            originalImagePath: 'assets/images/quiz/food/candy.png',
            answerText: 'あめ|きゃんでぃ|candy|caramelo',
          ),
          QuizQuestion(
            id: 'food_croissant',
            silhouetteImagePath: 'assets/images/quiz/food/croissant_b.png',
            originalImagePath: 'assets/images/quiz/food/croissant.png',
            answerText: 'くろわっさん|くろわっさん|croissant|croissant',
          ),
          QuizQuestion(
            id: 'food_donut',
            silhouetteImagePath: 'assets/images/quiz/food/donut_b.png',
            originalImagePath: 'assets/images/quiz/food/donut.png',
            answerText: 'どーなつ|どーなつ|donut|dona',
          ),
          QuizQuestion(
            id: 'food_grapes',
            silhouetteImagePath: 'assets/images/quiz/food/grapes_b.png',
            originalImagePath: 'assets/images/quiz/food/grapes.png',
            answerText: 'ぶどう|ぐれーぷす|grapes|uvas',
          ),
          QuizQuestion(
            id: 'food_hamburger',
            silhouetteImagePath: 'assets/images/quiz/food/hamburger_b.png',
            originalImagePath: 'assets/images/quiz/food/hamburger.png',
            answerText: 'はんばーがー|はんばーがー|hamburger|hamburguesa',
          ),
          QuizQuestion(
            id: 'food_ice_cream',
            silhouetteImagePath: 'assets/images/quiz/food/ice_cream_b.png',
            originalImagePath: 'assets/images/quiz/food/ice_cream.png',
            answerText: 'あいす|あいすくりーむ|ice cream|helado',
          ),
          QuizQuestion(
            id: 'food_pineapple',
            silhouetteImagePath: 'assets/images/quiz/food/pineapple_b.png',
            originalImagePath: 'assets/images/quiz/food/pineapple.png',
            answerText: 'ぱいなっぷる|ぱいなっぷる|pineapple|piña',
          ),
          QuizQuestion(
            id: 'food_pizza',
            silhouetteImagePath: 'assets/images/quiz/food/pizza_b.png',
            originalImagePath: 'assets/images/quiz/food/pizza.png',
            answerText: 'ぴざ|ぴざ|pizza|pizza',
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
            answerText: 'ひこうき|えあぷれーん|airplane|avión',
          ),
          QuizQuestion(
            id: 'vehicle_bicycle',
            silhouetteImagePath: 'assets/images/quiz/vehicle/bicycle_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/bicycle.png',
            answerText: 'じてんしゃ|ばいしくる|bicycle|bicicleta',
          ),
          QuizQuestion(
            id: 'vehicle_bus',
            silhouetteImagePath: 'assets/images/quiz/vehicle/bus_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/bus.png',
            answerText: 'バス|ばす|bus|autobús',
          ),
          QuizQuestion(
            id: 'vehicle_car',
            silhouetteImagePath: 'assets/images/quiz/vehicle/car_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/car.png',
            answerText: 'くるま|かー|car|auto',
          ),
          QuizQuestion(
            id: 'vehicle_helicopter',
            silhouetteImagePath: 'assets/images/quiz/vehicle/helicopter_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/helicopter.png',
            answerText: 'へりこぷたー|へりこぷたー|helicopter|helicóptero',
          ),
          QuizQuestion(
            id: 'vehicle_motorcycle',
            silhouetteImagePath: 'assets/images/quiz/vehicle/motorcycle_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/motorcycle.png',
            answerText: 'ばいく|もーたーさいくる|motorcycle|motocicleta',
          ),
          QuizQuestion(
            id: 'vehicle_rocket',
            silhouetteImagePath: 'assets/images/quiz/vehicle/rocket_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/rocket.png',
            answerText: 'ろけっと|ろけっと|rocket|cohete',
          ),
          QuizQuestion(
            id: 'vehicle_train',
            silhouetteImagePath: 'assets/images/quiz/vehicle/train_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/train.png',
            answerText: 'きしゃ|とれいん|train|tren',
          ),
          QuizQuestion(
            id: 'vehicle_yacht',
            silhouetteImagePath: 'assets/images/quiz/vehicle/yacht_b.png',
            originalImagePath: 'assets/images/quiz/vehicle/yacht.png',
            answerText: 'よっと|よっと|yacht|yate',
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
            answerText: 'はんがー|はんがー|hanger|percha',
          ),
          QuizQuestion(
            id: 'home_comb',
            silhouetteImagePath: 'assets/images/quiz/home/comb_b.png',
            originalImagePath: 'assets/images/quiz/home/comb.png',
            answerText: 'くし|くし|comb|peine',
          ),
          QuizQuestion(
            id: 'home_glasses',
            silhouetteImagePath: 'assets/images/quiz/home/glasses_b.png',
            originalImagePath: 'assets/images/quiz/home/glasses.png',
            answerText: 'めがね|めがね|glasses|gafas',
          ),
          QuizQuestion(
            id: 'home_key',
            silhouetteImagePath: 'assets/images/quiz/home/kye_b.png',
            originalImagePath: 'assets/images/quiz/home/kye.png',
            answerText: 'かぎ|かぎ|key|llave',
          ),
          QuizQuestion(
            id: 'home_light_bulb',
            silhouetteImagePath: 'assets/images/quiz/home/light_bulb_b.png',
            originalImagePath: 'assets/images/quiz/home/light bulb.png',
            answerText: 'でんきゅう|らいとばるぶ|light bulb|bombilla',
          ),
          QuizQuestion(
            id: 'home_safety_pin',
            silhouetteImagePath: 'assets/images/quiz/home/safetyz_pin_b.png',
            originalImagePath: 'assets/images/quiz/home/safetyz_pin.png',
            answerText: 'あんぜんぴん|せーふてぃぴん|safety pin|imperdible',
          ),
          QuizQuestion(
            id: 'home_toothbrush',
            silhouetteImagePath: 'assets/images/quiz/home/toothbrush_b.png',
            originalImagePath: 'assets/images/quiz/home/toothbrush.png',
            answerText: 'はぶらし|つーすぶらし|toothbrush|cepillo de dientes',
          ),
          QuizQuestion(
            id: 'home_umbrella',
            silhouetteImagePath: 'assets/images/quiz/home/umbrella_b.png',
            originalImagePath: 'assets/images/quiz/home/umbrella.png',
            answerText: 'かさ|あんぶれら|umbrella|paraguas',
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
            answerText: 'まないた|かってぃんぐぼーど|cutting board|tabla de cortar',
          ),
          QuizQuestion(
            id: 'kitchen_frying_pan',
            silhouetteImagePath: 'assets/images/quiz/kitchen/frying_pan_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/frying_pan.png',
            answerText: 'ふらいぱん|ふらいぱん|frying pan|sartén',
          ),
          QuizQuestion(
            id: 'kitchen_knife',
            silhouetteImagePath: 'assets/images/quiz/kitchen/kitchen_knife_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/kitchen_knife.png',
            answerText: 'ほうちょう|ないふ|knife|cuchillo',
          ),
          QuizQuestion(
            id: 'kitchen_ladle',
            silhouetteImagePath: 'assets/images/quiz/kitchen/ladle_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/ladle.png',
            answerText: 'おたま|れーどる|ladle|cucharón',
          ),
          QuizQuestion(
            id: 'kitchen_oven_mitt',
            silhouetteImagePath: 'assets/images/quiz/kitchen/oven_mitt_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/oven_mitt.png',
            answerText: 'みとん|おーぶんみっと|oven mitt|guante de horno',
          ),
          QuizQuestion(
            id: 'kitchen_peeler',
            silhouetteImagePath: 'assets/images/quiz/kitchen/peeler_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/peeler.png',
            answerText: 'ぴーらー|ぴーらー|peeler|pelador',
          ),
          QuizQuestion(
            id: 'kitchen_pot',
            silhouetteImagePath: 'assets/images/quiz/kitchen/pot_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/pot.png',
            answerText: 'なべ|ぽっと|pot|olla',
          ),
          QuizQuestion(
            id: 'kitchen_spatula',
            silhouetteImagePath: 'assets/images/quiz/kitchen/spatula_b.png',
            originalImagePath: 'assets/images/quiz/kitchen/spatula.png',
            answerText: 'ふらいがえし|すぱちゅら|spatula|espátula',
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
            answerText: 'こんぱす|こんぱす|compass|compás',
          ),
          QuizQuestion(
            id: 'school_fountain_pen',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/fountain_pen_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/fountain_pen.png',
            answerText: 'まんねんひつ|ふぁうんてんぺん|fountain pen|pluma fuente',
          ),
          QuizQuestion(
            id: 'school_paint_palette',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/paint_palette_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/paint_palette.png',
            answerText: 'ぱれっと|ぱれっと|palette|paleta',
          ),

          QuizQuestion(
            id: 'school_pencil',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/pencil_enpithu_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/pencil_enpithu.png',
            answerText: 'えんぴつ|ぺんしる|pencil|lápiz',
          ),
          QuizQuestion(
            id: 'school_protractor',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/protractor_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/protractor.png',
            answerText: 'ぶんどき|ぷろとらくたー|protractor|transportador',
          ),
          QuizQuestion(
            id: 'school_scissors',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/scissors_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/scissors.png',
            answerText: 'はさみ|しざーず|scissors|tijeras',
          ),
          QuizQuestion(
            id: 'school_stapler',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/stapler_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/stapler.png',
            answerText: 'ほっちきす|すてーぷらー|stapler|grapadora',
          ),
          QuizQuestion(
            id: 'school_thumbtack',
            silhouetteImagePath: 'assets/images/quiz/school_supplies/thumbtack_b.png',
            originalImagePath: 'assets/images/quiz/school_supplies/thumbtack.png',
            answerText: 'がびょう|さむたっく|thumbtack|tachuela',
          ),
        ],
      ),

      // 7. Sports (New)
      QuizSet(
        id: 'sports_1',
        title: 'すぽーつ',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'sports_baseball',
            silhouetteImagePath: 'assets/images/quiz/sports/baseball_b.png',
            originalImagePath: 'assets/images/quiz/sports/baseball.png',
            answerText: 'やきゅう|べーすぼーる|baseball|béisbol',
          ),
          QuizQuestion(
            id: 'sports_bowling',
            silhouetteImagePath: 'assets/images/quiz/sports/boring_b.png',
            originalImagePath: 'assets/images/quiz/sports/boring.png',
            answerText: 'ぼうりんぐ|ぼうりんぐ|bowling|bolos',
          ),
          QuizQuestion(
            id: 'sports_boxing',
            silhouetteImagePath: 'assets/images/quiz/sports/boxing_b.png',
            originalImagePath: 'assets/images/quiz/sports/boxing.png',
            answerText: 'ぼくしんぐ|ぼくしんぐ|boxing|boxeo',
          ),
          QuizQuestion(
            id: 'sports_golf',
            silhouetteImagePath: 'assets/images/quiz/sports/golf_b.png',
            originalImagePath: 'assets/images/quiz/sports/golf.png',
            answerText: 'ごるふ|ごるふ|golf|golf',
          ),
          QuizQuestion(
            id: 'sports_pingpong',
            silhouetteImagePath: 'assets/images/quiz/sports/pingpong_b.png',
            originalImagePath: 'assets/images/quiz/sports/pingpong.png',
            answerText: 'たっきゅう|ぴんぽん|ping pong|tenis de mesa',
          ),
          QuizQuestion(
            id: 'sports_soccer',
            silhouetteImagePath: 'assets/images/quiz/sports/soccer_b.png',
            originalImagePath: 'assets/images/quiz/sports/soccer.png',
            answerText: 'さっかー|さっかー|soccer|fútbol',
          ),
          QuizQuestion(
            id: 'sports_tennis',
            silhouetteImagePath: 'assets/images/quiz/sports/tennis_b.png',
            originalImagePath: 'assets/images/quiz/sports/tennis.png',
            answerText: 'てにす|てにす|tennis|tenis',
          ),
        ],
      ),

      // 8. Instruments (New)
      QuizSet(
        id: 'instruments_1',
        title: 'がっき',
        isCustom: false,
        questions: [
          QuizQuestion(
            id: 'instruments_castanets',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Castanets_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Castanets.png',
            answerText: 'かすたねっと|かすたねっと|castanets|castañuelas',
          ),
          QuizQuestion(
            id: 'instruments_drum',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Drum_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Drum.png',
            answerText: 'たいこ|どらむ|drum|tambor',
          ),
          QuizQuestion(
            id: 'instruments_maracas',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Maracas_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Maracas.png',
            answerText: 'まらかす|まらかす|maracas|maracas',
          ),
          QuizQuestion(
            id: 'instruments_sax',
            silhouetteImagePath: 'assets/images/quiz/Instruments/SAX_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/SAX.png',
            answerText: 'さっくす|さっくす|saxophone|saxofón',
          ),
          QuizQuestion(
            id: 'instruments_tambourine',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Tambourine_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Tambourine.png',
            answerText: 'たんばりん|たんばりん|tambourine|pandereta',
          ),
          QuizQuestion(
            id: 'instruments_trumpet',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Trumpet_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Trumpet.png',
            answerText: 'とらんぺっと|とらんぺっと|trumpet|trompeta',
          ),
          QuizQuestion(
            id: 'instruments_xylophone',
            silhouetteImagePath: 'assets/images/quiz/Instruments/Xylophone_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/Xylophone.png',
            answerText: 'もっきん|ざいろふぉん|xylophone|xilófono',
          ),
          QuizQuestion(
            id: 'instruments_guitar',
            silhouetteImagePath: 'assets/images/quiz/Instruments/guitar_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/guitar.png',
            answerText: 'ぎたー|ぎたー|guitar|guitarra',
          ),
          QuizQuestion(
            id: 'instruments_piano',
            silhouetteImagePath: 'assets/images/quiz/Instruments/piano_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/piano.png',
            answerText: 'ぴあの|ぴあの|piano|piano',
          ),
          QuizQuestion(
            id: 'instruments_violin',
            silhouetteImagePath: 'assets/images/quiz/Instruments/violin_b.png',
            originalImagePath: 'assets/images/quiz/Instruments/violin.png',
            answerText: 'ばいおりん|ばいおりん|violin|violín',
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
