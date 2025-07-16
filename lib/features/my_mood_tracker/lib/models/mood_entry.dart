class MoodEntry {
  final int? id;
  final String mood;
  final String reason;
  final String sleepQuality;
  final String date;

  MoodEntry({
    this.id,
    required this.mood,
    required this.reason,
    required this.sleepQuality,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'reason': reason,
      'sleepQuality': sleepQuality,
      'date': date,
    };
  }

  static MoodEntry fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      mood: map['mood'],
      reason: map['reason'],
      sleepQuality: map['sleepQuality'],
      date: map['date'],
    );
  }
}
