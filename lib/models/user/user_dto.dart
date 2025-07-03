import 'package:freezed_annotation/freezed_annotation.dart';
import '../task/task_dto.dart';
import '../category/category_dto.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    required String id,
    required String email,
    required String password,
    required String token,
    @Default([]) List<TaskDTO> tasks,
    @Default([]) List<CategoryDTO> categories,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}
