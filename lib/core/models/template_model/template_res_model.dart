import 'package:json_annotation/json_annotation.dart';

part 'template_res_model.g.dart';

@JsonSerializable()
class TemplateResModel {
  @JsonKey(name: 'category_name')
  final String? categoryName;

  final List<TemplateModel>? templates;

  TemplateResModel({
    this.categoryName,
    this.templates,
  });

  factory TemplateResModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateResModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateResModelToJson(this);
}

@JsonSerializable()
class TemplateModel {
  final int? id;
  final String? topic;
  final String? categoryName;
  final String? task;
  final String? prompt;
  // @JsonKey(fromJson: _parseParams)
  // final ParamModel? params;

  TemplateModel({
    this.id,
    this.topic,
    this.task,
    this.prompt,
    // this.params,
    this.categoryName,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateModelToJson(this);


}

@JsonSerializable()
class ParamModel {
  final String? type;
  final String? label;
  final String? description;
  final String? placeholder;

  ParamModel({
    this.type,
    this.label,
    this.description,
    this.placeholder,
  });

  factory ParamModel.fromJson(Map<String, dynamic> json) =>
      _$ParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParamModelToJson(this);
}
