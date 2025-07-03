// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskDTO _$TaskDTOFromJson(Map<String, dynamic> json) {
  return _TaskDTO.fromJson(json);
}

/// @nodoc
mixin _$TaskDTO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  List<TaskDTO> get subtask => throw _privateConstructorUsedError;

  /// Serializes this TaskDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskDTOCopyWith<TaskDTO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskDTOCopyWith<$Res> {
  factory $TaskDTOCopyWith(TaskDTO value, $Res Function(TaskDTO) then) =
      _$TaskDTOCopyWithImpl<$Res, TaskDTO>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String date,
      String time,
      String categoryId,
      String priority,
      List<TaskDTO> subtask});
}

/// @nodoc
class _$TaskDTOCopyWithImpl<$Res, $Val extends TaskDTO>
    implements $TaskDTOCopyWith<$Res> {
  _$TaskDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? date = null,
    Object? time = null,
    Object? categoryId = null,
    Object? priority = null,
    Object? subtask = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      subtask: null == subtask
          ? _value.subtask
          : subtask // ignore: cast_nullable_to_non_nullable
              as List<TaskDTO>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskDTOImplCopyWith<$Res> implements $TaskDTOCopyWith<$Res> {
  factory _$$TaskDTOImplCopyWith(
          _$TaskDTOImpl value, $Res Function(_$TaskDTOImpl) then) =
      __$$TaskDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String date,
      String time,
      String categoryId,
      String priority,
      List<TaskDTO> subtask});
}

/// @nodoc
class __$$TaskDTOImplCopyWithImpl<$Res>
    extends _$TaskDTOCopyWithImpl<$Res, _$TaskDTOImpl>
    implements _$$TaskDTOImplCopyWith<$Res> {
  __$$TaskDTOImplCopyWithImpl(
      _$TaskDTOImpl _value, $Res Function(_$TaskDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? date = null,
    Object? time = null,
    Object? categoryId = null,
    Object? priority = null,
    Object? subtask = null,
  }) {
    return _then(_$TaskDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      subtask: null == subtask
          ? _value._subtask
          : subtask // ignore: cast_nullable_to_non_nullable
              as List<TaskDTO>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskDTOImpl implements _TaskDTO {
  const _$TaskDTOImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.date,
      required this.time,
      required this.categoryId,
      required this.priority,
      final List<TaskDTO> subtask = const []})
      : _subtask = subtask;

  factory _$TaskDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskDTOImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String date;
  @override
  final String time;
  @override
  final String categoryId;
  @override
  final String priority;
  final List<TaskDTO> _subtask;
  @override
  @JsonKey()
  List<TaskDTO> get subtask {
    if (_subtask is EqualUnmodifiableListView) return _subtask;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtask);
  }

  @override
  String toString() {
    return 'TaskDTO(id: $id, name: $name, description: $description, date: $date, time: $time, categoryId: $categoryId, priority: $priority, subtask: $subtask)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(other._subtask, _subtask));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      date,
      time,
      categoryId,
      priority,
      const DeepCollectionEquality().hash(_subtask));

  /// Create a copy of TaskDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskDTOImplCopyWith<_$TaskDTOImpl> get copyWith =>
      __$$TaskDTOImplCopyWithImpl<_$TaskDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskDTOImplToJson(
      this,
    );
  }
}

abstract class _TaskDTO implements TaskDTO {
  const factory _TaskDTO(
      {required final String id,
      required final String name,
      final String? description,
      required final String date,
      required final String time,
      required final String categoryId,
      required final String priority,
      final List<TaskDTO> subtask}) = _$TaskDTOImpl;

  factory _TaskDTO.fromJson(Map<String, dynamic> json) = _$TaskDTOImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get date;
  @override
  String get time;
  @override
  String get categoryId;
  @override
  String get priority;
  @override
  List<TaskDTO> get subtask;

  /// Create a copy of TaskDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskDTOImplCopyWith<_$TaskDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
