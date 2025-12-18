import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'change_navigation_event.dart';
part 'change_navigation_state.dart';

class ChangeNavigationBloc
    extends Bloc<ChangeNavigationEvent, ChangeNavigationState> {
  ChangeNavigationBloc() : super(ChangeNavigationInitial(index: 0)) {
    on<ChangeNavigation>((event, emit) {
      emit(NavigationState(event.selectedIndex));
    });
  }
}
