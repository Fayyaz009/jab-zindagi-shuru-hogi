import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/themes.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(
        ThemeState(
          themeData: AppThemes.darkTheme,
          themeType: AppThemeType.dark,
        ),
      ) {
    on<ChangeTheme>((event, emit) {
      emit(
        ThemeState(
          themeData: AppThemes.getTheme(event.themeType),
          themeType: event.themeType,
        ),
      );
    });
  }
}
