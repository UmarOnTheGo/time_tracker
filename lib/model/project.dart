class Project {
  final String name;
  static int _count = 0;
  late final int id;

  Project({required this.name}) {
    id = _count++;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
