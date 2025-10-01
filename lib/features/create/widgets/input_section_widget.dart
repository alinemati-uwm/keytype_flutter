import 'package:keytype/features/create/create_controller.dart';
import '../../../ui_imports.dart';
import '../../../core/helper/utils.dart';

class InputSectionWidget extends StatelessWidget {
  const InputSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Text',
          style: AppTextTheme.textStyleDMSanse18W700(),
        ),
        Gap(12),
        Text(
          'Enter the text you want to process',
          style: AppTextTheme.textStyleDMSanse14W400(
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        Gap(16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.grey,
                AppColors.grey.withOpacity(0.8),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller.textController,
            onTapOutside: (event) => Utils.closeKeyboard(),
            maxLines: 6,
            style: AppTextTheme.textStyleDMSanse14W400(
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Type or paste your text here...\n\nTip: The more specific your input, the better the AI results will be!',
              hintStyle: AppTextTheme.textStyleDMSanse14W400(
                color: AppColors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ),
        Gap(12),
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.amber,
              size: 16,
            ),
            Gap(8),
            Expanded(
              child: Text(
                'Pro tip: Be clear and specific for best results',
                style: AppTextTheme.textStyleDMSanse12W400(
                  color: Colors.amber.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}