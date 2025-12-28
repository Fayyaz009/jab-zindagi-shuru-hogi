import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/font_database.dart';

part 'font_size_event.dart';
part 'font_size_state.dart';

class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  FontDB db = FontDB.instance;
  FontSizeBloc() : super(const FontSizeInitial(0.8)) {
    on<ChangeFontSize>((event, emit) async {
      await db.saveFonts(event.scale);
      emit(FontSizeInitial(event.scale));
    });

    on<LoadFontSize>(_loadFontSize);
  }

  Future<void> _loadFontSize(
    LoadFontSize event,
    Emitter<FontSizeState> emit,
  ) async {
    emit(FontSizeLoading(state.scale));
    try {
      final scaleValue = await db.loadFonts();
      emit(FontSizeInitial(scaleValue));
    } catch (e) {
      emit(FontSizeInitial(0.8));
    }
  }
}
