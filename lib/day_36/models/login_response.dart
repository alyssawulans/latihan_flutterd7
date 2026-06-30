// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  LoginResponse({this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "token")
  String? token;
  @JsonKey(name: "user")
  User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class User {
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
  @JsonKey(name: "batch")
  Batch? batch;
  @JsonKey(name: "training")
  Training? training;

  User({
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
    this.batch,
    this.training,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Batch {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "batch_ke")
  String? batchKe;
  @JsonKey(name: "start_date")
  DateTime? startDate;
  @JsonKey(name: "end_date")
  DateTime? endDate;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  Batch({
    this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);
}

@JsonSerializable()
class Training {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  dynamic description;
  @JsonKey(name: "participant_count")
  dynamic participantCount;
  @JsonKey(name: "standard")
  dynamic standard;
  @JsonKey(name: "duration")
  dynamic duration;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  Training({
    this.id,
    this.title,
    this.description,
    this.participantCount,
    this.standard,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}
