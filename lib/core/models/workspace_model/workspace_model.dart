import 'package:json_annotation/json_annotation.dart';
import 'package:keytype/core/models/workspace_model/role_model/role_model.dart';
import 'package:keytype/core/models/workspace_model/workspace/workspace.dart';

part 'workspace_model.g.dart';

@JsonSerializable()
class WorkspaceModel {
  final Workspace? workspace;
  final int? id;
  final RoleModel? role;
  @JsonKey(name: 'is_base')
  final bool? isBase;
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final String? key;

  WorkspaceModel({
    this.workspace,
    this.id,
    this.role,
    this.isBase,
    this.isDefault,
    this.key,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) => _$WorkspaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}
