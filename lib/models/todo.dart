class Todo {
  String id;
  String task;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  bool isCompleted;
  double? actualTime;

  Todo({
    required this.id,
    required this.task,
    this.date,
    this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.actualTime,
  });

  // Todo 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'date': date?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'actualTime': actualTime,
    };
  }

  // JSON에서 Todo 객체로 변환
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isCompleted: json['isCompleted'] ?? false,
      actualTime: json['actualTime'],
    );
  }
}