// To parse this JSON data, do
//
//     final editProfileResponse = editProfileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_response.g.dart';

EditProfileResponse editProfileResponseFromJson(String str) =>
    EditProfileResponse.fromJson(json.decode(str));

String editProfileResponseToJson(EditProfileResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class EditProfileResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  EditProfileResponse({this.message, this.data});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$EditProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileResponseToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "email_verified_at")
  dynamic emailVerifiedAt;
  @JsonKey(name: "is_active")
  String? isActive;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "batch_id")
  String? batchId;
  @JsonKey(name: "training_id")
  String? trainingId;
  @JsonKey(name: "jenis_kelamin")
  dynamic jenisKelamin;
  @JsonKey(name: "profile_photo")
  String? profilePhoto;
  @JsonKey(name: "onesignal_player_id")
  String? onesignalPlayerId;

  Data({
    this.id,
    this.name,
    this.email,
    this.role,
    this.emailVerifiedAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.batchId,
    this.trainingId,
    this.jenisKelamin,
    this.profilePhoto,
    this.onesignalPlayerId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
