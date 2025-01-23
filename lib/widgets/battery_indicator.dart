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
   
   return Container(
     margin: const EdgeInsets.only(left: 16),
     padding: const EdgeInsets.symmetric(vertical: 16),
     decoration: BoxDecoration(
       color: Colors.grey[50],
       borderRadius: BorderRadius.circular(16),
       border: Border.all(
         color: Colors.grey[200]!,
         width: 1,
       ),
     ),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Text(
           '${percentage.toStringAsFixed(1)}%',
           style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
             color: Colors.indigo[700],
           ),
         ),
         const SizedBox(height: 8),
         Text(
           '남은 시간: ${hours}시간 ${minutes}분',
           style: TextStyle(
             fontSize: 16,
             color: Colors.indigo[500],
             fontWeight: FontWeight.w500,
           ),
         ),
       ],
     ),
   );
 }
}