import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
class TaskDTO with _$TaskDTO {
  const factory TaskDTO({
    required String id,
    required String name,
    String? description,
    required DateTime date,
    required String categoryId,
    required String priority,
    bool? isCompleted,
    @Default([]) List<TaskDTO> subtask,
  }) = _TaskDTO;

  factory TaskDTO.fromJson(Map<String, dynamic> json) => _$TaskDTOFromJson(json);
}
