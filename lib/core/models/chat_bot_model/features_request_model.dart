class FeaturesRequestModel {
  String? message;
  String? appType;
  String? model;
  PromptContextModel? promptContext;
  String? promptType;
  SettingFutureModel? setting;

  FeaturesRequestModel(
      {this.message,
      this.model,
      this.appType,
      this.promptContext,
      this.promptType,
      this.setting});

  FeaturesRequestModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    model = json['model'];
    appType = json['app_type'];
    promptContext = json['prompt_context'] != null
        ? PromptContextModel.fromJson(json['prompt_context'])
        : null;
    promptType = json['prompt_type'];
    setting = json['setting'] != null
        ? SettingFutureModel.fromJson(json['setting'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['model'] = model;
    data['app_type'] = appType;
    if (promptContext != null) {
      data['prompt_context'] = promptContext!.toJson();
    }
    data['prompt_type'] = promptType;
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    return data;
  }
}

class PromptContextModel {
  String? format;
  String? language;
  String? length;
  String? pointOfView;
  String? toneOfVoice;
  String? userInput;
  String? style;
  String? characters;
  String? replyTo;
  String? type;

  PromptContextModel(
      {this.format,
      this.language,
      this.length,
      this.pointOfView,
      this.userInput,
      this.style,
      this.characters,
      this.replyTo,
      this.type,
      this.toneOfVoice});

  PromptContextModel.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    language = json['language'];
    length = json['length'];
    pointOfView = json['point_of_view'];
    toneOfVoice = json['tone_of_voice'];
    userInput = json['user_input'];
    style = json['style'];
    characters = json['characters'];
    replyTo = json['replyTo'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (format != null) {
      data['format'] = format;
    }
    if (language != null) {
      data['language'] = language;
    }
    if (length != null) {
      data['length'] = length;
    }
    if (pointOfView != null) {
      data['point_of_view'] = pointOfView;
    }
    if (toneOfVoice != null) {
      data['tone_of_voice'] = toneOfVoice;
    }
    if(userInput != null){
      data['user_input'] = userInput;
    }
    if(style != null){
      data['style'] = style;
    }
    if(characters != null){
      data['characters'] = characters;
    }
    if(replyTo != null){
      data['replyTo'] = replyTo;
    }
    if(type != null){
      data['type'] = type;
    }
    return data;
  }
}

class SettingFutureModel {
  double? frequencyPenalty;
  double? presencePenalty;
  double? temperature;
  double? topP;

  SettingFutureModel(
      {this.frequencyPenalty,
      this.presencePenalty,
      this.temperature,
      this.topP});

  SettingFutureModel.fromJson(Map<String, dynamic> json) {
    frequencyPenalty = json['frequency_penalty'];
    presencePenalty = json['presence_penalty'];
    temperature = json['temperature'];
    topP = json['top_p'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['frequency_penalty'] = frequencyPenalty;
    data['presence_penalty'] = presencePenalty;
    data['temperature'] = temperature;
    data['top_p'] = topP;
    return data;
  }
}
