
import 'package:json_annotation/json_annotation.dart';

part 'stream_message_model.g.dart';

@JsonSerializable()
class StreamMessageModel {
  final String? content;
  final String? functionCall;
  final String? role;
  final String? uuid;
  final String? toolsCall;

  StreamMessageModel({
    this.content,
    this.functionCall,
    this.role,
    this.uuid,
    this.toolsCall,
  });

  factory StreamMessageModel.fromJson(Map<String, dynamic> json) =>
      _$StreamMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamMessageModelToJson(this);
}