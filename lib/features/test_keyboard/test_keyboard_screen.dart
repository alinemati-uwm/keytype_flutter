

import '../../ui_imports.dart';

class TestKeyboardScreen extends StatelessWidget {
  const TestKeyboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
        title: Text('Test KeyboardAI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                minLines: 1,
                maxLines: 999,
                decoration: InputDecoration.collapsed(
                    hintText: 'Type here'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
