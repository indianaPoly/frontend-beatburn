import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: provider.todos.length,
      itemBuilder: (context, index) {
        final todo = provider.todos[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.task,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (todo.startTime != null || todo.endTime != null || todo.actualTime != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 12,
                          children: [
                            if (todo.startTime != null)
                              _buildTimeChip('시작 ${DateFormat('HH:mm').format(todo.startTime!)}'),
                            if (todo.endTime != null)
                              _buildTimeChip('종료 ${DateFormat('HH:mm').format(todo.endTime!)}'),
                            if (todo.actualTime != null)
                              _buildTimeChip('${(todo.actualTime! * 60).round()}분'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!todo.isCompleted)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => provider.removeTodo(todo.id),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextButton(
                        onPressed: provider.activeTaskId == null
                            ? () => {
                                provider.startTask(todo.id),
                                provider.setStudyState(StudyState.studying)
                              }
                            : provider.activeTaskId == todo.id
                                ? () => {
                                    provider.endTask(todo.id),
                                    provider.setStudyState(StudyState.resting)
                                  }
                                : null,
                        style: TextButton.styleFrom(
                          backgroundColor: provider.activeTaskId == todo.id
                              ? Colors.red[50]
                              : Colors.green[50],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          provider.activeTaskId == todo.id ? '종료' : '시작',
                          style: TextStyle(
                            color: provider.activeTaskId == todo.id
                                ? Colors.red[700]
                                : Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}