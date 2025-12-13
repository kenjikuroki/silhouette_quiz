import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService extends ChangeNotifier {
  // ストアで設定したプロダクトID (iOS/Android共通の場合)
  static const String _productID = 'premium_unlock';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isFullVersionPurchased = false;
  bool get isFullVersionPurchased => _isFullVersionPurchased;

  // 初期化処理（アプリ起動時に呼ぶ）
  Future<void> initialize() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // エラーハンドリング
      },
    );
    notifyListeners();
  }

  // 購入処理の開始
  Future<bool> purchaseFullVersion() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      return false;
    }

    const Set<String> _kIds = <String>{_productID};
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      return false;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    // Note: The actual result is handled in the stream listener. 
    // This return value might be misleading if used to indicate immediate success.
    // However, keeping it true to indicate "request sent" based on user code flow.
    // Real implementation should probably wait for stream or rely on UI listening to state changes.
    // For now, returning true as per previous interface, but user's code returns true immediately after buy call.
    return true; 
  }

  // 購入の復元（リストア）
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  // 課金ストリームのリスナー
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 保留中
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // エラー
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          
          // 購入完了 or 復元完了
          if (await _verifyPurchase(purchaseDetails)) {
            _enableProVersion();
          }
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    return purchaseDetails.productID == _productID;
  }

  void _enableProVersion() {
    _isFullVersionPurchased = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
