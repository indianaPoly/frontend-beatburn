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
   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
   
   return IntrinsicHeight(
     child: Column(
       children: [
         Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             boxShadow: [
               BoxShadow(
                 color: isDarkMode 
                   ? Colors.black.withOpacity(0.3)
                   : Colors.grey.withOpacity(0.1),
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
               hintStyle: TextStyle(
                 color: isDarkMode ? Colors.grey[500] : Colors.grey[400]
               ),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
                 borderSide: BorderSide.none,
               ),
               filled: true,
               fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
                 borderSide: BorderSide(
                  color: Color(0xFF8B5CF6),
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
             child: const Text('추가', style: TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 18,
                fontWeight: FontWeight.w600
                )
              ),
           ),
         ),
       ],
     ),
   );
 }
}