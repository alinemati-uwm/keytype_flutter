import 'dart:math';
import 'package:keytype/features/create/create_controller.dart';
import '../../../ui_imports.dart';

class ResultsSectionWidget extends StatefulWidget {
  const ResultsSectionWidget({super.key});

  @override
  State<ResultsSectionWidget> createState() => _ResultsSectionWidgetState();
}

class _ResultsSectionWidgetState extends State<ResultsSectionWidget>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    
    return Obx(
      () => controller.taskResults.isNotEmpty || controller.isLoading.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Results',
                  style: AppTextTheme.textStyleDMSanse18W700(),
                ),
                Gap(12),
                Text(
                  'Tap any result to copy to clipboard',
                  style: AppTextTheme.textStyleDMSanse14W400(
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ),
                Gap(16),
                if (controller.isLoading.value) ...[
                  _buildShimmerPlaceholders(),
                ] else ...[
                  _buildResults(controller),
                ],
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildShimmerPlaceholders() {
    return Column(
      children: List.generate(5, (index) => 
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildShimmerCard(index),
        ),
      ),
    );
  }

  Widget _buildShimmerCard(int index) {
    final gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFFf5576c)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
      [Color(0xFF43e97b), Color(0xFF38f9d7)],
      [Color(0xFFfa709a), Color(0xFFfee140)],
    ];

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: gradients[index % gradients.length],
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradients[index % gradients.length],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextTheme.textStyleDMSanse14W700(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Gap(8),
                    Text(
                      'Generating...',
                      style: AppTextTheme.textStyleDMSanse14W700(),
                    ),
                    Spacer(),
                    _buildAnimatedDots(),
                  ],
                ),
                Gap(12),
                _buildShimmerLines(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDots() {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (_shimmerController.value + delay) % 1.0;
            final opacity = (sin(animationValue * pi * 2) + 1) / 2;
            
            return Padding(
              padding: EdgeInsets.only(left: index > 0 ? 4 : 0),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity * 0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildShimmerLines() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Column(
          children: List.generate(3, (index) {
            final width = index == 2 ? 0.7 : 1.0;
            final shimmerPosition = _shimmerAnimation.value;
            
            return Padding(
              padding: EdgeInsets.only(bottom: index < 2 ? 8 : 0),
              child: Container(
                height: 12,
                width: double.infinity * width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + shimmerPosition, 0.0),
                    end: Alignment(-0.5 + shimmerPosition, 0.0),
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildResults(CreateController controller) {
    final gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFFf5576c)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
      [Color(0xFF43e97b), Color(0xFF38f9d7)],
      [Color(0xFFfa709a), Color(0xFFfee140)],
    ];

    return Column(
      children: List.generate(controller.taskResults.length, (index) {
        final result = controller.taskResults[index];
        
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: InkWell(
              onTap: () => controller.copyResult(result.content),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: gradients[index % gradients.length],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradients[index % gradients.length],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTextTheme.textStyleDMSanse14W700(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Gap(8),
                          Text(
                            'Option ${index + 1}',
                            style: AppTextTheme.textStyleDMSanse14W700(),
                          ),
                          Spacer(),
                          Icon(
                            Icons.copy,
                            color: AppColors.white.withOpacity(0.7),
                            size: 16,
                          ),
                        ],
                      ),
                      Gap(12),
                      Text(
                        result.content,
                        style: AppTextTheme.textStyleDMSanse14W400(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}