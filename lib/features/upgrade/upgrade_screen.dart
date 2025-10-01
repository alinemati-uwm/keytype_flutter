import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/core/models/credit_model/subscription_model.dart';
import 'package:keytype/features/upgrade/upgrade_controller.dart';
import 'package:keytype/features/upgrade/widgets/balance_widget.dart';
import 'package:keytype/features/upgrade/widgets/buy_pro_plan_widget.dart';
import 'package:keytype/features/upgrade/widgets/plan_info_text_widget.dart';
import 'package:keytype/components/default_tab_widget.dart';
import '../../core/models/credit_model/plan_model.dart';
import '../../core/models/user_model/user_model.dart';
import '../../ui_imports.dart';
import '../../components/custom_button.dart';
import '../../components/custom_shimmer.dart';
import '../../components/custom_text_widget.dart';
import '../../components/dialogs/app_show_dialog.dart';
import '../../components/profile_widget.dart';

class UpgradeScreen extends GetView<UpgradeController> {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.black,
              titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
              title: Text('Upgrade'),
            ),
            bottomNavigationBar: _buildBuyButton,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ProfileWidget(),
                        const Gap(10),
                        SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                createTitle(BaseBrain.userModel.value),
                                style: AppTextTheme.textStyleDMSanse18W700(
                                    color: AppColors.white),
                              ),
                              const Gap(8),
                              const PlanInfoTextWidget(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                width: 75,
                                height: 18,
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        const BalanceWidget(),
                      ],
                    ),
                  ),
                  const Gap(16),
                  _buildStatusPlan(),
                  const Gap(16),
                  DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          DefaultTabWidget(
                              tabLabel: ['Monthly', 'Yearly'],
                              onTap: controller.onTapTabBar),
                          Gap(12),
                          _buildListView(),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }



  Widget get _buildBuyButton => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Obx(
      () => CustomButton(
        onTap: () {
          if (controller.selectedPlan.value.active == true ||
              controller.selectedPlan.value.id == null) {
            return;
          }
          AppShowDialog.show(
              BuyProPlanDialog(
                isYear: controller.isYearly,
                planModel: controller.selectedPlan.value,
                onContinuePressed: () {
                 controller.callApiPayment();
                },
              ));
        },
        text: _textSelectedPlan,
        color: (controller.selectedPlan.value.active == true ||
            controller.selectedPlan.value.id == null)
            ? AppColors.darkB
            : AppColors.primaryDefault,
        styleText:
        AppTextTheme.textStyleDMSanse14W700(color: AppColors.white),
      ),
    ),
  );

  String get  _textSelectedPlan{
    if(controller.selectedPlan.value.active == true){
      return 'Current Plan';
    }
    if(controller.selectedPlan.value.id == null){
      return 'Select Your Plan';
    }
    return 'Buy ${controller.selectedPlan.value.title} plan / \$${controller.selectedPlan.value.price}';
  }

  _buildListView() {
    return Obx(
      () {
        if (controller.isLoadingPlans.value) {
          return Column(
            children: List.generate(
              4,
              (index) {
                return  CustomShimmer(
                  height: 99,
                  width: double.infinity,
                  baseColor: AppColors.grey,
                  margin: EdgeInsets.only(bottom: 18),
                );
              },
            ),
          );
        }
        return ListView.builder(
            itemCount: controller.listPlans.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final element = controller.listPlans[index];
              final isSelected = controller.selectedPlan.value.id == element.id;
              return GestureDetector(
                onTap: () {
                controller.onSelectPlan(element);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 15.5, 12, 15.5),
                  margin: const EdgeInsets.only(bottom: 18),
                  constraints: const BoxConstraints(maxHeight: 99),
                  decoration: BoxDecoration(
                      color: isSelected ? Color(0xff8A8DB1) : AppColors.grey,
                      border: Border.all(
                          width: isSelected ? 1 : 0,
                          color: isSelected
                              ? Colors.white
                              : AppColors.transparent),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 68,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element.title ?? '',
                              style: AppTextTheme.textStyleDMSanse20W700(
                                  color: isSelected
                                      ? Color(0xff5729da)
                                      : Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              element.isMonthly!
                                  ? '1 Month'
                                  :  '1 Year',
                              style: AppTextTheme.textStyleDMSanse16W500(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _checkPlans(element)
                          ? SizedBox(
                              height: 68,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$ ${element.price ?? ''}',
                                    style: AppTextTheme.textStyleDMSanse14W400(),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${element.credit ?? ''}',
                                    style: AppTextTheme.textStyleDMSanse14W400(),
                                  ),
                                ],
                              ),
                            )
                          : const PlanInfoTextWidget(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              width: 107,
                              height: 30,
                            ),
                      const Gap(10),
                      !isSelected
                          ? const SizedBox.shrink()
                          : SvgPicture.asset(
                              'assets/icons/ic_tick_circle.svg',
                              height: 16,
                              width: 16,
                              colorFilter: ColorFilter.mode(
                                Color(0xff5729da),
                                BlendMode.srcIn,
                              ),
                            )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
  bool _checkPlans(PlanModel element) {
    final data = BaseBrain.userModel.value;

    if (data.plan == null) {
      return true;
    }
    return data.plan!.title != element.title;
  }

  String createTitle(UserModel? userModel) {
    if (userModel == null) {
      return 'user name';
    }
    if (userModel.username == null) {
      return '${userModel.firstName}';
    } else {
      return '@${userModel.username}';
    }
  }

  _buildStatusPlan() {
    final subscription =
        BaseBrain.userModel.value.subscription ?? SubscriptionModel();

    final minCredit = double.tryParse('${subscription.credit ?? '0.0'}') ?? 0.0;
    final maxCredit = subscription.baseCredit != null
        ? (double.tryParse('${subscription.baseCredit ?? 0.0}') ?? 0.0)
        : 0.0;
    final dateTime = DateTime.parse(subscription.endDate ?? '');
    final endTime = DateFormat('yyyy-MM-dd').format(dateTime);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.white, width: .5),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Referral',
                    style: AppTextTheme.textStyleDMSanse12W500(),
                  ),
                  const Gap(8),
                  Text(
                    '${subscription.referralBonus?.toInt() ?? ''}',
                    style: AppTextTheme.textStyleDMSanse18W700(
                        color: AppColors.primaryDefault),
                  )
                ],
              )),
          const Gap(8),
          Column(
            children: [
              SizedBox(
                height: 18,
                child: Row(
                  children: [
                    Text(
                      'Daily',
                      style: AppTextTheme.textStyleDMSanse12W400(
                          color: AppColors.white),
                    ),
                    const Spacer(),
                    Text(
                      '${subscription.dailyBonus} Available /  ${subscription.baseDailyBonus ?? 0.0} Total',
                      style: AppTextTheme.textStyleDMSanse12W400(),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              SliderTheme(
                data: buildSliderThemeData(),
                child: Slider(
                  value: (subscription.dailyBonus ?? 0).toDouble(),
                  max: subscription.baseDailyBonus != null
                      ? double.parse('${subscription.baseDailyBonus ?? 0.0}')
                      : 0.0,
                  onChanged: (value) {},
                ),
              ),
              const Gap(10),
            ],
          ),
          Opacity(
            opacity: isExpire ? 0.5 : 1,
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  Text(
                    'Plan',
                    style: AppTextTheme.textStyleDMSanse12W400(),
                  ),
                  const Spacer(),
                  Text(
                    '${subscription.credit ?? '0.0'} Available /  ${subscription.baseCredit ?? '0.0'} Total',
                    style: AppTextTheme.textStyleDMSanse12W400(),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          Opacity(
            opacity: isExpire ? 0.2 : 1,
            child: SliderTheme(
              data: buildSliderThemeData(),
              child: Slider(
                value: minCredit,
                max: max(minCredit, maxCredit),
                onChanged: (value) {},
              ),
            ),
          ),
          const Gap(10),
          if (isExpire)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_warning.svg',
                      colorFilter: ColorFilter.mode(
                        AppColors.errorLight,
                        BlendMode.srcIn,
                      ),
                    ),
                    Gap(8),
                    Expanded(
                      child: Text(
                        'Your subscription period has ended. Renew your subscription to rejoin the world of endless possibilities',
                        textAlign: TextAlign.start,
                        style: AppTextTheme.textStyleDMSanse12W400(
                            color: AppColors.errorLight),
                      ),
                    ),
                  ],
                ),
                Gap(6),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: RichText(
                      text: TextSpan(
                          text: 'However, you can use our ',
                          style: AppTextTheme.textStyleDMSanse12W500(
                              color: AppColors.warningDefault),
                          children: [
                        TextSpan(
                            text: 'referral system ',
                            style: AppTextTheme.textStyleDMSanse12W500(
                                    color: AppColors.white)
                                .copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.pushNamed(
                                //     context,
                                //     Screens
                                //         .referralAndReward);
                              }),
                        TextSpan(
                            text: 'to continue using the application.',
                            style: AppTextTheme.textStyleDMSanse12W500(
                                color: AppColors.warningDefault)),
                      ])),
                )
              ],
            )
          else
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_warning.svg',
                  colorFilter: ColorFilter.mode(
                    AppColors.warningDefault,
                    BlendMode.srcIn,
                  ),
                ),
                Gap(8),
                Expanded(
                  child: Text(
                    'Your subscription will end on $endTime',
                    textAlign: TextAlign.start,
                    style: AppTextTheme.textStyleDMSanse12W400(
                        color: AppColors.warningDefault),
                  ),
                ),
              ],
            ),
          const Gap(10),
          Text(
            'Reset every day at 0:00 UTC, non-accumulative.',
            textAlign: TextAlign.start,
            style: AppTextTheme.textStyleDMSanse12W400(),
          )
        ],
      ),
    );
  }

  SliderThemeData buildSliderThemeData() {
    return SliderThemeData(
        trackHeight: 8,
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: AppColors.primaryDefault,
        activeTickMarkColor: AppColors.primaryDefault,
        inactiveTrackColor: Color(0xffefefef),
        inactiveTickMarkColor: Color(0xffefefef),
        thumbShape: SliderComponentShape.noThumb,
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
        valueIndicatorColor: AppColors.white,
        valueIndicatorTextStyle:
            AppTextTheme.textStyleDMSanse12W600(color: AppColors.black));
  }

  bool get isExpire {
    final data = BaseBrain.userModel.value;

    final plan = data.subscription?.status;

    return plan == 'expired';
  }
}
