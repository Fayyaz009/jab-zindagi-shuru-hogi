part of 'font_size_bloc.dart';

abstract class FontSizeState extends Equatable {
  final double scale;

  const FontSizeState(this.scale);

  @override
  List<Object> get props => [scale];
}

/// ✅ Concrete State (THIS FIXES YOUR ERROR)
class FontSizeInitial extends FontSizeState {
  const FontSizeInitial(double scale) : super(scale);
}
