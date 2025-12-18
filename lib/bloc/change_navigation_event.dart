part of 'change_navigation_bloc.dart';

@immutable
sealed class ChangeNavigationEvent {}

class ChangeNavigation extends ChangeNavigationEvent {
  final int selectedIndex;
  ChangeNavigation({required this.selectedIndex});
}
