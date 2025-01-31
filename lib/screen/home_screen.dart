import 'package:burnout_todolist/providers/theme_provider.dart';
import 'package:burnout_todolist/widgets/horizontal_calendar.dart';
import 'package:burnout_todolist/widgets/study_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:burnout_todolist/widgets/add_todo_form.dart';
import 'package:burnout_todolist/widgets/battery_indicator.dart';
import 'package:burnout_todolist/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<HorizontalCalendarState> _calendarKey = GlobalKey<HorizontalCalendarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            _calendarKey.currentState?.scrollToToday();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BeatBurn',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // 시간 설정 버튼 추가
          IconButton(
            icon: Icon(
              Icons.timer,
              color: Color(0xFF8B5CF6),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/time-selection');
            },
          ),
          // 테마 토글 버튼
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Color(0xFF8B5CF6),
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          )
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(child: StudyIndicator()),
                            Expanded(child: BatteryIndicator()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                HorizontalCalendar(key: _calendarKey),
                const SizedBox(height: 16),
                AddTodoForm(),
                const SizedBox(height: 16),
                Expanded(
                  child: TodoList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}