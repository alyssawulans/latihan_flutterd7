// To parse this JSON data, do
//
//     final profilePhotoResponse = profilePhotoResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'profile_photo_response.g.dart';

ProfilePhotoResponse profilePhotoResponseFromJson(String str) =>
    ProfilePhotoResponse.fromJson(json.decode(str));

String profilePhotoResponseToJson(ProfilePhotoResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProfilePhotoResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  ProfilePhotoResponse({this.message, this.data});

  factory ProfilePhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfilePhotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePhotoResponseToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "profile_photo")
  String? profilePhoto;

  Data({this.profilePhoto});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
