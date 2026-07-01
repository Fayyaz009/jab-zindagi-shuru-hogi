import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/iap_service.dart';

part 'premium_event.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final IAPService _iapService = IAPService();
  StreamSubscription<PurchaseStatus>? _purchaseSubscription;

  PremiumBloc() : super(const PremiumInitial()) {
    on<LoadPremiumStatus>(_onLoadPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<RestorePremium>(_onRestorePremium);
    on<UpdatePremiumStatus>(_onUpdatePremiumStatus);

    _init();
  }

  void _init() async {
    await _iapService.initialize();
    _purchaseSubscription = _iapService.purchaseStream.listen((status) {
      if (status == PurchaseStatus.purchased ||
          status == PurchaseStatus.restored) {
        add(const UpdatePremiumStatus(true));
      } else if (status == PurchaseStatus.error ||
          status == PurchaseStatus.canceled) {
        add(LoadPremiumStatus()); // Reset state to Loaded
      }
    });
    add(LoadPremiumStatus());
  }

  Future<void> _onLoadPremiumStatus(
    LoadPremiumStatus event,
    Emitter<PremiumState> emit,
  ) async {
    final isPremium = await _iapService.getPremiumStatus();
    ProductDetails? premiumProduct;
    bool isStoreAvailable = true;
    bool isProductFound = true;
    String? errorMessage;

    try {
      errorMessage = await _iapService.getAvailabilityError();
      isStoreAvailable = errorMessage == null;

      if (isStoreAvailable) {
        final products = await _iapService.getProducts();
        if (products.isNotEmpty) {
          // Manual search to avoid closure type mismatch issues on Android
          ProductDetails? match;
          for (final p in products) {
            if (p.id == IAPService.productNoAds) {
              match = p;
              break;
            }
          }
          
          if (match != null) {
            premiumProduct = match;
            isProductFound = true;
          } else {
            // Specific product ID not found, but other products are available
            isProductFound = false;
            premiumProduct = null;
          }
        } else {
          isProductFound = false;
        }
      }
    } catch (e) {
      debugPrint('PremiumBloc: Error loading products: $e');
      isStoreAvailable = false;
      errorMessage = e.toString();
    }

    emit(
      PremiumLoaded(
        isPremium,
        premiumProduct: premiumProduct,
        isStoreAvailable: isStoreAvailable,
        isProductFound: isProductFound,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _onPurchasePremium(
    PurchasePremium event,
    Emitter<PremiumState> emit,
  ) async {
    emit(
      PremiumLoading(
        state.isPremium,
        premiumProduct: state.premiumProduct,
        isStoreAvailable: state.isStoreAvailable,
        isProductFound: state.isProductFound,
        errorMessage: state.errorMessage,
      ),
    );
    try {
      final error = await _iapService.getAvailabilityError();
      if (error == null) {
        await _iapService.buyNonConsumable(event.productDetails);
      } else {
        emit(
          PremiumError(
            state.isPremium,
            'Store not available',
            premiumProduct: state.premiumProduct,
            isStoreAvailable: false,
            isProductFound: state.isProductFound,
            errorMessage: error,
          ),
        );
      }
    } catch (e) {
      emit(
        PremiumError(
          state.isPremium,
          e.toString(),
          premiumProduct: state.premiumProduct,
          isStoreAvailable: state.isStoreAvailable,
          isProductFound: state.isProductFound,
          errorMessage: state.errorMessage,
        ),
      );
    }
  }

  Future<void> _onRestorePremium(
    RestorePremium event,
    Emitter<PremiumState> emit,
  ) async {
    emit(
      PremiumLoading(
        state.isPremium,
        premiumProduct: state.premiumProduct,
        isStoreAvailable: state.isStoreAvailable,
        isProductFound: state.isProductFound,
        errorMessage: state.errorMessage,
      ),
    );
    try {
      await _iapService.restorePurchases();
      await Future.delayed(const Duration(seconds: 2));

      final isPremium = await _iapService.getPremiumStatus();
      if (!isPremium) {
        emit(
          PremiumError(
            false,
            'No previous purchases found for this account.',
            premiumProduct: state.premiumProduct,
            isStoreAvailable: state.isStoreAvailable,
            isProductFound: state.isProductFound,
            errorMessage: state.errorMessage,
          ),
        );
      } else {
        emit(
          PremiumLoaded(
            true,
            premiumProduct: state.premiumProduct,
            isStoreAvailable: state.isStoreAvailable,
            isProductFound: state.isProductFound,
            errorMessage: state.errorMessage,
          ),
        );
      }
    } catch (e) {
      emit(
        PremiumError(
          state.isPremium,
          'Restore failed: ${e.toString()}',
          premiumProduct: state.premiumProduct,
          isStoreAvailable: state.isStoreAvailable,
          isProductFound: state.isProductFound,
          errorMessage: state.errorMessage,
        ),
      );
    }
  }

  void _onUpdatePremiumStatus(
    UpdatePremiumStatus event,
    Emitter<PremiumState> emit,
  ) {
    emit(PremiumLoaded(event.isPremium, premiumProduct: state.premiumProduct));
  }

  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    return super.close();
  }
}
