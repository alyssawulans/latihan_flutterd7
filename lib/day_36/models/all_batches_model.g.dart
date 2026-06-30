// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_batches_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllBatchesModel _$AllBatchesModelFromJson(Map<String, dynamic> json) =>
    AllBatchesModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllBatchesModelToJson(AllBatchesModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  batchKe: json['batch_ke'] as String?,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  trainings: (json['trainings'] as List<dynamic>?)
      ?.map((e) => Training.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'batch_ke': instance.batchKe,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'trainings': instance.trainings,
};

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  pivot: json['pivot'] == null
      ? null
      : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'pivot': instance.pivot,
};

Pivot _$PivotFromJson(Map<String, dynamic> json) => Pivot(
  trainingBatchId: json['training_batch_id'] as String?,
  trainingId: json['training_id'] as String?,
);

Map<String, dynamic> _$PivotToJson(Pivot instance) => <String, dynamic>{
  'training_batch_id': instance.trainingBatchId,
  'training_id': instance.trainingId,
};
