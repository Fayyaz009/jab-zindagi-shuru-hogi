part of 'progress_bar_bloc.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class ProgressLoading extends ProgressEvent {}

class SaveProgress extends ProgressEvent {
  final double offset;
  final double progress;
  final int chapterID;
  final int percentage;

  const SaveProgress({
    required this.offset,
    required this.progress,
    required this.chapterID,
    required this.percentage,
  });
}

class LoadProgress extends ProgressEvent {}

class LoadOneChapterProgress extends ProgressEvent {}
