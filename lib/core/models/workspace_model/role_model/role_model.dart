import 'package:json_annotation/json_annotation.dart';

import 'access_level_model.dart';

part 'role_model.g.dart';

@JsonSerializable()
class RoleModel {
  final String? title;

  @JsonKey(name: 'access_level')
  final List<AccessLevelModel>? accessLevel;

  RoleModel({this.title, this.accessLevel});

  // متد ساخت از JSON
  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

  // متد تبدیل به JSON
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}