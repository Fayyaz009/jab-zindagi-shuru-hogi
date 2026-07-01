import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationSettings extends NotificationEvent {}

class ToggleNotifications extends NotificationEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}
