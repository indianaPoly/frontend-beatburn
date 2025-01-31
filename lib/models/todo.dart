class Todo {
  final String id;
  final String task;
  final DateTime? date;  // Added date field
  DateTime? startTime;
  DateTime? endTime;
  bool isCompleted;
  double? actualTime;

  Todo({
    required this.id,
    required this.task,
    this.date,  // Add date parameter
    this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.actualTime,
  });
}