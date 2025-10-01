import 'package:keytype/core/storage/local_storage_manager.dart';

import '../../../../ui_imports.dart';
import '../../../../components/dialogs/app_show_dialog.dart';
import '../../../../components/dialogs/default_dialog.dart';
import '../../../profile/widgets/logout_dialog.dart';
import '../../../test_keyboard/test_keyboard_screen.dart';
import 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keyboard',
                      style: AppTextTheme.textStyleDMSanse16W700(
                          color: Colors.grey),
                    ),
                    Gap(24),
                    _buildTestKeyboard,
                    Gap(16),
                    _buildOptions(
                        title: 'Typing suggestions',
                        onChange: (value) {
                          controller.onChangeTypeSuggestionValue();
                        },
                        state: controller.typeSuggestionValue),
                    _buildOptions(
                        title: 'Auto-Correction',
                        onChange: (value) {
                          controller.onChangeAutoCorrectionValue();
                        },
                        state: controller.autoCorrectionValue),
                    Gap(20),
                    Center(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: radius12)),
                          onPressed: () async {
                            await LocalStorageManager.getInstance().then((val) async {
                              val.clear();
                            });
                            AppShowDialog.show(DefaultDialog(
                                widget: SingleChildScrollView(
                                    child: LogoutDialog())));
                          },
                          child: Text(
                            'Logout',
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildOptions(
      {required String title,
      required ValueChanged<bool>? onChange,
      required RxBool state}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      margin: EdgeInsets.only(bottom: 12),
      decoration:
          BoxDecoration(color: const Color(0xFF4B4B4B), borderRadius: radius12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Obx(
            () => Switch(value: state.value, onChanged: onChange),
          )
        ],
      ),
    );
  }

  Widget get _buildTestKeyboard {
    return InkWell(
      borderRadius: radius14,
      onTap: () {
        Get.to(() => TestKeyboardScreen());
      },
      child: Container(
        height: 45,
        decoration:
            BoxDecoration(color: AppColors.grey, borderRadius: radius12),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Test keyboardAI',
              style: AppTextTheme.textStyleDMSanse14W400(),
            ),
            Icon(Icons.keyboard)
          ],
        ),
      ),
    );
  }
}
