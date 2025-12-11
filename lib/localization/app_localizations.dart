import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'AppLocalizations not found in context');
    return result!;
  }

  static const List<Locale> supportedLocales = [
    Locale('ja'),
    Locale('en'),
    Locale('es'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'ja': {
      // Home
      'home_title': 'シルエットクイズ',
      'home_start_button': 'スタート',
      'home_mode_create': 'じぶんでつくる',
      'home_mode_challenge': 'チャレンジする',

      // Challenge
      'challenge_title': 'チャレンジする',
      'challenge_default_section_title': 'みんなのクイズ',
      'challenge_custom_section_title': 'つくったクイズ',
      'challenge_more_button': 'もっとみる',

      // Categories (default)
      'category_vehicle': 'のりもの',
      'category_food': 'たべもの',
      'category_animal': 'どうぶつ',
      'category_home': 'おうちのなかクイズ',

      // Quiz set titles
      'quiz_set_animals': 'どうぶつ',
      'quiz_set_food': 'たべもの',
      'quiz_set_vehicle': 'のりもの',
      'quiz_set_home_items': 'いえにあるもの',
      'quiz_set_kitchen_items': 'だいどころにあるもの',
      'quiz_set_stationery': 'ぶんぼうぐ',

      // Custom list
      'custom_list_title': 'つくったクイズ',
      'custom_list_empty': 'まだ じぶんのクイズは ありません',
      'custom_list_quiz_count': '{count} もん',

      // Create flow
      'create_intro_title': 'クイズをつくろう',
      'create_intro_message':
          'しゃしんをとって じぶんだけの シルエットクイズを つくろう！\nさいだい 5まい まで とれるよ。',
      'create_intro_start_button': 'はじめる',
      'create_capture_title': 'しゃしんをとる',
      'create_capture_add_dummy': 'しゃしんを 1まい とる',
      'create_capture_count': 'いま {count} まい',
      'create_capture_item_label': '{number}まいめ',
      'create_capture_finish': 'かんりょう',
      'create_capture_limit_message': 'これいじょう は とれません（5まい まで）',
      'create_capture_error_message': 'エラーが発生しました: {error}',
      'create_capture_no_silhouette': 'シルエットがありません',
      'capture_delete_title': 'このクイズを けす？',
      'capture_delete_message': 'あとから もどせないよ。',
      'capture_delete_ok': 'けす',
      'create_confirm_title': 'これで いい？',
      'create_confirm_message': 'できあがったクイズの なまえを きめよう',
      'create_confirm_title_label': 'クイズの なまえ',
      'create_confirm_default_title': 'クイズ{number}',
      'create_confirm_save_button': 'これでOK！',
      'create_confirm_back_button': 'もどる',
      'create_confirm_complete_title': 'かんせい！',
      'create_confirm_complete_message': 'クイズの じゅんびが できたよ！',
      'create_confirm_celebration_title': 'かんせい！',

      // Play quiz
      'play_quiz_title': 'クイズ',
      'play_quiz_show_answer': 'こたえをみる',
      'play_quiz_next': 'つぎへ',
      'play_quiz_finish': 'おわる',
      'play_quiz_answer_label': 'こたえ',
      'play_quiz_correct': 'あってた！',
      'play_quiz_incorrect': 'ちがった',
      'play_quiz_result_title': 'けっか',
      'play_quiz_result_message': '{total}もん ちゅう {correct}もん せいかい！',
      'play_quiz_not_found': 'クイズが みつかりません',
      'play_quiz_placeholder_title': 'シルエット {number}',
      'play_quiz_celebration_title': 'がんばったね！',

      // Delete
      'delete_quiz_confirm_title': 'このクイズを けす？',
      'delete_quiz_confirm_message':
          'このクイズに ふくまれる もんだい は\nすべて けされます。',
      'common_delete': 'けす',
      'common_cancel': 'やめる',

      // Paywall
      'paywall_title': 'もっと つくるには？',
      'paywall_message':
          'じぶんで つくった クイズは 3つ まで むりょうで つくれます。\nそれ いじょう つくるには、\nいちどだけ 100円で ぜんぶ つかえるように なります。',
      'paywall_buy_button': '100円で かう',
      'paywall_later_button': 'あとで',

      // Premium Promotion
      'premium_promotion_title': 'プレミアム版のお知らせ',
      'premium_promotion_message': '・ロック中の3つのカテゴリであそべるようになります。\n・自分で作れるクイズリストを3つ以上作成できます。\n・一度の購入で、ずっと使えます。',
      'premium_promotion_buy_button': '100円でプレミアム版を購入',
      'premium_restore_button': '購入を復元する',
      'purchase_complete_title': 'ありがとう！',
      'purchase_complete_message': 'プレミアム版になったよ！\nたくさんクイズをつくってね！',
      'purchase_complete_celebration': 'ありがとう！',

      // Parental Gate
      'parental_gate_title': '保護者の方へ',
      'parental_gate_message': '問題の答えは？',
      'parental_gate_failed': 'ちがいます',

      // Common
      'common_ok': 'OK',
      'badge_new_label': 'NEW',
      'image_load_error': '画像を読み込めません',
    },
    'en': {
      // Home
      'home_title': 'Silhouette Quiz',
      'home_start_button': 'Start',
      'home_mode_create': 'Make my quiz',
      'home_mode_challenge': 'Play quizzes',

      // Challenge
      'challenge_title': 'Challenge',
      'challenge_default_section_title': "Everyone's quizzes",
      'challenge_custom_section_title': 'Your quizzes',
      'challenge_more_button': 'See more',

      // Categories (default)
      'category_vehicle': 'Vehicles',
      'category_food': 'Food',
      'category_animal': 'Animals',
      'category_home': 'Indoor quiz',

      // Quiz set titles
      'quiz_set_animals': 'Animals',
      'quiz_set_food': 'Food',
      'quiz_set_vehicle': 'Vehicles',
      'quiz_set_home_items': 'Things at home',
      'quiz_set_kitchen_items': 'Kitchen tools',
      'quiz_set_stationery': 'School supplies',

      // Custom list
      'custom_list_title': 'Your quizzes',
      'custom_list_empty': 'No custom quizzes yet',
      'custom_list_quiz_count': '{count} questions',

      // Create flow
      'create_intro_title': "Let's make a quiz",
      'create_intro_message':
          'Take photos to make your own silhouette quiz!\nYou can take up to 5 pictures.',
      'create_intro_start_button': 'Start',
      'create_capture_title': 'Take a photo',
      'create_capture_add_dummy': 'Take one photo',
      'create_capture_count': 'Now {count}',
      'create_capture_item_label': 'Photo {number}',
      'create_capture_finish': 'Done',
      'create_capture_limit_message': 'You can only take up to 5 photos.',
      'create_capture_error_message': 'Something went wrong: {error}',
      'create_capture_no_silhouette': 'No silhouette available',
      'capture_delete_title': 'Delete this quiz?',
      'capture_delete_message': "You can't undo this.",
      'capture_delete_ok': 'Delete',
      'create_confirm_title': 'All good?',
      'create_confirm_message': 'Pick a name for your quiz.',
      'create_confirm_title_label': 'Quiz name',
      'create_confirm_default_title': 'Quiz {number}',
      'create_confirm_save_button': 'Looks good!',
      'create_confirm_back_button': 'Back',
      'create_confirm_complete_title': 'All done!',
      'create_confirm_complete_message': 'Your quiz is ready!',
      'create_confirm_celebration_title': 'Finished!',

      // Play quiz
      'play_quiz_title': 'Quiz',
      'play_quiz_show_answer': 'Show answer',
      'play_quiz_next': 'Next',
      'play_quiz_finish': 'Finish',
      'play_quiz_answer_label': 'Answer',
      'play_quiz_correct': 'Got it!',
      'play_quiz_incorrect': 'Not yet',
      'play_quiz_result_title': 'Results',
      'play_quiz_result_message': 'You got {correct} of {total} right!',
      'play_quiz_not_found': 'Quiz not found',
      'play_quiz_placeholder_title': 'Silhouette {number}',
      'play_quiz_celebration_title': 'Great job!',

      // Delete
      'delete_quiz_confirm_title': 'Delete this quiz?',
      'delete_quiz_confirm_message':
          'All of the questions inside this quiz will be deleted.',
      'common_delete': 'Delete',
      'common_cancel': 'Cancel',

      // Paywall
      'paywall_title': 'Want to make more?',
      'paywall_message':
          'You can create up to 3 custom quizzes for free.\nPay 100 yen once to unlock everything forever.',
      'paywall_buy_button': 'Buy for ¥100',
      'paywall_later_button': 'Later',

      // Premium Promotion
      'premium_promotion_title': 'About Premium',
      'premium_promotion_message':
          '- Play with the 3 locked categories.\n- Create more than 3 custom quiz lists.\n- One purchase lasts forever.',
      'premium_promotion_buy_button': 'Buy Premium',
      'premium_restore_button': 'Restore purchase',
      'purchase_complete_title': 'Thank you!',
      'purchase_complete_message':
          "You're now Premium!\nHave fun making quizzes!",
      'purchase_complete_celebration': 'Thanks!',

      // Parental Gate
      'parental_gate_title': 'For grown-ups',
      'parental_gate_message': 'What is the answer?',
      'parental_gate_failed': 'Try again',

      // Common
      'common_ok': 'OK',
      'badge_new_label': 'NEW',
      'image_load_error': 'Image load error',
    },
    'es': {
      // Home
      'home_title': 'Quiz de siluetas',
      'home_start_button': 'Comenzar',
      'home_mode_create': 'Crear mi quiz',
      'home_mode_challenge': 'Jugar quizzes',

      // Challenge
      'challenge_title': 'Desafío',
      'challenge_default_section_title': 'Quizzes de todos',
      'challenge_custom_section_title': 'Tus quizzes',
      'challenge_more_button': 'Ver más',

      // Categories (default)
      'category_vehicle': 'Vehículos',
      'category_food': 'Comida',
      'category_animal': 'Animales',
      'category_home': 'Quiz en casa',

      // Quiz set titles
      'quiz_set_animals': 'Animales',
      'quiz_set_food': 'Comida',
      'quiz_set_vehicle': 'Vehículos',
      'quiz_set_home_items': 'En casa',
      'quiz_set_kitchen_items': 'Cocina',
      'quiz_set_stationery': 'Útiles',

      // Custom list
      'custom_list_title': 'Tus quizzes',
      'custom_list_empty': 'Todavía no hay quizzes propios',
      'custom_list_quiz_count': '{count} preguntas',

      // Create flow
      'create_intro_title': 'Vamos a crear un quiz',
      'create_intro_message':
          'Toma fotos para hacer tu propio quiz de siluetas.\nPuedes tomar hasta 5 fotos.',
      'create_intro_start_button': 'Empezar',
      'create_capture_title': 'Tomar foto',
      'create_capture_add_dummy': 'Tomar una foto',
      'create_capture_count': 'Ahora {count}',
      'create_capture_item_label': 'Foto {number}',
      'create_capture_finish': 'Listo',
      'create_capture_limit_message': 'Solo puedes tomar 5 fotos.',
      'create_capture_error_message': 'Ocurrió un error: {error}',
      'create_capture_no_silhouette': 'Sin silueta todavía',
      'capture_delete_title': '¿Borrar este quiz?',
      'capture_delete_message': 'No se puede deshacer.',
      'capture_delete_ok': 'Borrar',
      'create_confirm_title': '¿Así está bien?',
      'create_confirm_message': 'Elige un nombre para tu quiz.',
      'create_confirm_title_label': 'Nombre del quiz',
      'create_confirm_default_title': 'Quiz {number}',
      'create_confirm_save_button': '¡Se ve bien!',
      'create_confirm_back_button': 'Volver',
      'create_confirm_complete_title': '¡Listo!',
      'create_confirm_complete_message': '¡Tu quiz está listo!',
      'create_confirm_celebration_title': '¡Terminado!',

      // Play quiz
      'play_quiz_title': 'Quiz',
      'play_quiz_show_answer': 'Ver respuesta',
      'play_quiz_next': 'Siguiente',
      'play_quiz_finish': 'Terminar',
      'play_quiz_answer_label': 'Respuesta',
      'play_quiz_correct': '¡Lo logré!',
      'play_quiz_incorrect': 'Aún no',
      'play_quiz_result_title': 'Resultados',
      'play_quiz_result_message': '¡Acertaste {correct} de {total}!',
      'play_quiz_not_found': 'No se encontró el quiz',
      'play_quiz_placeholder_title': 'Silueta {number}',
      'play_quiz_celebration_title': '¡Buen trabajo!',

      // Delete
      'delete_quiz_confirm_title': '¿Borrar este quiz?',
      'delete_quiz_confirm_message':
          'Todas las preguntas de este quiz se borrarán.',
      'common_delete': 'Borrar',
      'common_cancel': 'Cancelar',

      // Paywall
      'paywall_title': '¿Quieres crear más?',
      'paywall_message':
          'Puedes crear hasta 3 quizzes gratis.\nPaga 100 yenes una vez para usar todo para siempre.',
      'paywall_buy_button': 'Comprar por ¥100',
      'paywall_later_button': 'Después',

      // Premium Promotion
      'premium_promotion_title': 'Sobre Premium',
      'premium_promotion_message':
          '- Juega en las 3 categorías bloqueadas.\n- Crea más de 3 listas propias.\n- Con una compra lo usas siempre.',
      'premium_promotion_buy_button': 'Comprar Premium',
      'premium_restore_button': 'Restaurar compra',
      'purchase_complete_title': '¡Gracias!',
      'purchase_complete_message':
          '¡Ahora tienes Premium!\n¡Diviértete creando quizzes!',
      'purchase_complete_celebration': '¡Gracias!',

      // Parental Gate
      'parental_gate_title': 'Para adultos',
      'parental_gate_message': '¿Cuál es la respuesta?',
      'parental_gate_failed': 'No es correcto',

      // Common
      'common_ok': 'OK',
      'badge_new_label': 'NEW',
      'image_load_error': 'Error al cargar la imagen',
    },
  };

  String _translate(String key) {
    final Map<String, String>? values = _localizedValues[locale.languageCode];
    if (values == null) {
      return key;
    }
    return values[key] ?? key;
  }

  String get homeTitle => _translate('home_title');
  String get homeStartButton => _translate('home_start_button');
  String get homeModeCreate => _translate('home_mode_create');
  String get homeModeChallenge => _translate('home_mode_challenge');

  String get challengeTitle => _translate('challenge_title');
  String get challengeDefaultSectionTitle =>
      _translate('challenge_default_section_title');
  String get challengeCustomSectionTitle =>
      _translate('challenge_custom_section_title');
  String get challengeMoreButton => _translate('challenge_more_button');

  String get categoryVehicle => _translate('category_vehicle');
  String get categoryFood => _translate('category_food');
  String get categoryAnimal => _translate('category_animal');
  String get categoryHome => _translate('category_home');
  String get quizSetAnimals => _translate('quiz_set_animals');
  String get quizSetFood => _translate('quiz_set_food');
  String get quizSetVehicle => _translate('quiz_set_vehicle');
  String get quizSetHomeItems => _translate('quiz_set_home_items');
  String get quizSetKitchenItems => _translate('quiz_set_kitchen_items');
  String get quizSetStationery => _translate('quiz_set_stationery');

  String get customListTitle => _translate('custom_list_title');
  String get customListEmpty => _translate('custom_list_empty');
  String customListQuizCount(int count) {
    String template = _translate('custom_list_quiz_count');
    return template.replaceAll('{count}', count.toString());
  }

  String get createIntroTitle => _translate('create_intro_title');
  String get createIntroMessage => _translate('create_intro_message');
  String get createIntroStartButton => _translate('create_intro_start_button');
  String get createCaptureTitle => _translate('create_capture_title');
  String get createCaptureAddDummy => _translate('create_capture_add_dummy');
  String get createCaptureFinish => _translate('create_capture_finish');
  String get createCaptureLimitMessage =>
      _translate('create_capture_limit_message');
  String createCaptureItemLabel(int number) {
    String template = _translate('create_capture_item_label');
    return template.replaceAll('{number}', number.toString());
  }
  String get captureDeleteTitle => _translate('capture_delete_title');
  String get captureDeleteMessage => _translate('capture_delete_message');
  String get captureDeleteOk => _translate('capture_delete_ok');
  String get createConfirmTitle => _translate('create_confirm_title');
  String get createConfirmMessage => _translate('create_confirm_message');
  String get createConfirmTitleLabel => _translate('create_confirm_title_label');
  String get createConfirmSaveButton => _translate('create_confirm_save_button');
  String get createConfirmBackButton => _translate('create_confirm_back_button');
  String get createConfirmCompleteTitle =>
      _translate('create_confirm_complete_title');
  String get createConfirmCompleteMessage =>
      _translate('create_confirm_complete_message');
  String get createConfirmCelebrationTitle =>
      _translate('create_confirm_celebration_title');
  String createConfirmDefaultTitle(int number) {
    String template = _translate('create_confirm_default_title');
    if (template == 'create_confirm_default_title') {
      template = 'クイズ{number}';
    }
    return template.replaceAll('{number}', number.toString());
  }

  String get playQuizTitle => _translate('play_quiz_title');
  String get playQuizShowAnswer => _translate('play_quiz_show_answer');
  String get playQuizNext => _translate('play_quiz_next');
  String get playQuizFinish => _translate('play_quiz_finish');
  String get playQuizAnswerLabel => _translate('play_quiz_answer_label');

  String get playQuizCorrect => _translate('play_quiz_correct');
  String get playQuizIncorrect => _translate('play_quiz_incorrect');
  String get playQuizResultTitle => _translate('play_quiz_result_title');
  String get playQuizNotFound => _translate('play_quiz_not_found');
  String get playQuizCelebrationTitle =>
      _translate('play_quiz_celebration_title');
  String playQuizPlaceholderTitle(int number) {
    String template = _translate('play_quiz_placeholder_title');
    return template.replaceAll('{number}', number.toString());
  }

  String playQuizResultMessage(int correct, int total) {
    String template = _translate('play_quiz_result_message');
    return template
        .replaceAll('{correct}', correct.toString())
        .replaceAll('{total}', total.toString());
  }

  String get deleteQuizConfirmTitle => _translate('delete_quiz_confirm_title');
  String get deleteQuizConfirmMessage =>
      _translate('delete_quiz_confirm_message');
  String get commonDelete => _translate('common_delete');
  String get commonCancel => _translate('common_cancel');

  String get paywallTitle => _translate('paywall_title');
  String get paywallMessage => _translate('paywall_message');
  String get paywallBuyButton => _translate('paywall_buy_button');
  String get paywallLaterButton => _translate('paywall_later_button');

  String get premiumPromotionTitle => _translate('premium_promotion_title');
  String get premiumPromotionMessage => _translate('premium_promotion_message');
  String get premiumPromotionBuyButton => _translate('premium_promotion_buy_button');
  String get premiumRestoreButton => _translate('premium_restore_button');

  String get purchaseCompleteTitle => _translate('purchase_complete_title');
  String get purchaseCompleteMessage => _translate('purchase_complete_message');
  String get purchaseCompleteCelebration => _translate('purchase_complete_celebration');

  String get parentalGateTitle => _translate('parental_gate_title');
  String get parentalGateMessage => _translate('parental_gate_message');
  String get parentalGateFailed => _translate('parental_gate_failed');

  String get commonOk => _translate('common_ok');
  String get badgeNewLabel => _translate('badge_new_label');
  String get imageLoadError => _translate('image_load_error');

  String createCaptureCount(int count) {
    String template = _translate('create_capture_count');
    return template.replaceAll('{count}', count.toString());
  }

  String createCaptureErrorMessage(String error) {
    String template = _translate('create_capture_error_message');
    return template.replaceAll('{error}', error);
  }

  String get createCaptureNoSilhouette =>
      _translate('create_capture_no_silhouette');
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
