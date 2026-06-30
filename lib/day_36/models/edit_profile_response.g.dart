// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileResponse _$EditProfileResponseFromJson(Map<String, dynamic> json) =>
    EditProfileResponse(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditProfileResponseToJson(
  EditProfileResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  emailVerifiedAt: json['email_verified_at'],
  isActive: json['is_active'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  batchId: json['batch_id'] as String?,
  trainingId: json['training_id'] as String?,
  jenisKelamin: json['jenis_kelamin'],
  profilePhoto: json['profile_photo'] as String?,
  onesignalPlayerId: json['onesignal_player_id'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'email_verified_at': instance.emailVerifiedAt,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
  'jenis_kelamin': instance.jenisKelamin,
  'profile_photo': instance.profilePhoto,
  'onesignal_player_id': instance.onesignalPlayerId,
};
