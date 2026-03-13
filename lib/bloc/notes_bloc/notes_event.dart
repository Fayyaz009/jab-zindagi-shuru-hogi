part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final NoteModel note;
  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final int id;
  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateNote extends NotesEvent {
  final NoteModel note;
  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}
