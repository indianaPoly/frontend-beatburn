import 'package:burnout_todolist/widgets/study_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:burnout_todolist/widgets/add_todo_form.dart';
import 'package:burnout_todolist/widgets/battery_indicator.dart';
import 'package:burnout_todolist/widgets/todo_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('빗번'),
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
                    Expanded( // 전체 Row를 Expanded로 감싸기
                      child: Container(
                        height: 100,
                        child: Row( // 내부 Row에도 Expanded 적용
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
