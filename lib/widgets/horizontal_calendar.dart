import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:burnout_todolist/providers/todo_provider.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({Key? key}) : super(key: key);

  @override
  State<HorizontalCalendar> createState() => HorizontalCalendarState();
}

class HorizontalCalendarState extends State<HorizontalCalendar> {
  late ScrollController _scrollController;
  final double _itemWidth = 60.0;
  final double _horizontalPadding = 4.0;

  final Color _todayColor = Color(0xFF8B5CF6);
  final Color _primaryColor = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getDates() {
    final now = DateTime.now();
    final dates = List<DateTime>.generate(30, (index) {
      return DateTime(now.year, now.month, now.day - 15 + index);
    });
    return dates;
  }

  // 외부에서 호출 가능하도록 public 메서드로 변경
  void scrollToToday() {
    if (!mounted) return;

    final todayIndex = 15;
    // 전체 아이템 너비 (아이템 + 패딩)
    final totalItemWidth = _itemWidth + (_horizontalPadding * 2);
    
    // 화면의 전체 너비
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 좌측 패딩 16.0을 고려한 실제 스크롤 영역 너비
    final scrollAreaWidth = screenWidth - 32.0;
    
    // 중앙 정렬을 위한 오프셋 계산
    // 스크롤 영역의 중앙에서 아이템의 중앙이 오도록 계산
    final centerOffset = (scrollAreaWidth - totalItemWidth) / 2;
    
    // 최종 스크롤 위치 계산
    final offset = (todayIndex * totalItemWidth) - centerOffset;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      
      // 오늘 날짜도 선택되도록 Provider 업데이트
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      todoProvider.setSelectedDate(DateTime.now());
    }
  }

  // 나머지 build 메서드 코드는 동일하게 유지
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.selectedDate == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            todoProvider.setSelectedDate(DateTime.now());
          });
        }

        return Container(
          height: 90,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _getDates().length,
            itemBuilder: (context, index) {
              final date = _getDates()[index];
              final isSelected = todoProvider.selectedDate?.year == date.year &&
                  todoProvider.selectedDate?.month == date.month &&
                  todoProvider.selectedDate?.day == date.day;
              
              final isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;

              return GestureDetector(
                onTap: () => todoProvider.setSelectedDate(date),
                child: Container(
                  width: _itemWidth,
                  margin: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? _todayColor : null,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday ? _todayColor : _primaryColor,
                      width: isToday ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.white 
                            : (isToday ? _todayColor : _primaryColor),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.white 
                            : (isToday ? _todayColor : _primaryColor),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (todoProvider.getTodoCountForDate(date) > 0)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected 
                              ? Colors.white 
                              : (isToday ? _todayColor : _primaryColor),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}