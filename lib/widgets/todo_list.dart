import 'package:burnout_todolist/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final todosForSelectedDate = provider.todosForSelectedDate;

    if (todosForSelectedDate.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 48,
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      provider.selectedDate == null
                        ? '날짜를 선택해주세요'
                        : '${DateFormat('MM월 dd일').format(provider.selectedDate!)}의 할 일이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: todosForSelectedDate.length,
      itemBuilder: (context, index) {
        final todo = todosForSelectedDate[index];
        final isActive = provider.activeTaskId == todo.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (todo.startTime != null || todo.endTime != null || todo.actualTime != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 12,
                          children: [
                            if (todo.startTime != null)
                              _buildTimeChip('시작 ${DateFormat('HH:mm').format(todo.startTime!)}', isDarkMode),
                            if (todo.endTime != null)
                              _buildTimeChip('종료 ${DateFormat('HH:mm').format(todo.endTime!)}', isDarkMode),
                            if (todo.actualTime != null)
                              _buildTimeChip('${(todo.actualTime! * 60).round()}분', isDarkMode),
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
                      icon: Icon(Icons.delete, 
                        color: isDarkMode ? Colors.grey[400] : Colors.grey),
                      onPressed: () => provider.removeTodo(todo.id),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextButton(
                        onPressed: provider.activeTaskId == null || isActive
                            ? () {
                                if (isActive) {
                                  provider.endTask(todo.id);
                                } else {
                                  provider.startTask(todo.id);
                                }
                              }
                            : null,
                        style: TextButton.styleFrom(
                          backgroundColor: isActive ? Colors.red[100] : Colors.green[100],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          isActive ? '종료' : '시작',
                          style: TextStyle(
                            color: isActive ? Colors.red[800] : Colors.green[800],
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

  Widget _buildTimeChip(String label, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
        ),
      ),
    );
  }
}