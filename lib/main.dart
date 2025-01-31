import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:burnout_todolist/providers/theme_provider.dart';
import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:burnout_todolist/providers/notification_provider.dart';
import 'package:burnout_todolist/screen/time_selection_screen.dart';

void main() async {  // async 추가
  WidgetsFlutterBinding.ensureInitialized();
  
  final notificationProvider = NotificationProvider();
  await notificationProvider.initializeNotifications();  // 앱 시작 시 초기화
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => notificationProvider,  // 이미 초기화된 인스턴스 사용
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.initializeNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 진입할 때 알림 발송
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

      if (todoProvider.activeTaskId != null) {
        final activeTodo = todoProvider.todos.firstWhere((todo) => todo.id == todoProvider.activeTaskId);
        notificationProvider.showNotification(
          '현재 진행 중인 작업',
          activeTodo.task,
        );
      }
    }
  }

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