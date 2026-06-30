// To parse this JSON data, do
//
//     final detailTrainingModel = detailTrainingModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'detail_training_model.g.dart';

DetailTrainingModel detailTrainingModelFromJson(String str) =>
    DetailTrainingModel.fromJson(json.decode(str));

String detailTrainingModelToJson(DetailTrainingModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class DetailTrainingModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  DetailTrainingModel({this.message, this.data});

  factory DetailTrainingModel.fromJson(Map<String, dynamic> json) =>
      _$DetailTrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTrainingModelToJson(this);
}

@JsonSerializable()
class Data {
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
  @JsonKey(name: "units")
  List<dynamic>? units;
  @JsonKey(name: "activities")
  List<dynamic>? activities;

  Data({
    this.id,
    this.title,
    this.description,
    this.participantCount,
    this.standard,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.units,
    this.activities,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
