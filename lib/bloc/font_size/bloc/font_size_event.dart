part of 'font_size_bloc.dart';

/// EVENTS
abstract class FontSizeEvent {}

class ChangeFontSize extends FontSizeEvent {
  final double scale;
  ChangeFontSize(this.scale);
}
