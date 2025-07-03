import 'package:freezed_annotation/freezed_annotation.dart';
import '../category/category_dto.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
class TaskDTO with _$TaskDTO {
  const factory TaskDTO({
    required String id,
    required String name,
    String? description,
    required String date,
    required String time,
    required String categoryId,
    required String priority,
    @Default([]) List<TaskDTO> subtask,
  }) = _TaskDTO;

  factory TaskDTO.fromJson(Map<String, dynamic> json) => _$TaskDTOFromJson(json);
}
