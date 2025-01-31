import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import './home_screen.dart';

class TimeSelectionScreen extends StatefulWidget {
  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  int selectedHours = 1;
  final List<int> hours = List.generate(16, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      '집중 시간',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5CF6),
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color.fromRGBO(214, 214, 214, 1), width: 2),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.priority_high, size: 16, color: Colors.grey[350]),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                '중요사항', 
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
                                  SizedBox(height: 10,),
                                  ListTile(
                                    leading: Icon(Icons.check, color: Color(0xFF8B5CF6)),
                                    title: Text('방해금지 모드 사용을 추천해요.',
                                      style: TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('확인', style: TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 200,
                child: ListWheelScrollView(
                  itemExtent: 50,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  children: hours.map((hour) =>
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$hour시간',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: hour == selectedHours ? 
                            FontWeight.bold : FontWeight.normal,
                          color: hour == selectedHours ?
                            Color(0xFF8B5CF6) :
                            (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    )
                  ).toList(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedHours = hours[index];
                    });
                  },
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // 시간 설정
                    context.read<TodoProvider>().setMaxTime(selectedHours.toDouble());
                    // 단순히 현재 화면을 스택에서 제거
                    Navigator.of(context).pop();
                  },
                  child: const Text('진행', 
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}