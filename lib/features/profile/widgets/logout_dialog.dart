import '../../../core/helper/utils.dart';
import '../../../ui_imports.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_widget.dart';
import '../../../components/dialogs/default_dialog.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      widget: Container(
        margin: const EdgeInsets.only(left: 17, right: 17),
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              'Logout',
              style: AppTextTheme.textStyleDMSanse16W700(
               ),
            ),
            const Gap(12),
            CustomTextWidget(
              'Are you sure you want to log out ?',
              style: AppTextTheme.textStyleDMSanse14W500(
                  ),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                    color: AppColors.primaryDefault,
                    width: 85,
                    height: 35,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    styleText: AppTextTheme.textStyleDMSanse14W700(
                        color: AppColors.white),
                    text: 'Close'),
                const Gap(16),
                CustomButton(
                    color: AppColors.darkDefault,
                    width: 95,
                    height: 35,
                  onTap: () async{
                      Utils.logout();

                    },
                    styleText: AppTextTheme.textStyleDMSanse14W700(
                        color:  AppColors.white),
                    text: 'Logout',),
              ],
            )
          ],
        ),
      ),
    );
  }
}
