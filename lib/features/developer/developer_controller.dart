


import 'dart:convert';

import 'package:get/get.dart';

import '../../core/helper/base_brain.dart';
import '../../core/helper/universal_api.dart';
import '../../core/models/chat_bot_model/features_request_model.dart';

class DeveloperController extends GetxController{

  final resultText = ''.obs;

  void apiGenerateAiCreateText([String message = 'hello how are u ?'])async{
    final data = FeaturesRequestModel(
        promptType: 'create_text_keyboard',
        appType: 'ai_writer',
        message: message,
        model: 'gpt-4o-mini',
        setting: BaseBrain.settingAi,
      );
    await UniversalApi.generateAi(
      data: data,
      onNewMessage: (message) {
        resultText.value = message;
      },
      onDone: () {

      final data = jsonDecode(resultText.value);
      print("First Data ${data['1']}");
      },
    );

  }
}