part of 'premium_bloc.dart';

abstract class PremiumState extends Equatable {
  final bool isPremium;
  final ProductDetails? premiumProduct;

  const PremiumState(this.isPremium, {this.premiumProduct});

  @override
  List<Object?> get props => [isPremium, premiumProduct];
}

class PremiumInitial extends PremiumState {
  const PremiumInitial() : super(false);
}

class PremiumLoading extends PremiumState {
  const PremiumLoading(super.isPremium, {super.premiumProduct});
}

class PremiumLoaded extends PremiumState {
  const PremiumLoaded(super.isPremium, {super.premiumProduct});
}

class PremiumError extends PremiumState {
  final String message;
  const PremiumError(super.isPremium, this.message, {super.premiumProduct});

  @override
  List<Object?> get props => [isPremium, message, premiumProduct];
}
