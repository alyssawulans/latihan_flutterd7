// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_training_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailTrainingModel _$DetailTrainingModelFromJson(Map<String, dynamic> json) =>
    DetailTrainingModel(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailTrainingModelToJson(
  DetailTrainingModel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'],
  participantCount: json['participant_count'],
  standard: json['standard'],
  duration: json['duration'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  units: json['units'] as List<dynamic>?,
  activities: json['activities'] as List<dynamic>?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'participant_count': instance.participantCount,
  'standard': instance.standard,
  'duration': instance.duration,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'units': instance.units,
  'activities': instance.activities,
};
