import 'package:get/get.dart';
import 'package:keytype/features/create/create_controller.dart';
import 'package:keytype/features/main/main_controller.dart';
import 'package:keytype/features/profile/profile_controller.dart';
import 'package:keytype/features/profile/profile_screen.dart';
import 'package:keytype/features/templates/template_controller.dart';
import 'package:keytype/features/upgrade/upgrade_controller.dart';
import '../../features/askAi/ask_ai_controller.dart';
import '../../features/askAi/ask_ai_screen.dart';
import '../../features/create/create_screen.dart';
import '../../features/intro/controller/intro_controller.dart';
import '../../features/intro/intro_screen.dart';
import '../../features/login/login_controller.dart';
import '../../features/login/login_screen.dart';
import '../../features/main/main_screen.dart';
import '../../features/splash/splash_controller.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/templates/template_screen.dart';
import '../../features/upgrade/upgrade_screen.dart';
import 'Routes.dart';

class Nav {
  Nav._();

  static List<GetPage> allNav = [

    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(
              () => SplashController(),
        );
      },),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(
              () => LoginController(),
        );
      },),
    ),
    GetPage(
      name: Routes.intro,
      page: () => const IntroScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<IntroController>(
              () => IntroController(),
        );
      },),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MainController>(
              () => MainController(),
        );
      },),
    ),

    GetPage(
      name: Routes.askAi,
      page: () => const AskAiScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AskAiController>(
              () => AskAiController(),
        );
      },),
    ),
    GetPage(
      name: Routes.templates,
      page: () => const TemplateScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TemplateController>(
              () => TemplateController(),
        );
      },),
    ),
    GetPage(
      name: Routes.create,
      page: () => const CreateScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateController>(
              () => CreateController(),
        );
      },),
    ),
    GetPage(
      name: Routes.upgrade,
      page: () => const UpgradeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UpgradeController>(
              () => UpgradeController(),
        );
      },),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>(
              () => ProfileController(),
        );
      },),
    ),


  ];
}
