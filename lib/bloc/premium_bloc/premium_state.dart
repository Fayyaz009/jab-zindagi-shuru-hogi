part of 'premium_bloc.dart';

abstract class PremiumState extends Equatable {
  final bool isPremium;
  final ProductDetails? premiumProduct;
  final bool isStoreAvailable;
  final bool isProductFound;
  final String? errorMessage;

  const PremiumState(
    this.isPremium, {
    this.premiumProduct,
    this.isStoreAvailable = true,
    this.isProductFound = true,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    isPremium,
    premiumProduct,
    isStoreAvailable,
    isProductFound,
    errorMessage,
  ];
}

class PremiumInitial extends PremiumState {
  const PremiumInitial() : super(false);
}

class PremiumLoading extends PremiumState {
  const PremiumLoading(
    super.isPremium, {
    super.premiumProduct,
    super.isStoreAvailable,
    super.isProductFound,
    super.errorMessage,
  });
}

class PremiumLoaded extends PremiumState {
  const PremiumLoaded(
    super.isPremium, {
    super.premiumProduct,
    super.isStoreAvailable,
    super.isProductFound,
    super.errorMessage,
  });
}

class PremiumError extends PremiumState {
  final String message;
  const PremiumError(
    super.isPremium,
    this.message, {
    super.premiumProduct,
    super.isStoreAvailable,
    super.isProductFound,
    super.errorMessage,
  });

  @override
  List<Object?> get props => [
    isPremium,
    message,
    premiumProduct,
    isStoreAvailable,
    isProductFound,
    errorMessage,
  ];
}
