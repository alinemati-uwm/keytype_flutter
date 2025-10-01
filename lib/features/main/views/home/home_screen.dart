import '../../../../ui_imports.dart';
import '../../../../components/modals/coming_soon_modal.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: radius14,
                      onTap: () {
                        ComingSoonModal.show(
                          context: context,
                          featureName: 'Ask AI',
                          description: 'Get instant AI-powered assistance for all your writing needs. Chat with our intelligent assistant to improve your content!',
                          icon: Icons.smart_toy,
                          primaryColor: const Color(0xff874EE9),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 6 / 10,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: radius14,
                              gradient: LinearGradient(
                                colors: [Color(0xff874EE9), Color(0xff6427BB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                  'assets/images/img-home_robot.png',
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ask AI',
                                        style: AppTextTheme
                                            .textStyleDMSanse20W700(),
                                      ),
                                      Gap(8),
                                      Text(
                                          'Lorem ipsum dolor \nsitamet consectetur.')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 13,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.create);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: radius14,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff6234E6),
                                    Color(0xff3F1BA0)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    right: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Create',
                                          style: AppTextTheme
                                              .textStyleDMSanse20W700(),
                                        ),
                                        Gap(8),
                                        Text('Lorem ipsum dolor')
                                      ],
                                    )),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CustomImage(
                                      url:
                                          'assets/images/img-home-create-write.png',
                                      size: 120,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
                      AspectRatio(
                        aspectRatio: 16 / 13,
                        child: InkWell(
                          onTap: () {
                            ComingSoonModal.show(
                              context: context,
                              featureName: 'Templates',
                              description: 'Choose from a variety of pre-built templates to kickstart your writing projects. Save time and get inspired!',
                              icon: Icons.description,
                              primaryColor: const Color(0xff6234E6),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: radius14,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff6234E6),
                                    Color(0xff4B3D89)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: 20,
                                    left: 10,
                                    right: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Templates',
                                          style: AppTextTheme
                                              .textStyleDMSanse20W700(),
                                        ),
                                        Gap(8),
                                        Text('Lorem ipsum dolor')
                                      ],
                                    )),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CustomImage(
                                      url:
                                          'assets/images/img-home-notebook.png',
                                      size: 100,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }

}
