import 'package:keytype/features/create/create_controller.dart';
import 'package:keytype/features/create/widgets/task_selection_widget.dart';
import 'package:keytype/features/create/widgets/input_section_widget.dart';
import 'package:keytype/features/create/widgets/settings_section_widget.dart';
import 'package:keytype/features/create/widgets/results_section_widget.dart';
import '../../ui_imports.dart';

class CreateScreen extends GetView<CreateController> {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    Gap(24),
                    TaskSelectionWidget(),
                    Gap(24),
                    InputSectionWidget(),
                    Gap(20),
                    SettingsSectionWidget(),
                    Gap(24),
                    _buildGenerateButton(),
                    Gap(24),
                    ResultsSectionWidget(),
                    Gap(40), // Extra space at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_fix_high,
              color: Colors.white,
              size: 20,
            ),
          ),
          Gap(12),
          Text(
            'AI Writing Studio',
            style: AppTextTheme.textStyleDMSanse24W700(),
          ),
          Spacer(),
          Obx(
            () => controller.isGenerating.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF667eea),
                      ),
                    ),
                  )
                : Icon(
                    Icons.wb_incandescent_outlined,
                    color: AppColors.white.withOpacity(0.7),
                    size: 20,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea).withOpacity(0.1),
            Color(0xFF764ba2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF667eea).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🚀',
                style: TextStyle(fontSize: 24),
              ),
              Gap(8),
              Text(
                'Transform Your Writing',
                style: AppTextTheme.textStyleDMSanse20W700(),
              ),
            ],
          ),
          Gap(8),
          Text(
            'Choose from 7 powerful AI tools to enhance, rewrite, translate, and perfect your text with professional results.',
            style: AppTextTheme.textStyleDMSanse14W400(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.generateTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: controller.isLoading.value
                  ? LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade700],
                    )
                  : LinearGradient(
                      colors: controller.selectedTask.value.gradientColors,
                    ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              alignment: Alignment.center,
              child: controller.isLoading.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        Gap(12),
                        Text(
                          'Generating...',
                          style: AppTextTheme.textStyleDMSanse16W700(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.selectedTask.value.icon,
                          style: TextStyle(fontSize: 20),
                        ),
                        Gap(8),
                        Text(
                          'Generate Results',
                          style: AppTextTheme.textStyleDMSanse16W700(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
