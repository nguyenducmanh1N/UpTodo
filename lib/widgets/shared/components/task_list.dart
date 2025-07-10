import 'package:flutter/material.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/widgets/shared/components/task_item.dart';
import 'package:uptodo/widgets/task_detail/task_detail_screen.dart';

class TaskList extends StatelessWidget {
  final List<TaskDTO> tasks;
  final String userId;
  final CategoryRepository categoryRepository;
  final Function(String, TaskDTO)? onTaskCompleted;
  final Function(TaskDTO)? onTaskSelected;
  final String? text;
  final List<TaskDTO>? selectedTasks;
  final Function(String)? onTaskUpdated;
  final Function(String)? onTaskDeleted;

  const TaskList({
    super.key,
    required this.tasks,
    required this.userId,
    required this.categoryRepository,
    this.onTaskCompleted,
    this.onTaskSelected,
    this.text,
    this.selectedTasks,
    this.onTaskUpdated,
    this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        children: [
          if (tasks.isEmpty)
            Center(
              child: Text(
                text ?? 'No tasks available',
                style: TextStyle(color: AppColor.upToDoWhite, fontSize: 16),
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isSelected = selectedTasks?.contains(task) ?? false;
              return FutureBuilder(
                future: categoryRepository.getCategoryById(userId, task.categoryId),
                builder: (context, snapshot) {
                  final category = snapshot.data;
                  return TaskItem(
                    onTap: onTaskSelected != null
                        ? () => onTaskSelected!(task)
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(
                                  task: task,
                                  onTaskUpdated: () => onTaskUpdated?.call(task.id),
                                  onTaskDeleted: () => onTaskDeleted?.call(task.id),
                                ),
                              ),
                            ),
                    isCompleted: task.isCompleted ?? false,
                    setTaskCompleted: () => onTaskCompleted!(userId, task),
                    name: task.name,
                    time: task.date,
                    categoryLabel: category?.name ?? '',
                    categoryImgUrl: category?.img,
                    priorityLabel: task.priority,
                    categoryColorKey: category?.color,
                    isSelected: isSelected,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
