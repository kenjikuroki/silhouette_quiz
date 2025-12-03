import 'package:flutter/foundation.dart';

class PurchaseService extends ChangeNotifier {
  bool _isFullVersionPurchased = false;

  bool get isFullVersionPurchased => _isFullVersionPurchased;

  Future<void> loadPurchaseState() async {
    // TODO: 永続化ストレージから読み込む
    _isFullVersionPurchased = false;
    notifyListeners();
  }

  Future<bool> purchaseFullVersion() async {
    // TODO: 実際の課金処理を実装（in_app_purchase など）
    // 今は即成功したことにする
    _isFullVersionPurchased = true;
    notifyListeners();
    return true;
  }
}
