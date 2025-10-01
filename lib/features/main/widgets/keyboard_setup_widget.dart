

import 'package:keytype/features/main/main_controller.dart';

import '../../../ui_imports.dart';

class KeyboardSetupWidget extends StatelessWidget {
  const KeyboardSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.white,
                width: 1.1
              ),
              borderRadius: radius12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('keyboard status', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 5),
                    Text('Need setup',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.find<MainController>().setUpKeyboard();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xff988547),
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: radius10
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8
                    )
                  ),
                  child: Text('set up keyboard'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text('How set up keyboard?',
              style: TextStyle(color: Colors.white,
                decoration: TextDecoration.underline,)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
