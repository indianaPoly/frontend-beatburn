// lib/screens/time_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import './home_screen.dart';

class TimeSelectionScreen extends StatefulWidget {
  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  int selectedHours = 4;
  final List<int> hours = List.generate(13, (i) => i + 1); // 1-13시간

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '오늘의 집중 시간',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
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
                    context.read<TodoProvider>().setMaxTime(selectedHours.toDouble());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomeScreen())
                    );
                  },
                  child: const Text('진행하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}