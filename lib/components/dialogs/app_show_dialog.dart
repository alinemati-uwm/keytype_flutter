

import '../../ui_imports.dart';

abstract class AppShowDialog{
  static show(Widget widget){
    return  showDialog(context: Get.context!, builder: (context) {
      return widget;
    });
  }
}