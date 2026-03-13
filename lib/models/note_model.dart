import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final int? id;
  final int chapterID;
  final String chapterTitle;
  final String text;
  final String? note;
  final int colorValue;
  final int startIndex;
  final int endIndex;
  final DateTime createdAt;

  const NoteModel({
    this.id,
    required this.chapterID,
    required this.chapterTitle,
    required this.text,
    this.note,
    required this.colorValue,
    required this.startIndex,
    required this.endIndex,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterID': chapterID,
      'chapterTitle': chapterTitle,
      'text': text,
      'note': note,
      'colorValue': colorValue,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      chapterID: map['chapterID'],
      chapterTitle: map['chapterTitle'],
      text: map['text'],
      note: map['note'],
      colorValue: map['colorValue'],
      startIndex: map['startIndex'],
      endIndex: map['endIndex'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    chapterID,
    chapterTitle,
    text,
    note,
    colorValue,
    startIndex,
    endIndex,
    createdAt,
  ];
}
