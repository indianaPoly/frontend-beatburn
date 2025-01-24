import 'package:burnout_todolist/providers/theme_provider.dart';
import 'package:burnout_todolist/screen/time_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:burnout_todolist/providers/todo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider(),),
      ],
      child: const MyApp(),
    )
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: '번아웃 방지 투두리스트',
      theme: ThemeData(
        useMaterial3: true,
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: TimeSelectionScreen(),
    );
  }
}
