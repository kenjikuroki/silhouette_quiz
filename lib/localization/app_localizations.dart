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

      // Custom list
      'custom_list_title': 'つくったクイズ',
      'custom_list_empty': 'まだ じぶんのクイズは ありません',

      // Create flow
      'create_intro_title': 'クイズをつくろう',
      'create_intro_message':
          'しゃしんをとって じぶんだけの シルエットクイズを つくろう！\nさいだい 5まい まで とれるよ。',
      'create_intro_start_button': 'はじめる',
      'create_capture_title': 'しゃしんをとる',
      'create_capture_add_dummy': 'しゃしんを 1まい とる',
      'create_capture_count': 'いま {count} まい',
      'create_capture_finish': 'かんりょう',
      'create_capture_limit_message': 'これいじょう は とれません（5まい まで）',
      'capture_delete_title': 'このクイズを けす？',
      'capture_delete_message': 'あとから もどせないよ。',
      'capture_delete_ok': 'けす',
      'create_confirm_title': 'これで いい？',
      'create_confirm_message': 'とった しゃしん から クイズを つくります。',
      'create_confirm_title_label': 'クイズの なまえ',
      'create_confirm_default_title': 'クイズ{number}',
      'create_confirm_save_button': 'これでOK！',
      'create_confirm_back_button': 'もどる',

      // Play quiz
      'play_quiz_title': 'クイズ',
      'play_quiz_show_answer': 'こたえを見る',
      'play_quiz_next': 'つぎへ',
      'play_quiz_finish': 'おわる',
      'play_quiz_answer_label': 'こたえ',
      'play_quiz_correct': 'あってた！',
      'play_quiz_incorrect': 'ちがった',
      'play_quiz_result_title': 'けっか',
      'play_quiz_result_message': '{total}もん 中 {correct}もん せいかい！',

      // Delete
      'delete_quiz_confirm_title': 'このクイズを けす？',
      'delete_quiz_confirm_message':
          'このクイズに ふくまれる もんだい は すべて けされます。',
      'common_delete': 'けす',
      'common_cancel': 'やめる',

      // Paywall
      'paywall_title': 'もっと つくるには？',
      'paywall_message':
          'じぶんで つくった クイズは 3つ まで むりょうで つくれます。\nそれ いじょう つくるには、\nいちどだけ 100円で ぜんぶ つかえるように なります。',
      'paywall_buy_button': '100円で かう',
      'paywall_later_button': 'あとで',

      // Common
      'common_ok': 'OK',
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

  String get customListTitle => _translate('custom_list_title');
  String get customListEmpty => _translate('custom_list_empty');

  String get createIntroTitle => _translate('create_intro_title');
  String get createIntroMessage => _translate('create_intro_message');
  String get createIntroStartButton => _translate('create_intro_start_button');
  String get createCaptureTitle => _translate('create_capture_title');
  String get createCaptureAddDummy => _translate('create_capture_add_dummy');
  String get createCaptureFinish => _translate('create_capture_finish');
  String get createCaptureLimitMessage =>
      _translate('create_capture_limit_message');
  String get captureDeleteTitle => _translate('capture_delete_title');
  String get captureDeleteMessage => _translate('capture_delete_message');
  String get captureDeleteOk => _translate('capture_delete_ok');
  String get createConfirmTitle => _translate('create_confirm_title');
  String get createConfirmMessage => _translate('create_confirm_message');
  String get createConfirmTitleLabel => _translate('create_confirm_title_label');
  String get createConfirmSaveButton => _translate('create_confirm_save_button');
  String get createConfirmBackButton => _translate('create_confirm_back_button');
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

  String get commonOk => _translate('common_ok');

  String createCaptureCount(int count) {
    String template = _translate('create_capture_count');
    return template.replaceAll('{count}', count.toString());
  }
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
