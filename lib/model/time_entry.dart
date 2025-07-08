class TimeEntry {
  late final int id;
  final String projectName;
  final String taskName;
  final double totalTime;
  final DateTime date;
  final String note;
  static int _count = 0;
  TimeEntry({
    required this.projectName,
    required this.taskName,
    required this.totalTime,
    required this.date,
    required this.note,
  }) {
    id = _count++;
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      projectName: json['projectName'],
      taskName: json['taskName'],
      totalTime: json['totalTime'],
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
      'taskName': taskName,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}
