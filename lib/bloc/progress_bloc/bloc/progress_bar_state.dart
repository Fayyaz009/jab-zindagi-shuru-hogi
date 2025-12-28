part of 'progress_bar_bloc.dart';

sealed class ProgressBarState extends Equatable {
  const ProgressBarState();

  @override
  List<Object> get props => [];
}

final class ProgressBarInitial extends ProgressBarState {}

class ProgressBarLoading extends ProgressBarState {}

class ProgressBarLoaded extends ProgressBarState {
  final List<ProgressModel> chapterProgress;
  final bool hasAnyProgress;
  final int lastReadChapterID; // sabse zyada progress wala chapterID

  const ProgressBarLoaded(
    this.chapterProgress, {
    required this.hasAnyProgress,
    required this.lastReadChapterID,
  });

  @override
  List<Object> get props => [
    chapterProgress,
    hasAnyProgress,
    lastReadChapterID,
  ];
}
