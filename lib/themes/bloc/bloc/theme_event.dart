import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

abstract class ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final AppThemeType themeType;
  ChangeTheme(this.themeType);
}

class LoadTheme extends ThemeEvent {}

class UnlockSepia extends ThemeEvent {}

class SyncPremiumStatus extends ThemeEvent {
  final bool isPremium;
  SyncPremiumStatus(this.isPremium);
}
