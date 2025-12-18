import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'font_size_event.dart';
part 'font_size_state.dart';

class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  FontSizeBloc() : super(const FontSizeInitial(1.0)) {
    on<ChangeFontSize>((event, emit) {
      emit(FontSizeInitial(event.scale));
    });
  }
}
