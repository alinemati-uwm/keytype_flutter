import 'package:json_annotation/json_annotation.dart';

part 'writing_style_model.g.dart';

@JsonSerializable()
class WritingStyleModel {
  final List<WritingStyleItemModel>? topic;
  final List<WritingStyleItemModel>? length;
  final List<WritingStyleItemModel>? style;

  WritingStyleModel({
    this.topic,
    this.length,
    this.style,
  });

  factory WritingStyleModel.fromJson(Map<String, dynamic> json) =>
      _$WritingStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$WritingStyleModelToJson(this);
}

@JsonSerializable()
class WritingStyleItemModel {
  final int? id;
  final String? title;

  WritingStyleItemModel({
    this.id,
    this.title,
  });

  factory WritingStyleItemModel.fromJson(Map<String, dynamic> json) =>
      _$WritingStyleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WritingStyleItemModelToJson(this);
}
