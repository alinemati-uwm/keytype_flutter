import 'package:json_annotation/json_annotation.dart';

part 'chat_bot_conversation_res_model.g.dart';

@JsonSerializable()
class ChatBotConversationResModel {
   String? content;

  @JsonKey(name: 'function_call')
  final String? functionCall;

  final String? role;

  @JsonKey(name: 'tool_calls')
  final String? toolCalls;

  final String? refusal;

  @JsonKey(name: 'conversation_uuid')
  final String? conversationUuid;

  final List<int?>? chats;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'model_icon')
  final String? modelIcon;

  final String? id;

  final String? uuId;

  ChatBotConversationResModel({
    this.content,
    this.functionCall,
    this.role,
    this.toolCalls,
    this.refusal,
    this.conversationUuid,
    this.chats,
    this.createdAt,
    this.modelIcon,
    this.id,
    this.uuId,
  });

  factory ChatBotConversationResModel.fromJson(Map<String, dynamic> json) =>
      _$ChatBotConversationResModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatBotConversationResModelToJson(this);
}
