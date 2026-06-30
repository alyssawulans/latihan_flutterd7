// To parse this JSON data, do
//
//     final allBatchesModel = allBatchesModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'all_batches_model.g.dart';

AllBatchesModel allBatchesModelFromJson(String str) =>
    AllBatchesModel.fromJson(json.decode(str));

String allBatchesModelToJson(AllBatchesModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AllBatchesModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  AllBatchesModel({this.message, this.data});

  factory AllBatchesModel.fromJson(Map<String, dynamic> json) =>
      _$AllBatchesModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllBatchesModelToJson(this);
}

@JsonSerializable()
class Datum {
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
  @JsonKey(name: "trainings")
  List<Training>? trainings;

  Datum({
    this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.trainings,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Training {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "pivot")
  Pivot? pivot;

  Training({this.id, this.title, this.pivot});

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}

@JsonSerializable()
class Pivot {
  @JsonKey(name: "training_batch_id")
  String? trainingBatchId;
  @JsonKey(name: "training_id")
  String? trainingId;

  Pivot({this.trainingBatchId, this.trainingId});

  factory Pivot.fromJson(Map<String, dynamic> json) => _$PivotFromJson(json);

  Map<String, dynamic> toJson() => _$PivotToJson(this);
}
