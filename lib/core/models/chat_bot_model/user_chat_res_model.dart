import 'package:json_annotation/json_annotation.dart';

part 'user_chat_res_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserChatResModel {
  final int? id;
  final String? role;
  final String? text;
  final String? like;
  @JsonKey(name: 'model_icon')
  final String? modelIcon;
  final List<FileDetail>? files;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final List<UserChatResModel>? answer;

  UserChatResModel({
    this.id,
    this.role,
    this.text,
    this.like,
    this.files,
    this.createdAt,
    this.modelIcon,
    this.answer,
  });

  UserChatResModel copyWith(
          {int? id,
          String? role,
          String? text,
          String? like,
          List<FileDetail>? files,
          String? createdAt,
          String? modelIcon,
          List<UserChatResModel>? answer}) =>
      UserChatResModel(
          id: id ?? this.id,
          role: role ?? this.role,
          text: text ?? this.text,
          like: like ?? this.like,
          files: files ?? this.files,
          modelIcon: modelIcon ?? this.modelIcon,
          createdAt: createdAt ?? this.createdAt,
          answer: answer ?? this.answer);

  factory UserChatResModel.fromJson(Map<String, dynamic> json) =>
      _$UserChatResModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserChatResModelToJson(this);
}

@JsonSerializable()
class FileDetail {
  final String? title;
  final String? url;

  FileDetail({this.title, this.url});

  factory FileDetail.fromJson(Map<String, dynamic> json) =>
      _$FileDetailFromJson(json);

  Map<String, dynamic> toJson() => _$FileDetailToJson(this);

  FileDetail copyWith({String? title, String? url}) =>
      FileDetail(title: title ?? this.title, url: url ?? this.url);
}
