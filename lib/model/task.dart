class Task {
  late final int id;
  final String name;
  static int _count = 0;
  Task({required this.name}) {
    id = _count++;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
