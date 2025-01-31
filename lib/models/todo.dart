class Todo {
  final String id;
  final String task;
  final DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  double? actualTime;
  bool isCompleted;

  Todo({
    required this.id,
    required this.task,
    this.date,
    this.startTime,
    this.endTime,
    this.actualTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'date': date?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'actualTime': actualTime,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      actualTime: json['actualTime'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}