import 'dart:io';

import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/features/main/main_controller.dart';
import '../../core/helper/utils.dart';
import '../../core/init/dependency_injection.dart';
import '../../core/network/user/user_api_calls.dart';
import '../../ui_imports.dart';

class ProfileController extends GetxController {
  final userApiCalls = getIt<UserApiCalls>();

  final isLoadingUploadImage = false.obs;
  final isLoadingUpdateInfo = false.obs;
  final TextEditingController cntFirstName = TextEditingController(
    text: BaseBrain.userModel.value.firstName,
  );
  final cntLastName = TextEditingController(
    text: BaseBrain.userModel.value.lastName,
  );
  void uploadImage() async {
    final file = await Utils.pickImageAndCrop(circleCrop: true);
    if (file != null) {
      if (Get.context!.mounted) {
        callApiUploadImage(file);
      }
    }
  }

  void callApiUploadImage(File file) async {
    isLoadingUploadImage.value = true;

    final result = await userApiCalls.uploadImage(file);
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Upload failed');
      },
      (profileImageUrl) {
        BaseBrain.userModel.value.profileImage = profileImageUrl;
        Get.find<MainController>().update();
      },
    );

    isLoadingUploadImage.value = false;
  }

  void callApiUpdateInfo() async {
    isLoadingUpdateInfo.value = true;

    final result = await userApiCalls.updateAccountInfo(
        cntFirstName.text, cntLastName.text);
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Update failed');
      },
      (updatedUser) {
        BaseBrain.userModel.value.firstName = cntFirstName.text;
        BaseBrain.userModel.value.lastName = cntLastName.text;
        ToastDialogs.showSuccessNotification(
            message: 'Profile updated successfully');
      },
    );
    isLoadingUpdateInfo.value = false;
  }
}
