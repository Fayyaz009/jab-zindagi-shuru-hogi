part of 'change_navigation_bloc.dart';

@immutable
sealed class ChangeNavigationState extends Equatable {
  final int index;

  const ChangeNavigationState({required this.index});
  @override
  List<Object> get props => [];
}

final class ChangeNavigationInitial extends ChangeNavigationState {
  const ChangeNavigationInitial({required super.index});
}

class NavigationState extends ChangeNavigationState {
  final int index;
  const NavigationState(this.index) : super(index: 0);

  @override
  List<Object> get props => [index];
}
