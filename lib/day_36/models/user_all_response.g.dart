// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_all_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAllResponse _$UserAllResponseFromJson(Map<String, dynamic> json) =>
    UserAllResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserAllResponseToJson(UserAllResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
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
  jenisKelamin: $enumDecodeNullable(
    _$JenisKelaminEnumMap,
    json['jenis_kelamin'],
  ),
  profilePhoto: json['profile_photo'] as String?,
  onesignalPlayerId: json['onesignal_player_id'] as String?,
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': _$RoleEnumMap[instance.role],
  'email_verified_at': instance.emailVerifiedAt,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
  'jenis_kelamin': _$JenisKelaminEnumMap[instance.jenisKelamin],
  'profile_photo': instance.profilePhoto,
  'onesignal_player_id': instance.onesignalPlayerId,
};

const _$RoleEnumMap = {Role.PESERTA: 'peserta'};

const _$JenisKelaminEnumMap = {JenisKelamin.L: 'L', JenisKelamin.P: 'P'};
