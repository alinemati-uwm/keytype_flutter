import 'package:keytype/core/native/native_bridge.dart';
import 'package:keytype/features/main/views/history/history_screen.dart';
import 'package:keytype/features/main/views/home/home_controller.dart';
import 'package:keytype/features/main/views/home/home_screen.dart';
import 'package:keytype/features/main/views/setting/setting_controller.dart';
import 'package:keytype/features/main/views/setting/setting_screen.dart';
import 'package:keytype/components/modals/coming_soon_modal.dart';
import '../../ui_imports.dart';
import 'views/history/history_controller.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  final pages = <String>['/home', '/history', '/settings'];

  void changePage(int index) {
    if (index == 1) {
      // History tab - show coming soon modal
      ComingSoonModal.show(
        context: Get.context!,
        featureName: 'History',
        description: 'View and manage your writing history. Access all your previous work and drafts in one place!',
        icon: Icons.history,
        primaryColor: const Color(0xFF6B46C1),
      );
      return;
    } else if (index == 2) {
      // Settings tab - show coming soon modal
      ComingSoonModal.show(
        context: Get.context!,
        featureName: 'Settings',
        description: 'Customize your KeyType experience. Manage preferences, themes, and account settings!',
        icon: Icons.settings,
        primaryColor: const Color(0xFF059669),
      );
      return;
    }
    
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      return GetPageRoute(
        settings: settings,
        page: () => HomeScreen(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => HomeController());
          },
        ),
      );
    }

    if (settings.name == '/history') {
      return GetPageRoute(
        settings: settings,
        page: () => HistoryScreen(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => HistoryController());
          },
        ),
      );
    }

    if (settings.name == '/settings') {
      return GetPageRoute(
        settings: settings,
        page: () => SettingScreen(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => SettingController());
          },
        ),
      );
    }

    return null;
  }

  void setUpKeyboard() async {
    NativeBridge.instance.setupKeyboard();
  }
}
