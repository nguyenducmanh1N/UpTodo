import 'package:flutter/material.dart';
import 'package:uptodo/models/task/task_dto.dart';
import 'package:uptodo/repositories/category_repository.dart';
import 'package:uptodo/widgets/shared/components/task_item.dart';

class TaskList extends StatelessWidget {
  final List<TaskDTO> tasks;
  final String userId;
  final CategoryRepository categoryRepository;
  final Function(String, TaskDTO)? onTaskCompleted;

  const TaskList({
    super.key,
    required this.tasks,
    required this.userId,
    required this.categoryRepository,
    required this.onTaskCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return FutureBuilder(
            future: categoryRepository.getCategoryById(userId, task.categoryId),
            builder: (context, snapshot) {
              final category = snapshot.data;
              return TaskItem(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TaskDetailScreen(task: task),
                  //   ),
                  // );
                },
                isCompleted: task.isCompleted ?? false,
                setTaskCompleted: () => onTaskCompleted!(userId, task),
                name: task.name,
                time: task.date,
                categoryLabel: category?.name ?? '',
                categoryImgUrl: category?.img,
                priorityLabel: task.priority,
                categoryColorKey: category?.color,
              );
            },
          );
        },
      ),
    );
  }
}
