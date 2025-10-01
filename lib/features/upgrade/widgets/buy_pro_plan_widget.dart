
import 'package:keytype/features/upgrade/upgrade_controller.dart';
import 'package:keytype/components/custom_loading.dart';

import '../../../core/models/credit_model/plan_model.dart';
import '../../../ui_imports.dart';

class BuyProPlanDialog extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final PlanModel planModel;
  final bool isYear;

   BuyProPlanDialog({
    super.key,
    required this.onContinuePressed,
    required this.planModel,
    this.isYear = false,
  });
  final controller = Get.find<UpgradeController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.dark,
      insetPadding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        constraints: const BoxConstraints(maxHeight: 490),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upgrade plan',
              style: AppTextTheme.textStyleDMSanse16W700(),
            ),
            const Gap(8),
            Text(
              'Upgrade your plan and enjoy the powerful features!',
              style: AppTextTheme.textStyleDMSanse14W400(),
            ),
            const Gap(8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
              constraints: const BoxConstraints(maxHeight: 111),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradientA.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Upgrade to Annual ${planModel.title}',
                        style: AppTextTheme.textStyleDMSanse16W700(),
                      )),
                  const Gap(10),
                  _buildDialogPriceSizedBox(
                      'Price',
                      '\$${planModel.price} / ${isYear ? 'year' : 'mo'}',
                      context),
                  const Gap(10),
                  _buildDialogPriceSizedBox('Total',
                      '\$${planModel.price}', context),
                ],
              ),
            ),
            const Gap(24),
            Text(
              'Payment option',
              style: AppTextTheme.textStyleDMSanse16W400(),
            ),
            const Gap(24),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1.5,
                          color: AppColors.primaryDefault,
                        )),
                    width: 66,
                    height: 66,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImage(
                        url: 'assets/images/img-pay-pal.png',
                        size: 150,
                      ),
                    ),
                  ),
                  const Gap(24),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(
                        //   color: AppColors.primaryDefault,
                        // )
                      ),
                      width: 66,
                      height: 66,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImage(
                          url: 'assets/images/img-tether.png',
                          size: 150,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text(
                    'Due today',
                    style: AppTextTheme.textStyleDMSanse12W400(),
                  ),
                  const Spacer(),
                  Text(
                    '\$${planModel.price} / ${isYear ? 'year' : 'mo'}',
                    style: AppTextTheme.textStyleDMSanse16W700(
                        color: AppColors.primaryDefault),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: AppColors.white),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'cancel',
                            style: AppTextTheme.textStyleDMSanse14W700(),
                          ))),
                  const Gap(16),
                  Expanded(
                      child: Obx(
                        () => ElevatedButton(
                            onPressed: onContinuePressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDefault,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: controller.isLoadingPayment.value
                                ? CustomLoading(
                                    color: AppColors.white,
                                  )
                                : Text(
                                    'Continue',
                                    style: AppTextTheme.textStyleDMSanse14W700(
                                        color: AppColors.white),
                                  )),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox _buildDialogPriceSizedBox(
      String title, String price, BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Text(
            title,
            style: AppTextTheme.textStyleDMSanse14W400(),
          ),
          const Spacer(),
          Text(
            price,
            style: AppTextTheme.textStyleDMSanse14W700(),
          )
        ],
      ),
    );
  }
}
