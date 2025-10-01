import 'package:keytype/components/custom_loading.dart';
import 'package:keytype/components/custom_text_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../ui_imports.dart';
import 'history_controller.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return CustomLoading();
                  }
                  return SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: ListView.builder(
                      itemCount: controller.listHistory.length,
                      itemBuilder: (context, index) {
                        final data = controller.listHistory[index];
                        return InkWell(
                          borderRadius: radius16,
                          onTap: () {
                            Get.toNamed(Routes.askAi,arguments: {'uuId' : data.uuid});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: AppColors.grey, borderRadius: radius10),
                            margin: EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(child: CustomTextWidget(data.title ?? '')),
                                Icon(Icons.arrow_forward_ios,
                                size: 16,)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
