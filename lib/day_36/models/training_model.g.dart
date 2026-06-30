// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingModel _$TrainingModelFromJson(Map<String, dynamic> json) =>
    TrainingModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingModelToJson(TrainingModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Datum _$DatumFromJson(Map<String, dynamic> json) =>
    Datum(id: (json['id'] as num?)?.toInt(), title: json['title'] as String?);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
};
