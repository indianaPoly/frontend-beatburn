import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

enum StudyState {
  studying,
  resting
}

class TodoProvider with ChangeNotifier {
  static const String TODOS_KEY = 'todos';
  static const String MAX_TIMES_KEY = 'max_times';
  
  List<Todo> _todos = [];
  Map<String, double> _maxTimes = {};
  String? _activeTaskId;
  StudyState _currentState = StudyState.resting;
  DateTime? _selectedDate;

  TodoProvider() {
    _loadTodos();
    _loadMaxTimes();
  }

  List<Todo> get todos => _todos;
  String? get activeTaskId => _activeTaskId;
  StudyState get currentState => _currentState;
  DateTime? get selectedDate => _selectedDate;

  double get maxTime {
    if (_selectedDate == null) return 4.0;
    String dateKey = _getDateKey(_selectedDate!);
    return _maxTimes[dateKey] ?? 4.0;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

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
    return maxTime - usedTime;
  }

  Future<void> _saveMaxTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final String maxTimesJson = jsonEncode(_maxTimes);
    await prefs.setString(MAX_TIMES_KEY, maxTimesJson);
  }

  Future<void> _loadMaxTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? maxTimesJson = prefs.getString(MAX_TIMES_KEY);
    if (maxTimesJson != null) {
      final Map<String, dynamic> decodedJson = jsonDecode(maxTimesJson);
      _maxTimes = decodedJson.map((key, value) => MapEntry(key, value.toDouble()));
      notifyListeners();
    }
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
    if (_selectedDate == null) return;
    String dateKey = _getDateKey(_selectedDate!);
    _maxTimes[dateKey] = time;
    _saveMaxTimes();
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
    await prefs.remove(TODOS_KEY);
    await prefs.remove(MAX_TIMES_KEY);
    _todos.clear();
    _maxTimes.clear();
    _activeTaskId = null;
    _currentState = StudyState.resting;
    notifyListeners();
  }
}