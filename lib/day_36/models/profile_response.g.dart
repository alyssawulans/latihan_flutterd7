// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  batchKe: json['batch_ke'] as String?,
  trainingTitle: json['training_title'] as String?,
  batch: json['batch'] == null
      ? null
      : Batch.fromJson(json['batch'] as Map<String, dynamic>),
  training: json['training'] == null
      ? null
      : Training.fromJson(json['training'] as Map<String, dynamic>),
  jenisKelamin: json['jenis_kelamin'],
  profilePhoto: json['profile_photo'] as String?,
  profilePhotoUrl: json['profile_photo_url'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'batch_ke': instance.batchKe,
  'training_title': instance.trainingTitle,
  'batch': instance.batch,
  'training': instance.training,
  'jenis_kelamin': instance.jenisKelamin,
  'profile_photo': instance.profilePhoto,
  'profile_photo_url': instance.profilePhotoUrl,
};

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
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
);

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
  'id': instance.id,
  'batch_ke': instance.batchKe,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
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
);

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'participant_count': instance.participantCount,
  'standard': instance.standard,
  'duration': instance.duration,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
