
import 'package:get/get.dart';
import 'package:keytype/core/models/user_model/user_model.dart';

import '../models/chat_bot_model/features_request_model.dart';

class BaseBrain {
  static String refreshToken = '';
  static String accessToken = '';

  static final userModel = UserModel().obs;


  static final settingAi =  SettingFutureModel(
  frequencyPenalty: 0.0,
  presencePenalty: 0.0,
  temperature: 0.4,
  topP: 1,
  );

}
