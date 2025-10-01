import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:keytype/features/intro/controller/intro_controller.dart';
import 'package:keytype/utils/screen_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../ui_imports.dart';
import '../../../components/custom_button.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  IntroController get controller => Get.find<IntroController>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialAnimation();
  }

  void _initializeAnimations() {
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutQuart,
    ));
  }

  void _startInitialAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });
  }

  void _onPageChanged(int index) {
    controller.changePage(index);
    _textAnimationController.reset();
    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final screenWidth = ScreenUtils.getScreenWidth(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            PageView.builder(
              controller: controller.pageController,
              itemCount: 2,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Top spacing
                      SizedBox(height: screenHeight * 0.08),

                      // Image section
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: double.infinity,
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            tween: Tween(begin: 0.8, end: 1.0),
                            curve: Curves.elasticOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: CustomImage(
                                  url: index == 0
                                      ? 'assets/images/img-keyboard-2.png'
                                      : 'assets/images/img-keyboard-3.png',
                                  size: screenWidth * 0.8,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Animated text section
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _textAnimationController,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: AnimatedTextKit(
                                        repeatForever: true,
                                        isRepeatingAnimation: true,
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                              index == 0
                                                  ? 'Write Any Message\nin a Tap'
                                                  : 'Improve\nYour Message',
                                              textAlign: TextAlign.center,
                                              textStyle: AppTextTheme
                                                      .textStyleDMSanse24W700()
                                                  .copyWith(
                                                height: 1.3,
                                                letterSpacing: 0.5,
                                              ),
                                              speed:
                                                  Duration(milliseconds: 150),
                                              curve: Curves.linear)
                                        ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Bottom spacing for navigation area
                      SizedBox(height: screenHeight * 0.12),
                    ],
                  ),
                );
              },
            ),

            // Bottom navigation area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.16,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Page indicator
                    SmoothPageIndicator(
                      controller: controller.pageController,
                      count: 2,
                      effect: WormEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.white.withOpacity(0.3),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Navigation buttons
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Previous/Skip button
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: controller.currentPage.value == 0
                                  ? TextButton(
                                      key: const ValueKey('skip'),
                                      onPressed: () =>
                                          Get.toNamed(Routes.login),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                      child: const Text(
                                        'Skip',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      key: const ValueKey('previous'),
                                      onPressed: () {
                                        controller.pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                      child: const Text(
                                        'Previous',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                            ),

                            // Next/Complete button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: CustomButton(
                                width: screenWidth * 0.3,
                                onTap: () {
                                  if (controller.currentPage.value == 1) {
                                    Get.toNamed(Routes.login);
                                    return;
                                  }
                                  controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                text: controller.currentPage.value == 1
                                    ? 'Get Started'
                                    : 'Next',
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
