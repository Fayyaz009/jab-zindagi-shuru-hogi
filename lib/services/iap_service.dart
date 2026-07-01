import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Product ID for permanent ad removal
  static const String productNoAds = 'premium';

  final _purchaseController = StreamController<PurchaseStatus>.broadcast();
  Stream<PurchaseStatus> get purchaseStream => _purchaseController.stream;

  Future<void> initialize() async {
    int retryCount = 0;
    const int maxRetries = 3;
    bool available = false;

    while (retryCount < maxRetries && !available) {
      try {
        available = await _iap.isAvailable();
        if (!available) {
          retryCount++;
          if (retryCount < maxRetries) {
            debugPrint('IAP: Billing not available, retrying ($retryCount/$maxRetries)...');
            await Future.delayed(Duration(seconds: 1 * retryCount));
          }
        }
      } catch (e) {
        debugPrint('IAP Initialization check error (attempt $retryCount): $e');
        retryCount++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (!available) {
      debugPrint('IAP Error: Billing context not available after $maxRetries attempts.');
      // Still set up the listener in case it becomes available later
    }

    try {
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          debugPrint('IAP Stream Error: $error');
        },
      );
    } catch (e) {
      debugPrint('IAP Stream Subscription Error: $e');
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<String?> getAvailabilityError() async {
    try {
      final bool available = await _iap.isAvailable();
      if (available) return null;
      return 'Google Play Store reports billing is not available on this device.';
    } catch (e) {
      debugPrint('IAP isAvailable Error: $e');
      return e.toString();
    }
  }

  Future<bool> isAvailable() async {
    return (await getAvailabilityError()) == null;
  }

  Future<List<ProductDetails>> getProducts() async {
    try {
      if (!await isAvailable()) {
        debugPrint('IAP: Billing not available, skipping product query.');
        return [];
      }

      final ProductDetailsResponse response = await _iap.queryProductDetails({
        productNoAds,
      });
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }
      return response.productDetails;
    } catch (e) {
      debugPrint('IAP getProducts Error: $e');
      return [];
    }
  }

  Future<void> buyNonConsumable(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('IAP Purchase Error: $e');
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchaseController.add(PurchaseStatus.pending);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error ||
            purchaseDetails.status == PurchaseStatus.canceled) {
          _purchaseController.add(purchaseDetails.status);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _verifyPurchase(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // In a real production app, you would verify this with your server.
    // For this implementation, we'll assume it's valid if Google/Apple says so.
    if (purchaseDetails.productID == productNoAds) {
      await _setPremiumStatus(true);
      _purchaseController.add(purchaseDetails.status);
    }
  }

  Future<void> _setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', isPremium);
  }

  Future<bool> getPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_premium') ?? false;
  }
}
