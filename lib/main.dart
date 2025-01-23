import 'package:burnout_todolist/screen/time_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:burnout_todolist/screen/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        home: TimeSelectionScreen(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '번아웃 방지 투두리스트',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
