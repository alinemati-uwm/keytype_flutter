

import 'package:get/get.dart';

class SettingController extends GetxController {


  final typeSuggestionValue = false.obs;
  final autoCorrectionValue = false.obs;


  void onChangeTypeSuggestionValue(){
    typeSuggestionValue.value = !typeSuggestionValue.value;
  }

  void onChangeAutoCorrectionValue(){
    autoCorrectionValue.value = !autoCorrectionValue.value;
  }
}