import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/notes_database.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NotesLoading());
      try {
        final notes = await NotesDB.instance.readAllNotes();
        emit(NotesLoaded(notes: notes));
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await NotesDB.instance.createNote(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await NotesDB.instance.deleteNote(event.id);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await NotesDB.instance.updateNote(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });
  }
}
