import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/prgress_bar.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/progress_model.dart';

part 'progress_bar_event.dart';
part 'progress_bar_state.dart';

class ProgressBarBloc extends Bloc<ProgressEvent, ProgressBarState> {
  final ProgressDB db = ProgressDB.instance;

  ProgressBarBloc() : super(ProgressBarInitial()) {
    on<LoadProgress>(_onLoadProgress);
    on<SaveProgress>(_onSaveProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressBarState> emit,
  ) async {
    emit(ProgressBarLoading());

    final progressList = await db.loadAllProgress();

    int lastReadChapterID = 1;
    bool hasAnyProgress = false;

    if (progressList.isNotEmpty) {
      hasAnyProgress = progressList.any((m) => m.progress > 0.0);

      // Timestamp ke hisaab se latest chapter dhundo
      // Agar lastReadAt null ho toh old entries ko ignore karo ya default time do
      final validList = progressList
          .where((m) => m.lastReadAt != null)
          .toList();

      if (validList.isNotEmpty) {
        final latestModel = validList.reduce(
          (a, b) => a.lastReadAt!.isAfter(b.lastReadAt!) ? a : b,
        );
        lastReadChapterID = latestModel.chapterID;
      }
    }

    emit(
      ProgressBarLoaded(
        progressList,
        hasAnyProgress: hasAnyProgress,
        lastReadChapterID: lastReadChapterID,
      ),
    );
  }

  Future<void> _onSaveProgress(
    SaveProgress event,
    Emitter<ProgressBarState> emit,
  ) async {
    await db.saveProgress(event.chapterID, event.offset, event.progress);

    if (state is ProgressBarLoaded) {
      final currentState = state as ProgressBarLoaded;
      final currentList = currentState.chapterProgress;

      final updatedList = currentList.map((model) {
        if (model.chapterID == event.chapterID) {
          return ProgressModel(
            chapterID: model.chapterID,
            progress: event.progress,
            offset: event.offset,
            lastReadAt: DateTime.now(),
          );
        }
        return model;
      }).toList();

      final exists = updatedList.any((m) => m.chapterID == event.chapterID);
      if (!exists) {
        updatedList.add(
          ProgressModel(
            chapterID: event.chapterID,
            progress: event.progress,
            offset: event.offset,
            lastReadAt: DateTime.now(),
          ),
        );
      }

      bool hasAnyProgress = updatedList.any((m) => m.progress > 0.0);
      int lastReadChapterID = 1;

      final validList = updatedList.where((m) => m.lastReadAt != null).toList();
      if (validList.isNotEmpty) {
        final latestModel = validList.reduce(
          (a, b) => a.lastReadAt!.isAfter(b.lastReadAt!) ? a : b,
        );
        lastReadChapterID = latestModel.chapterID;
      }

      emit(
        ProgressBarLoaded(
          updatedList,
          hasAnyProgress: hasAnyProgress,
          lastReadChapterID: lastReadChapterID,
        ),
      );
    } else {
      add(LoadProgress());
    }
  }
}
