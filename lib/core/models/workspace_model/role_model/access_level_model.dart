
import 'package:json_annotation/json_annotation.dart';

part 'access_level_model.g.dart';

@JsonSerializable()
class AccessLevelModel {
  final String? title;

  AccessLevelModel({this.title});

  factory AccessLevelModel.fromJson(Map<String, dynamic> json) => _$AccessLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessLevelModelToJson(this);
}