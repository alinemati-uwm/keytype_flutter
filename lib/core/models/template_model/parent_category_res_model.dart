import 'package:json_annotation/json_annotation.dart';

part 'parent_category_res_model.g.dart';

@JsonSerializable()
class ParentCategoryResModel {
  final int? id;
  final String? name;

  ParentCategoryResModel({
    this.id,
    this.name,
  });

  // Factory constructor for creating a new instance from a map
  factory ParentCategoryResModel.fromJson(Map<String, dynamic> json) =>
      _$ParentCategoryResModelFromJson(json);

  // Method to convert this instance back to a map
  Map<String, dynamic> toJson() => _$ParentCategoryResModelToJson(this);
}
