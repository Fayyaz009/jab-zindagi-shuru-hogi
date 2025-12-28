part of 'font_size_bloc.dart';

abstract class FontSizeState extends Equatable {
  final double scale;

  const FontSizeState(this.scale);

  @override
  List<Object> get props => [scale];
}

/// ✅ Concrete State (THIS FIXES YOUR ERROR)
class FontSizeInitial extends FontSizeState {
  const FontSizeInitial(super.scale);
}

class FontSizeLoading extends FontSizeState {
  const FontSizeLoading(super.scale);
}
