import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static const String _prefKey = 'notifications_enabled';

  NotificationBloc() : super(NotificationState.initial()) {
    on<LoadNotificationSettings>(_onLoadSettings);
    on<ToggleNotifications>(_onToggleNotifications);
  }

  Future<void> _onLoadSettings(
    LoadNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_prefKey) ?? true;
    emit(state.copyWith(notificationsEnabled: isEnabled, isLoading: false));

    if (isEnabled) {
      await NotificationService().scheduleDailyNotification();
    } else {
      await NotificationService().cancelDailyNotification();
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (event.enabled) {
      // Prompt user for permission runtime

      await prefs.setBool(_prefKey, true);
      emit(state.copyWith(notificationsEnabled: true));

      await NotificationService().scheduleDailyNotification();

      // Trigger an instant notification to verify that notifications are working
      await NotificationService().showInstantNotification(
        title: 'Notifications Enabled! 🔔',
        body:
            'Daily reminders are active (9:00 AM & 7:00 PM). Complete today\'s chapter! ✨',
      );
    } else {
      await prefs.setBool(_prefKey, false);
      emit(state.copyWith(notificationsEnabled: false));
      await NotificationService().cancelDailyNotification();
    }
  }
}
