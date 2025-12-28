class ProgressModel {
  final int chapterID;
  final double progress;
  final double offset;
  final DateTime? lastReadAt; // ← nullable

  ProgressModel({
    required this.chapterID,
    required this.progress,
    required this.offset,
    this.lastReadAt,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      chapterID: (map['chapterID'] as num).toInt(),
      progress: (map['progress'] as num).toDouble(),
      offset: (map['offset'] as num).toDouble(),
      lastReadAt: map['lastReadAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastReadAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterID': chapterID,
      'progress': progress,
      'offset': offset,
      'lastReadAt': lastReadAt?.millisecondsSinceEpoch,
    };
  }
}
