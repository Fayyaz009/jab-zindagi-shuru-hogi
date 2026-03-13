import 'dart:async';
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
      if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
        add(const UpdatePremiumStatus(true));
      } else if (status == PurchaseStatus.error || status == PurchaseStatus.canceled) {
        add(LoadPremiumStatus()); // Reset state to Loaded
      }
    });
    add(LoadPremiumStatus());
  }

  Future<void> _onLoadPremiumStatus(LoadPremiumStatus event, Emitter<PremiumState> emit) async {
    final isPremium = await _iapService.getPremiumStatus();
    ProductDetails? premiumProduct;
    
    try {
      final products = await _iapService.getProducts();
      if (products.isNotEmpty) {
        premiumProduct = products.firstWhere((p) => p.id == IAPService.productNoAds);
      }
    } catch (e) {
      // Log or handle error fetching products
    }

    emit(PremiumLoaded(isPremium, premiumProduct: premiumProduct));
  }

  Future<void> _onPurchasePremium(PurchasePremium event, Emitter<PremiumState> emit) async {
    emit(PremiumLoading(state.isPremium, premiumProduct: state.premiumProduct));
    try {
      if (await _iapService.isAvailable()) {
        await _iapService.buyNonConsumable(event.productDetails);
      } else {
        emit(PremiumError(state.isPremium, 'Store not available', premiumProduct: state.premiumProduct));
      }
    } catch (e) {
      emit(PremiumError(state.isPremium, e.toString(), premiumProduct: state.premiumProduct));
    }
  }

  Future<void> _onRestorePremium(RestorePremium event, Emitter<PremiumState> emit) async {
    emit(PremiumLoading(state.isPremium, premiumProduct: state.premiumProduct));
    try {
      // Initiate restore
      await _iapService.restorePurchases();
      
      // Safety delay to allow stream to process if there are items
      await Future.delayed(const Duration(seconds: 2));
      
      // Always reload status from local storage after restore attempt
      // to ensure state moves from Loading to Loaded even if no purchases found.
      final isPremium = await _iapService.getPremiumStatus();
      if (!isPremium) {
        emit(PremiumError(false, 'No previous purchases found for this account.', premiumProduct: state.premiumProduct));
      } else {
        emit(PremiumLoaded(true, premiumProduct: state.premiumProduct));
      }
    } catch (e) {
      emit(PremiumError(state.isPremium, 'Restore failed: ${e.toString()}', premiumProduct: state.premiumProduct));
    }
  }

  void _onUpdatePremiumStatus(UpdatePremiumStatus event, Emitter<PremiumState> emit) {
    emit(PremiumLoaded(event.isPremium, premiumProduct: state.premiumProduct));
  }

  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    return super.close();
  }
}
