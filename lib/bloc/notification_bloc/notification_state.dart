import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool notificationsEnabled;
  final bool isLoading;

  const NotificationState({
    required this.notificationsEnabled,
    this.isLoading = false,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      notificationsEnabled: true, // Default to true
      isLoading: true,
    );
  }

  NotificationState copyWith({
    bool? notificationsEnabled,
    bool? isLoading,
  }) {
    return NotificationState(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [notificationsEnabled, isLoading];
}
