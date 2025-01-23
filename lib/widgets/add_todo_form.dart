import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTodoForm extends StatefulWidget {
  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: '오늘 할 일은 무엇인가요?',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),  
                  borderSide: BorderSide(
                    color: Color(0xFFBBDEFB), // 연한 파스텔 블루
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
                if (_controller.text.isNotEmpty) {
                  context.read<TodoProvider>().addTodo(_controller.text);
                  _controller.clear();
                }
              },
              child: const Text('추가하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}