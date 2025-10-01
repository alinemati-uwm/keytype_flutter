
class GeneratedHistoryItemModel {
  int? id;
  String? answerText;
  String? prompt;
  String? uuid;
  String? appType;
  bool? pin;
  bool? favorite;
  String? createdAt;
  String? updatedAt;
  List<String>? urls;
  String? title;
  String? iconModel;
  IconGeneratorModel? iconGeneratorModel;
  bool? isPined;
  bool? isLoading;
  bool? fromVersions;

  GeneratedHistoryItemModel({
    this.id,
    this.answerText,
    this.prompt,
    this.uuid,
    this.appType,
    this.pin,
    this.favorite,
    this.createdAt,
    this.updatedAt,
    this.urls,
    this.title,
    this.fromVersions,
    this.iconModel,
    this.iconGeneratorModel,
    this.isPined,
    this.isLoading,
  });

  factory GeneratedHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return GeneratedHistoryItemModel(
      id: json['id'] as int?,
      answerText: json['answer_text'] as String?,
      prompt: json['prompt'] as String?,
      uuid: json['uuid'] as String?,
      appType: json['app_type'] as String?,
      pin: json['pin'] as bool?,
      favorite: json['favorite'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      urls: (json['urls'] as List<dynamic>?)?.map((e) => e as String).toList(),

      title: json['title'] as String?,
      fromVersions: json['fromVersions'] as bool?,
      iconModel: json['model_icon'] as String?,
      iconGeneratorModel: json['model_generator'] != null
          ? IconGeneratorModel.fromJson(json['model_generator'] as Map<String, dynamic>)
          : null,
      isPined: json['isPined'] as bool?,
      isLoading: json['isLoading'] as bool?,
    );
  }
  GeneratedHistoryItemModel copyWith({
    int? id,
    String? answerText,
    String? prompt,
    String? uuid,
    String? appType,
    bool? pin,
    bool? favorite,
    String? createdAt,
    String? updatedAt,
    List<String>? urls,
    String? title,
    bool? fromVersions,
    String? iconModel,
    IconGeneratorModel? iconGeneratorModel,
    bool? isPined,
    bool? isLoading,
  }) {
    return GeneratedHistoryItemModel(
      id: id ?? this.id,
      answerText: answerText ?? this.answerText,
      prompt: prompt ?? this.prompt,
      uuid: uuid ?? this.uuid,
      appType: appType ?? this.appType,
      pin: pin ?? this.pin,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      urls: urls ?? this.urls,
      title: title ?? this.title,
      fromVersions: fromVersions ?? this.fromVersions,
      iconModel: iconModel ?? this.iconModel,
      iconGeneratorModel: iconGeneratorModel ?? this.iconGeneratorModel,
      isPined: isPined ?? this.isPined,
      isLoading: isLoading ?? this.isLoading,
    );
  }

}
class IconGeneratorModel {
  int? id;
  String? name;
  String? icon;

  IconGeneratorModel({this.id, this.name, this.icon});

  IconGeneratorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}
