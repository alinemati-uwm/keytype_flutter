
import 'package:flutter/services.dart';
import 'package:keytype/ui_imports.dart';

class NativeBridge {
  NativeBridge._internal();
  static final NativeBridge _instance = NativeBridge._internal();

  static NativeBridge get instance => _instance;


   final platform = MethodChannel('keyAI/native');

   Future<String?> getNativeData() async {
    try {
      final result = await platform.invokeMethod<String>('getNativeData');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get native data: '${e.message}'.");
      return null;
    }
  }


   Future<void> setupKeyboard()async{
     if(GetPlatform.isAndroid){
       try {
         final result = await platform.invokeMethod<String>('setupKeyboard');
         print("Message from method setupKeyboard $result");
         ToastDialogs.showSuccessNotification(
             message: result!
         );
       } on PlatformException catch (e) {
         print("Failed to get native data: '${e.message}'.");
       }
     }
     if(GetPlatform.isIOS){

     }
   }

}
