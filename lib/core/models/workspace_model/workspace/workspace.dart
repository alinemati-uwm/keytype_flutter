import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable()
class Workspace {
  final String? name;
  final int? id;

  Workspace({
    this.name,
    this.id,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) => _$WorkspaceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceToJson(this);
}
