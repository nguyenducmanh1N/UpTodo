import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    required String id,
    required String email,
    required String token,
    required String username,
    required String imageUrl,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}
