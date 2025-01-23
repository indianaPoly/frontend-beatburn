import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyIndicator extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Consumer<TodoProvider>(
     builder: (context, provider, child) {
       final isStudying = provider.currentState == StudyState.studying;
       return Container(
           margin: const EdgeInsets.only(right: 16),
           padding: const EdgeInsets.symmetric(vertical: 16),
           decoration: BoxDecoration(
             color: Color(0xFFFAFAFA),
             borderRadius: BorderRadius.circular(16),
             border: Border.all(
               color: Color(0xFFEEEEEE),
               width: 1,
             ),
           ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 isStudying ? Icons.school : Icons.coffee,
                 color: Color(0xFF9E9E9E),
                 size: 24,
               ),
               const SizedBox(height: 8),
               Text(
                 isStudying ? '공부중' : '휴식중',
                 style: TextStyle(
                   color: Color(0xFF757575),
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
             ],
           ),
         );
     },
   );
 }
}