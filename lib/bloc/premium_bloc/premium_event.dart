part of 'premium_bloc.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object> get props => [];
}

class LoadPremiumStatus extends PremiumEvent {}

class PurchasePremium extends PremiumEvent {
  final ProductDetails productDetails;
  const PurchasePremium(this.productDetails);

  @override
  List<Object> get props => [productDetails];
}

class RestorePremium extends PremiumEvent {}

class UpdatePremiumStatus extends PremiumEvent {
  final bool isPremium;
  const UpdatePremiumStatus(this.isPremium);

  @override
  List<Object> get props => [isPremium];
}
