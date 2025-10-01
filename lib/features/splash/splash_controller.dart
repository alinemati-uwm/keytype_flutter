import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:keytype/core/helper/utils.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../core/helper/base_brain.dart';
import '../../ui_imports.dart';

enum InternetStatus { Connect, Disconnect, Loading, Vpn }

class SplashController extends GetxController {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final Rx<InternetStatus> internetStatus = InternetStatus.Connect.obs;
  final Connectivity connectivity = Connectivity();

  @override
  void onReady() {
    super.onReady();
    checkInternet();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> redirect() async {
    // Initialize tokens from storage
    await _initializeTokens();

    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        if (Utils.isLogin) {
          Get.offAndToNamed(Routes.main);
        } else {
        Get.offAndToNamed(Routes.intro);
        }
      },
    );
  }

  Future<void> _initializeTokens() async {
    try {
      final storage = await LocalStorageManager.getInstance();
      final accessToken = storage.getToken();
      final refreshToken = storage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        BaseBrain.accessToken = accessToken;
        BaseBrain.refreshToken = refreshToken;
      }
    } catch (e) {
      print('Error initializing tokens: $e');
    }
  }

  Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initCheckInternet() async {
    final result = await connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  Future<void> checkInternet() async {
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final hasNetwork = await isConnected();
    if (!hasNetwork) {
      await Future.delayed(
        const Duration(milliseconds: 500),
        () {
          internetStatus.value = InternetStatus.Disconnect;
        },
      );
    } else {
      internetStatus.value = InternetStatus.Connect;
      redirect();
    }
  }
}
