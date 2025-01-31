import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:burnout_todolist/models/todo.dart';

enum StudyState {
  studying,
  resting
}

class TodoProvider with ChangeNotifier {
  static const String TODOS_KEY = 'todos';
  
  List<Todo> _todos = [];
  double _maxTime = 4.0;
  String? _activeTaskId;
  StudyState _currentState = StudyState.resting;
  DateTime? _selectedDate;

  TodoProvider() {
    _loadTodos();
  }

  List<Todo> get todos => _todos;
  double get maxTime => _maxTime;
  String? get activeTaskId => _activeTaskId;
  StudyState get currentState => _currentState;
  DateTime? get selectedDate => _selectedDate;

  List<Todo> get todosForSelectedDate {
    if (_selectedDate == null) return [];
    return _todos.where((todo) {
      return todo.date?.year == _selectedDate?.year &&
             todo.date?.month == _selectedDate?.month &&
             todo.date?.day == _selectedDate?.day;
    }).toList();
  }

  double get remainingTime {
    double usedTime = todosForSelectedDate.fold(
      0, 
      (sum, todo) => sum + (todo.actualTime ?? 0)
    );
    return _maxTime - usedTime;
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(TODOS_KEY, todosJson);
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(TODOS_KEY);
    if (todosJson != null) {
      final List<dynamic> decodedJson = jsonDecode(todosJson);
      _todos = decodedJson.map((item) => Todo.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void setMaxTime(double time) {
    _maxTime = time;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  int getTodoCountForDate(DateTime date) {
    return _todos.where((todo) {
      return todo.date?.year == date.year &&
             todo.date?.month == date.month &&
             todo.date?.day == date.day;
    }).length;
  }

  void addTodo(String task) {
    if (_selectedDate == null) return;
    _todos.add(Todo(
      id: DateTime.now().toString(),
      task: task,
      date: _selectedDate,
    ));
    _saveTodos();
    notifyListeners();
  }

  void startTask(String id) {
    if (_activeTaskId != null) return;
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].startTime = DateTime.now();
      _activeTaskId = id;
      _currentState = StudyState.studying;
      _saveTodos();
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
      _currentState = StudyState.resting;
      _saveTodos();
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    if (_activeTaskId == id) {
      _activeTaskId = null;
      _currentState = StudyState.resting;
    }
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }

  void setStudyState(StudyState state) {
    _currentState = state;
    notifyListeners();
  }

  Future<void> clearAllTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TODOS_KEY); // SharedPreferences에서 데이터 삭제
    _todos.clear(); // 메모리상의 todos 리스트 비우기
    _activeTaskId = null; // 활성 태스크 초기화
    _currentState = StudyState.resting; // 상태 초기화
    notifyListeners();
  }
}