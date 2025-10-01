import 'package:keytype/features/splash/splash_controller.dart';
import 'package:keytype/components/custom_loading.dart';
import 'package:keytype/utils/screen_functions.dart';
import '../../ui_imports.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (_) {
        final double fontSize = ScreenUtils.getScreenWidth(context) * 0.09;
        return Scaffold(
          body: Stack(
            children: [
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo-new.png',
                        scale: 3,
                      ),
                      const Gap(8),
                      ShaderMask(
                        shaderCallback: (final bounds) =>
                            AppColors.bgGradient.createShader(
                              Rect.fromLTWH(
                                0,
                                0,
                                bounds.width,
                                bounds.height,
                              ),
                            ),
                        child: Text(
                          'Keyboard AI',
                          style: TextStyle(
                            fontSize: fontSize.clamp(12.0, 36),
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 38,
                  right: 0,
                  left: 0,
                  child: _buildStatusInternet())
            ],
          ),
        );
      },
    );
  }

  _buildStatusInternet(){
    return  Obx(
          () {
        if(controller.internetStatus.value == InternetStatus.Disconnect){
          return InkWell(
            onTap: () async {
              controller.internetStatus.value = InternetStatus.Loading;
              await controller.initCheckInternet();
            },
            child: Column(
              spacing: 8,
              children: [
                const Icon(
                  Icons.sync,
                  size: 24,
                ),
                Text(
                  'Connection Error',
                  style: AppTextTheme.textStyleDMSanse14W500(),
                )
              ],
            ),
          );
        }

        return const CustomLoading();
      },
    );

  }


}