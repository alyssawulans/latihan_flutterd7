// To parse this JSON data, do
//
//     final trainingModel = trainingModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'training_model.g.dart';

TrainingModel trainingModelFromJson(String str) =>
    TrainingModel.fromJson(json.decode(str));

String trainingModelToJson(TrainingModel data) => json.encode(data.toJson());

@JsonSerializable()
class TrainingModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  TrainingModel({this.message, this.data});

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}

@JsonSerializable()
class Datum {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;

  Datum({this.id, this.title});

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
