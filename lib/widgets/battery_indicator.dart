import 'package:burnout_todolist/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:burnout_todolist/providers/todo_provider.dart';

class BatteryIndicator extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   final provider = context.watch<TodoProvider>();
   final percentage = (provider.remainingTime / provider.maxTime) * 100;
   final hours = provider.remainingTime.floor();
   final minutes = ((provider.remainingTime - hours) * 60).round();

   return Indicator(
     margin: const EdgeInsets.only(left: 16),
     mainContent: Column(
       children: [
         Text(
           '${percentage.toStringAsFixed(0)}%',
           style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
             color: Indicator.textColors['accent'],
           ),
         ),
         const SizedBox(height: 8),
         Text(
           '남은 시간: ${hours}시간 ${minutes}분',
           style: TextStyle(
             fontSize: 16,
             color: Indicator.textColors['secondary'],
             fontWeight: FontWeight.w500,
           ),
         ),
       ],
     ),
   );
 }
}