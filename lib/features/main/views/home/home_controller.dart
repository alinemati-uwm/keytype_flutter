import 'dart:developer';

import 'package:get/get.dart';
import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/core/network/auth/auth_api_calls.dart';
import 'package:keytype/core/storage/local_storage_manager.dart';
import '../../../../core/init/dependency_injection.dart';
import '../../../../core/network/user/user_api_calls.dart';

class HomeController extends GetxController {
  final userApiCalls = getIt<UserApiCalls>();
  final authApis = getIt<AuthApiCalls>();

  @override
  void onReady() {
    super.onReady();
    callUserInfo();
  }

  final isLoading = false.obs;

  Future<void> callUserInfo() async {
    isLoading.value = true;

    final result = await userApiCalls.getUserInfo();
    result.fold(
      (left) async {
        final refresh = await LocalStorageManager.getInstance().then((val) async {
          return val.getRefreshToken();
        });
        log("========");
        log("refresh: $refresh");
        log("========");

        // final res = await authApis.autoRefreshToken(refreshToken: refresh ?? "");
        // log("========");
        // log("${res.fold((left) {
        //   log("res left: ${left.message}");
        // }, (right) {
        //   log("res right: $right");
        // })}");
      },
      (right) {
        BaseBrain.userModel.value = right;
      },
    );

    isLoading.value = false;
  }
}
