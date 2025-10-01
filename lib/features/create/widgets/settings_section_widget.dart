import 'package:keytype/features/create/create_controller.dart';
import '../../../ui_imports.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextTheme.textStyleDMSanse18W700(),
        ),
        Gap(16),
        Row(
          children: [
            Expanded(child: _buildToneSelector(controller)),
            Gap(12),
            Expanded(child: _buildFormalitySelector(controller)),
          ],
        ),
      ],
    );
  }

  Widget _buildToneSelector(CreateController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tone',
          style: AppTextTheme.textStyleDMSanse14W700(),
        ),
        Gap(8),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ToneType>(
                value: controller.selectedTone.value,
                isExpanded: true,
                dropdownColor: AppColors.grey,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.white),
                style: AppTextTheme.textStyleDMSanse14W400(color: AppColors.white),
                items: ToneType.values.map((tone) {
                  return DropdownMenuItem<ToneType>(
                    value: tone,
                    child: Text(controller.getToneDisplayName(tone)),
                  );
                }).toList(),
                onChanged: (ToneType? value) {
                  if (value != null) {
                    controller.selectTone(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormalitySelector(CreateController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formality',
          style: AppTextTheme.textStyleDMSanse14W700(),
        ),
        Gap(8),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<FormalityType>(
                value: controller.selectedFormality.value,
                isExpanded: true,
                dropdownColor: AppColors.grey,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.white),
                style: AppTextTheme.textStyleDMSanse14W400(color: AppColors.white),
                items: FormalityType.values.map((formality) {
                  return DropdownMenuItem<FormalityType>(
                    value: formality,
                    child: Text(controller.getFormalityDisplayName(formality)),
                  );
                }).toList(),
                onChanged: (FormalityType? value) {
                  if (value != null) {
                    controller.selectFormality(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}