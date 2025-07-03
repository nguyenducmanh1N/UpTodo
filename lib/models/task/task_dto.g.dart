// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskDTOImpl _$$TaskDTOImplFromJson(Map<String, dynamic> json) =>
    _$TaskDTOImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      date: json['date'] as String,
      time: json['time'] as String,
      categoryId: json['categoryId'] as String,
      priority: json['priority'] as String,
      subtask: (json['subtask'] as List<dynamic>?)
              ?.map((e) => TaskDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TaskDTOImplToJson(_$TaskDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'date': instance.date,
      'time': instance.time,
      'categoryId': instance.categoryId,
      'priority': instance.priority,
      'subtask': instance.subtask,
    };
