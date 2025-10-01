

import 'package:json_annotation/json_annotation.dart';
import '../user_model/user_model.dart';
import '../workspace_model/workspace_model.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final UserModel? user;
  final WorkspaceModel? workspace;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.user,
    this.workspace,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
