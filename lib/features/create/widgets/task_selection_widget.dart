import 'package:keytype/features/create/create_controller.dart';
import '../../../ui_imports.dart';

class TaskSelectionWidget extends StatelessWidget {
  const TaskSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Task',
          style: AppTextTheme.textStyleDMSanse18W700(),
        ),
        Gap(12),
        Text(
          'Select what you want to do with your text',
          style: AppTextTheme.textStyleDMSanse14W400(
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        Gap(16),
        Obx(
          () {
            // Force rebuild by accessing the observable
            final selected = controller.selectedTask.value;
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: controller.taskOptions.length,
              itemBuilder: (context, index) {
                final task = controller.taskOptions[index];
                final isSelected = selected.type == task.type;
              
              return AnimatedContainer(
                duration: controller.animationDuration,
                child: InkWell(
                  onTap: () => controller.selectTask(task),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedScale(
                    scale: isSelected ? 1.02 : 1.0,
                    duration: controller.animationDuration,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: isSelected
                            ? LinearGradient(
                                colors: task.gradientColors,
                              )
                            : null,
                        color: isSelected ? null : AppColors.grey,
                        border: isSelected
                            ? null
                            : Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: task.gradientColors.first.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                  spreadRadius: 2,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task.icon,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              AnimatedRotation(
                                turns: isSelected ? 0.125 : 0,
                                duration: controller.animationDuration,
                                child: Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: AppTextTheme.textStyleDMSanse14W700(
                                  color: isSelected ? Colors.white : AppColors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(4),
                              Text(
                                task.description,
                                style: AppTextTheme.textStyleDMSanse12W400(
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.9)
                                      : AppColors.white.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          },
        ),
      ],
    );
  }
}