import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String? id;
  final String? user;
  final String? input;
  final String? action;
  final String? prompt;
  @JsonKey(name: 'input_text')
  final String? inputText;
  final String? model;
  @JsonKey(name: 'byok_api_key')
  final String? byokApiKey;
  final String? status;
  @JsonKey(name: 'error_message')
  final String? errorMessage;
  @JsonKey(name: 'response_data')
  final String? responseData;
  final Map<String, dynamic>? meta;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const TaskModel({
    this.id,
    this.user,
    this.input,
    this.action,
    this.prompt,
    this.inputText,
    this.model,
    this.byokApiKey,
    this.status,
    this.errorMessage,
    this.responseData,
    this.meta,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  /// Converts TaskModel to JSON
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  /// Creates a copy of this TaskModel with the given fields replaced with new values
  TaskModel copyWith({
    String? id,
    String? user,
    String? input,
    String? action,
    String? prompt,
    String? inputText,
    String? model,
    String? byokApiKey,
    String? status,
    String? errorMessage,
    String? responseData,
    Map<String, dynamic>? meta,
    String? createdAt,
    String? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      user: user ?? this.user,
      input: input ?? this.input,
      action: action ?? this.action,
      prompt: prompt ?? this.prompt,
      inputText: inputText ?? this.inputText,
      model: model ?? this.model,
      byokApiKey: byokApiKey ?? this.byokApiKey,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      responseData: responseData ?? this.responseData,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns true if the task is completed
  bool get isCompleted => status?.toLowerCase() == 'completed';

  /// Returns true if the task has an error
  bool get hasError => errorMessage?.isNotEmpty == true;

  /// Returns true if the task is in progress
  bool get isInProgress => status?.toLowerCase() == 'in_progress' || status?.toLowerCase() == 'running';

  /// Returns true if the task is pending
  bool get isPending => status?.toLowerCase() == 'pending';

  /// Gets the tone from meta data
  String? get tone => meta?['Tone'] as String?;

  /// Gets the formality from meta data
  String? get formality => meta?['formality'] as String?;

  /// Gets a formatted created date if available
  DateTime? get createdAtDateTime {
    if (createdAt == null) return null;
    try {
      return DateTime.parse(createdAt!);
    } catch (e) {
      return null;
    }
  }

  /// Gets a formatted updated date if available
  DateTime? get updatedAtDateTime {
    if (updatedAt == null) return null;
    try {
      return DateTime.parse(updatedAt!);
    } catch (e) {
      return null;
    }
  }

  /// Converts TaskModel to API POST request format
  Map<String, dynamic> convertToApiPost() {
    return {
      'text': inputText ?? '',
      'prompt': prompt ?? '',
      'action': action ?? 'text',
      'model': model ?? 'openai/gpt-4o-mini',
      'meta': meta ?? {
        'formality': 'formal',
        'Tone': 'Normal',
      },
    };
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, status: $status, action: $action, prompt: $prompt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.user == user &&
        other.input == input &&
        other.action == action &&
        other.prompt == prompt &&
        other.inputText == inputText &&
        other.model == model &&
        other.byokApiKey == byokApiKey &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.responseData == responseData &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      user,
      input,
      action,
      prompt,
      inputText,
      model,
      byokApiKey,
      status,
      errorMessage,
      responseData,
      createdAt,
      updatedAt,
    );
  }
}