import 'package:flutter/gestures.dart';
import 'package:keytype/features/intro/views/present_screen.dart';
import 'package:keytype/components/custom_button.dart';
import 'package:keytype/components/custom_text_widget.dart';
import 'package:keytype/utils/screen_functions.dart';

import '../../ui_imports.dart';
import 'controller/intro_controller.dart';

class IntroScreen extends GetView<IntroController> {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(20),
                  CustomImage(
                    url: 'assets/images/logo-nerd.png',
                    size: ScreenUtils.getScreenWidth(context) * 0.3,
                  ),
                  Text(
                    'Use AI Keyboard \n In Any App',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.textStyleDMSanse24W700(),
                  ),
                  Gap(12),
                  CustomTextWidget(
                    'Powered by NematiAI',
                    style: AppTextTheme.textStyleDMSanse12W400(),
                  ),
                  Expanded(
                    child: CustomImage(
                      url: 'assets/images/img-keyboard-1.png',
                      size: ScreenUtils.getScreenWidth(context) * 0.9,
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      Get.to(() => PresentScreen(),
                          transition: Transition.fadeIn);
                    },
                    text: 'Continue',
                  ),
                  Gap(12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Use',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Terms of Use Clicked");
                            },
                        ),
                        const TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Privacy Policy Clicked");
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
