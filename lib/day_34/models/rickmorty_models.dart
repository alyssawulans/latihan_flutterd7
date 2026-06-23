// To parse this JSON data, do
//
//     final rickmortyModels = rickmortyModelsFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'rickmorty_models.g.dart';

RickmortyModels rickmortyModelsFromJson(String str) =>
    RickmortyModels.fromJson(json.decode(str));

String rickmortyModelsToJson(RickmortyModels data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RickmortyModels {
  @JsonKey(name: "info")
  Info info;
  @JsonKey(name: "results")
  List<Result> results;

  RickmortyModels({required this.info, required this.results});

  factory RickmortyModels.fromJson(Map<String, dynamic> json) =>
      _$RickmortyModelsFromJson(json);

  Map<String, dynamic> toJson() => _$RickmortyModelsToJson(this);
}

@JsonSerializable()
class Info {
  @JsonKey(name: "count")
  int count;
  @JsonKey(name: "pages")
  int pages;
  @JsonKey(name: "next")
  String next;
  @JsonKey(name: "prev")
  dynamic prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Result {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "status")
  Status status;
  @JsonKey(name: "species")
  Species species;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "gender")
  Gender gender;
  @JsonKey(name: "origin")
  Location origin;
  @JsonKey(name: "location")
  Location location;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "episode")
  List<String> episode;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "created")
  DateTime created;

  Result({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

enum Gender {
  @JsonValue("Female")
  FEMALE,
  @JsonValue("Male")
  MALE,
  @JsonValue("unknown")
  UNKNOWN,
}

final genderValues = EnumValues({
  "Female": Gender.FEMALE,
  "Male": Gender.MALE,
  "unknown": Gender.UNKNOWN,
});

@JsonSerializable()
class Location {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "url")
  String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

enum Species {
  @JsonValue("Alien")
  ALIEN,
  @JsonValue("Human")
  HUMAN,
}

final speciesValues = EnumValues({
  "Alien": Species.ALIEN,
  "Human": Species.HUMAN,
});

enum Status {
  @JsonValue("Alive")
  ALIVE,
  @JsonValue("Dead")
  DEAD,
  @JsonValue("unknown")
  UNKNOWN,
}

final statusValues = EnumValues({
  "Alive": Status.ALIVE,
  "Dead": Status.DEAD,
  "unknown": Status.UNKNOWN,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
