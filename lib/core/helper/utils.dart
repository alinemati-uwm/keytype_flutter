import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:keytype/core/helper/extensions/app_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ui_imports.dart';
import '../models/user_model/user_model.dart';
import '../storage/local_storage_manager.dart';
import 'base_brain.dart';

class Utils {
  static final Utils _singleton = Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

  static bool get isLogin {
    if (!BaseBrain.accessToken.isNullOrEmpty) {
      return true;
    }
    return false;
  }

  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void copyText(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      ToastDialogs.showSuccessNotification(
          title: 'Copied', message: 'Text Copied to Clipboard');
    }
  }

  static void shareText(String text) {
    if (text.isNotEmpty) {
      Share.share(text, subject: 'Chat GPT prompt');
    }
  }

  static Future<void> saveToken(String refreshToken, String accessToken) async {
    BaseBrain.refreshToken = refreshToken;
    BaseBrain.accessToken = accessToken;
    final storage = await LocalStorageManager.getInstance();
    storage.saveString(KeyNameStorage.accessToken, accessToken);
    storage.saveString(KeyNameStorage.refreshToken, refreshToken);
    print("NEW TOKEN ${BaseBrain.accessToken}");
    // ApiClientHelper.set(receivedNewToken: true);
  }

  static Future<void> saveDevicePrefrences({
    // ignore: non_constant_identifier_names
    required String id, required String device_id, required String deviceName
  }) async {
    final storage = await LocalStorageManager.getInstance();
    storage.saveString(KeyNameStorage.deviceID, device_id);
    storage.saveString(KeyNameStorage.deviceName, deviceName);
    storage.saveString('deviceID', id);
  }

  static Future<bool> saveID(String userID) async {
    final storage = await LocalStorageManager.getInstance();
    storage.saveString(KeyNameStorage.userId, userID);
    return true;
  }

  static String get nameOfUser {
    final UserModel userModel = BaseBrain.userModel.value;
    if (userModel.username == null) {
      return '';
    }
    String name;
    if (userModel.firstName!.isNotEmpty && userModel.lastName!.isNotEmpty) {
      name = userModel.firstName!.toUpperCase().split('').first +
          userModel.lastName!.toUpperCase().split('').first;
    } else if (userModel.firstName!.isNotEmpty) {
      name = userModel.firstName!.toUpperCase().split('').first;
    } else if (userModel.lastName!.isNotEmpty) {
      name = userModel.lastName!.toUpperCase().split('').first;
    } else {
      final nameArr = userModel.username!.toUpperCase().split('');
      name = nameArr.first + nameArr[1];
    }

    return name;
  }

  static Future<File?> pickImageAndCrop(
      {bool circleCrop = false, List<String>? types}) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final status = await Permission.storage.status;

        if (status.isPermanentlyDenied) {
          openAppSettings();
          return null;
        }
        final bool permissionGranted =
            await _PermissionHandler.requestStoragePermission();
        if (!permissionGranted) {
          return null;
        }
      } else {
        final status = await Permission.photos.status;
        if (status.isPermanentlyDenied) {
          openAppSettings();
          return null;
        }
        final bool permissionGranted =
            await _PermissionHandler.requestPhotosPermission();
        if (!permissionGranted) {
          return null;
        }
      }
    }
    File? pickedFile;
    final result = await FilePicker.platform.pickFiles(
        type: types != null ? FileType.custom : FileType.image,
        allowedExtensions: types);
    if (result != null) {
      final file = File(result.files.single.path!);
      final croppedFile = await Utils.cropImage(file, circleCrop: circleCrop);
      if (croppedFile != null) {
        pickedFile = croppedFile;
      }
    }
    return pickedFile;
  }

  static Future<File?> cropImage(File file, {bool circleCrop = false}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Your Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          cropStyle: circleCrop ? CropStyle.circle : CropStyle.rectangle,
          hideBottomControls: false,
          lockAspectRatio: false,
          statusBarColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            // CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  static void openUrl(String textUrl) async {
    try {
      final url = Uri.parse(textUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ToastDialogs.showErrorIconNotification(message: 'Could not open site');
        throw 'Could not open site';
      }
    } catch (e) {
      ToastDialogs.showErrorIconNotification(message: 'Could not open site');
      throw 'Could not open site';
    }
  }

  static void logout() async {
    final storage = await LocalStorageManager.getInstance();
    storage.clear();
    Get.offNamedUntil(
      Routes.intro,
      (route) => false,
    );
  }
}

class _PermissionHandler {
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
