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
        leading: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Color(0xFF8B5CF6),
          ),
          onPressed: () {
            // 확인 다이얼로그 표시
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  '데이터 삭제',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.warning_amber_rounded, color: Color(0xFF8B5CF6)),
                      title: Text(
                        '모든 할 일 데이터가 삭제돼요.\n계속하시겠어요?',
                        style: TextStyle(fontSize: 14)
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<TodoProvider>(context, listen: false).clearAllTodos();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '모든 할 일이 삭제되었습니다.',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Color(0xFF8B5CF6),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
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