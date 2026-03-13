import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/theme_database.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/themes.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeDB db = ThemeDB.instance;
  bool _sepiaUnlocked = false;

  bool get isSepiaUnlocked => _sepiaUnlocked;

  ThemeBloc()
      : super(
          ThemeState(
            themeData: AppThemes.darkTheme,
            themeType: AppThemeType.dark,
          ),
        ) {
    on<LoadTheme>(_loadTheme);
    on<ChangeTheme>(_changeTheme);
    on<UnlockSepia>(_unlockSepia);
    on<SyncPremiumStatus>(_syncPremiumStatus);
  }

  void _syncPremiumStatus(SyncPremiumStatus event, Emitter<ThemeState> emit) {
    _sepiaUnlocked = event.isPremium;
    // If current theme is sepia but it's now locked, revert to dark
    if (state.themeType == AppThemeType.sepia && !_sepiaUnlocked) {
      add(ChangeTheme(AppThemeType.dark));
    }
  }

  Future<void> _changeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    if (event.themeType == AppThemeType.sepia && !_sepiaUnlocked) {
      return;
    }

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
        orElse: () => AppThemeType.dark,
      );

      // We still load from DB, but SyncPremiumStatus will override it
      _sepiaUnlocked = await db.loadSepiaUnlock();

      final effectiveThemeType =
          (themeType == AppThemeType.sepia && !_sepiaUnlocked)
              ? AppThemeType.dark
              : themeType;

      emit(
        ThemeState(
          themeData: AppThemes.getTheme(effectiveThemeType),
          themeType: effectiveThemeType,
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

  Future<void> _unlockSepia(UnlockSepia event, Emitter<ThemeState> emit) async {
    _sepiaUnlocked = true;
    await db.saveSepiaUnlock(true);
  }
}
