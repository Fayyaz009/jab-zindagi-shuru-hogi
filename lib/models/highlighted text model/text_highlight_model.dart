class HighlightModel {
  final int? id;
  final String chapterTitle;
  final int start;
  final int end;
  final int colorValue;

  HighlightModel({
    this.id,
    required this.chapterTitle,
    required this.start,
    required this.end,
    required this.colorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterTitle': chapterTitle,
      'start': start,
      'end': end,
      'colorValue': colorValue,
    };
  }

  factory HighlightModel.fromMap(Map<String, dynamic> map) {
    return HighlightModel(
      id: map['id'],
      chapterTitle: map['chapterTitle'],
      start: map['start'],
      end: map['end'],
      colorValue: map['colorValue'],
    );
  }
}
