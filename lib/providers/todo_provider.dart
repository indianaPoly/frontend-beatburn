import 'package:burnout_todolist/models/todo.dart';
import 'package:flutter/material.dart';

enum StudyState {
  studying,
  resting
}

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  double _maxTime = 4.0;
  String? _activeTaskId;
  StudyState _currentState = StudyState.resting;

  List<Todo> get todos => _todos;
  double get maxTime => _maxTime;
  String? get activeTaskId => _activeTaskId;
  StudyState get currentState => _currentState;
  
  double get remainingTime {
    double usedTime = _todos.fold(0, (sum, todo) => 
      sum + (todo.actualTime ?? 0));
    return _maxTime - usedTime;
  }

  void setMaxTime(double time) {
    _maxTime = time;
    notifyListeners();
  }

  void addTodo(String task) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      task: task,
    ));
    notifyListeners();
  }

  void startTask(String id) {
    if (_activeTaskId != null) return;
    
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].startTime = DateTime.now();
      _activeTaskId = id;
      notifyListeners();
    }
  }

  void endTask(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final endTime = DateTime.now();
      todo.endTime = endTime;
      todo.isCompleted = true;
      
      if (todo.startTime != null) {
        todo.actualTime = endTime.difference(todo.startTime!).inMinutes / 60;
      }
      
      _activeTaskId = null;
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // 현재 공부 상태에 대해서 
  void setStudyState(StudyState state) {
    _currentState = state;
    notifyListeners();
  }
}