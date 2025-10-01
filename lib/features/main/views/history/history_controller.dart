import 'package:get/get.dart';
import 'package:keytype/core/models/history/history_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/init/dependency_injection.dart';
import '../../../../core/network/chatbot/chatbot_api_calls.dart';

class HistoryController extends GetxController {
  final chatBotApiCalls = getIt<ChatBotApiCalls>();

  final isLoading = false.obs;
  final refreshController = RefreshController();

  @override
  void onReady() {
    callApiHistory();
    super.onReady();
  }

  var listHistory = <GeneratedHistoryItemModel>[];
  Future<void> callApiHistory() async {
    isLoading.value = true;

    final result = await chatBotApiCalls.historyAskAi();
    result.fold(
      (left) {},
      (right) {
        listHistory = right;
        update();
      },
    );

    isLoading.value = false;
  }

  void onRefresh() {
    callApiHistory();
    refreshController.loadComplete();
  }
}
