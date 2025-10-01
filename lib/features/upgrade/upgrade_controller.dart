import '../../core/helper/utils.dart';
import '../../core/init/dependency_injection.dart';
import '../../core/models/credit_model/plan_model.dart';
import '../../core/network/payments/payments_api_calls.dart';
import '../../ui_imports.dart';

class UpgradeController extends GetxController {
  final paymentsApiCalls = getIt<PaymentsApiCalls>();

  final isLoadingPlans = false.obs;
  final isLoadingPayment = false.obs;
  final listPlans = <PlanModel>[].obs;
  var currentTab = 0;
  final selectedPlan = PlanModel().obs;

  @override
  void onReady() {
    callApiPlans();

    super.onReady();
  }

  void callApiPlans({bool isMonthly = true}) async {
    isLoadingPlans.value = true;
    final result = await paymentsApiCalls.subscriptions(isMonthly);

    result.fold(
      (left) {},
      (right) {
        listPlans.value = right;
      },
    );

    isLoadingPlans.value = false;
  }

  void callApiPayment() async {
    isLoadingPayment.value = true;
    final result =
        await paymentsApiCalls.createPayment(selectedPlan.value.id ?? 0);

    result.fold(
      (left) {
        ToastDialogs.showErrorIconNotification(message: left.message ?? '');
      },
      (right) {
        Get.back();
        Utils.openUrl(right.url ?? '');
      },
    );

    isLoadingPayment.value = false;
  }

  bool get isYearly => currentTab == 0 ? false : true;
  void onTapTabBar(int index) {
    if (currentTab == index) return;
    currentTab = index;
    if (index == 0) {
      callApiPlans(isMonthly: true);
    } else {
      callApiPlans(isMonthly: false);
    }
    selectedPlan.value = PlanModel();
  }

  void onSelectPlan(PlanModel data) {
    selectedPlan.value = data;
    update();
  }
}
