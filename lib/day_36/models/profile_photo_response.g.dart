// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_photo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePhotoResponse _$ProfilePhotoResponseFromJson(
  Map<String, dynamic> json,
) => ProfilePhotoResponse(
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfilePhotoResponseToJson(
  ProfilePhotoResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data(profilePhoto: json['profile_photo'] as String?);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'profile_photo': instance.profilePhoto,
};
