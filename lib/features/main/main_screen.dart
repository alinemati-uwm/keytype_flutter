import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:keytype/features/main/widgets/appbar_main_widget.dart';

import '../../ui_imports.dart';
import 'main_controller.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
            if(didPop){
              return;
            }
            if(controller.currentIndex.value != 0){
              controller.changePage(0);
            }
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight + 150),
                child: Obx(
                  () => AppbarMainWidget(
                    title: controller.currentIndex.value == 0?'Home' :
                    controller.currentIndex.value == 1? 'History' : 'Settings',
                  ),
                ),
              ),
              body: Navigator(
                key: Get.nestedKey(1),
                initialRoute: '/home',
                onGenerateRoute: controller.onGenerateRoute,
              ),
              bottomNavigationBar: GNav(
                  tabBorderRadius: 15,
                  duration: Duration(milliseconds: 400),
                  gap: 4,
                  iconSize: 24,
                  backgroundColor: AppColors.black,
                  tabBackgroundColor: Color(0xffB4A2F4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  tabMargin: EdgeInsets.all(8),
                  color: Colors.grey,
                  activeColor: Colors.black,
                  textStyle: AppTextTheme.textStyleDMSanse12W400(
                    color: Colors.black
                  ),
                  selectedIndex: controller.currentIndex.value,
                  onTabChange: controller.changePage,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.history,
                      text: 'History',
                    ),
                    GButton(
                      icon: Icons.keyboard,
                      text: 'Settings',
                    )
                  ]
              ),
              // bottomNavigationBar: Obx(
              //   () => BottomNavigationBar(
              //     showUnselectedLabels: false,
              //     enableFeedback: false,
              //     items: const <BottomNavigationBarItem>[
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.home),
              //         label: 'Home',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.history),
              //         label: 'History',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.settings),
              //         label: 'Settings',
              //       ),
              //     ],
              //     currentIndex: controller.currentIndex.value,
              //     selectedItemColor: Colors.pink,
              //     onTap: controller.changePage,
              //   ),
              // ),
            ),
          );
        });
  }
}
