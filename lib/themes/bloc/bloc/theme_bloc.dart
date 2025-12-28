import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/theme_database.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/themes.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeDB db = ThemeDB.instance;

  ThemeBloc()
    : super(
        ThemeState(
          themeData: AppThemes.darkTheme,
          themeType: AppThemeType.dark,
        ),
      ) {
    on<LoadTheme>(_loadTheme);
    on<ChangeTheme>(_changeTheme);
  }

  Future<void> _changeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    await db.saveTheme(event.themeType.name);
    emit(
      ThemeState(
        themeData: AppThemes.getTheme(event.themeType),
        themeType: event.themeType,
      ),
    );
  }

  Future<void> _loadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    emit(ThemeLoading(themeData: state.themeData, themeType: state.themeType));
    try {
      final value = await db.loadTheme();
      final themeType = AppThemeType.values.firstWhere(
        (element) => element.name == value,
      );

      emit(
        ThemeState(
          themeData: AppThemes.getTheme(themeType),
          themeType: themeType,
        ),
      );
    } catch (e) {
      emit(
        ThemeState(
          themeData: AppThemes.darkTheme,
          themeType: AppThemeType.dark,
        ),
      );
    }
  }
}
