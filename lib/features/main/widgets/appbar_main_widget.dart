

import 'package:keytype/components/profile_widget.dart';

import '../../../ui_imports.dart';
import 'keyboard_setup_widget.dart';

class AppbarMainWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarMainWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
      title: Text(title),
      actions: [
        // if(kDebugMode)
        //   IconButton(onPressed: () {
        //     Get.to(()=> DeveloperScreen());
        //   }, icon: Icon(Icons.developer_mode)),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.upgrade);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: radius12
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              foregroundColor: Colors.white),
          child: Row(
            children: [
              Icon(Icons.diamond_outlined,
                color: AppColors.white,),
              Gap(6),
              Text('Upgrade'),
            ],
          ),
        ),
        Gap( 10),
        ProfileWidget(),
        Gap(10),
      ],
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: KeyboardSetupWidget(),),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
