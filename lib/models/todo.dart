class Todo {
  final String id;
  final String task;
  DateTime? startTime;
  DateTime? endTime;
  double? actualTime;
  bool isCompleted;

  Todo({
    required this.id,
    required this.task,
    this.startTime,
    this.endTime,
    this.actualTime,
    this.isCompleted = false,
  });
}
