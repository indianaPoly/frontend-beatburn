import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:burnout_todolist/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyIndicator extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Consumer<TodoProvider>(
     builder: (context, provider, _) {
       final isStudying = provider.currentState == StudyState.studying;
       return Indicator(
         margin: const EdgeInsets.only(right: 16),
         mainContent: Column(
           children: [
             Icon(
               isStudying ? Icons.school : Icons.coffee, 
               color: Indicator.textColors['accent'],
               size: 30,
             ),
             const SizedBox(height: 8),
             Text(
               isStudying ? '공부중' : '휴식중',
               style: TextStyle(
                 color: Indicator.textColors['secondary'],
                 fontWeight: FontWeight.w500,
                 fontSize: 16,
               ),
             ),
           ],
         ),
       );
     }
   );
 }
}