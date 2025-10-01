import 'package:animate_do/animate_do.dart';
import 'package:keytype/features/templates/template_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../ui_imports.dart';
import '../../components/custom_button.dart';
import '../../components/custom_footer_widget.dart';
import '../../components/custom_shimmer.dart';

class TemplateScreen extends GetView<TemplateController> {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.black,
              titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
              title: Text('Templates'),
            ),
            body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    // _buildAppbar(context),
                    _buildCategorySection(context)
                  ];
                },
                body: _BuildBodyWidget()),
          );
        });
  }

  // _buildAppbar(BuildContext context) {
  //   return SliverAppBar(
  //       backgroundColor: Theme.of(context).appColors.bgLightB,
  //       surfaceTintColor: Theme.of(context).appColors.bgLightB,
  //       expandedHeight: 80,
  //       title: Align(
  //         alignment: AlignmentDirectional.centerEnd,
  //         child: InkWell(
  //           onTap: () async {
  //             final result =
  //             await Navigator.of(context).pushNamed(Screens.customPrompt);
  //             if (result != null) {
  //               if (context.mounted) {
  //                 final categoryId = (result as int);
  //                 context
  //                     .read<LibraryBloc>()
  //                     .add(ChangeCategoryEvent(categoryId: categoryId));
  //               }
  //             }
  //           },
  //           child: Container(
  //             width: 160,
  //             height: 36,
  //             padding: const EdgeInsets.symmetric(horizontal: 8),
  //             decoration: BoxDecoration(
  //                 color: AppColors.primaryDefault,
  //                 borderRadius: BorderRadius.circular(50)),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SvgPicture.asset(AssetIcons.customPrompt,
  //                     colorFilter: ColorFilter.mode(
  //                       AppColors.white,
  //                       BlendMode.srcIn,
  //                     )),
  //                 const Gap(6),
  //                 Text(
  //                   AppLocalizations.of(context)?.customPrompt ??
  //                       'Custom prompt',
  //                   style: AppTextTheme.textStyleDMSanse14W700(
  //                       color: AppColors.white),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       leading: RotatedBox(
  //         quarterTurns: context.read<ThemeCubit>().isRTL ? 2 : 4,
  //         child: buildIconButton(() {
  //           Scaffold.of(context).openDrawer();
  //         }, const IconInfo(iconPath: AssetIcons.menu, iconSize: Size(16, 16)),
  //             color: Theme.of(context).appColors.icon),
  //       ),
  //       floating: true,
  //       toolbarHeight: 80,
  //       bottom: const SearchSectionLibrary());
  // }

  _buildCategorySection(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.black,
      pinned: true,
      surfaceTintColor: AppColors.black,
      shadowColor: AppColors.white.withAlpha(50),
      expandedHeight: 40,
      automaticallyImplyLeading: false,
      title: SizedBox(
          height: 35,
          child: Obx(
            () {
              if (controller.isLoadingCategory.value) {
                return SingleChildScrollView(
                  key: const ValueKey(6),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      8,
                      (index) {
                        return const CustomShimmer(
                          width: 50,
                          height: 32,
                          radius: 15,
                          margin: EdgeInsets.only(right: 8),
                        );
                      },
                    ),
                  ),
                );
              }
              return FadeIn(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.listCategory.length,
                  itemBuilder: (context, index) {
                    final item = controller.listCategory[index];
                    final isSelected =
                        controller.selectedCategory.value == item.id;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          controller.changeCategory(categoryId: item.id ?? 0);
                        },
                        color: WidgetStateProperty.all(
                            isSelected ? Color(0xff9D8CFD) : AppColors.grey),
                        label: Text(
                          item.name ?? '',
                          style: AppTextTheme.textStyleDMSanse14W400(
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.white),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )),
    );
  }
}

class _BuildBodyWidget extends StatelessWidget {
  final controller = Get.find<TemplateController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoadingTemplates.value) {
          return _buildLoading;
        }
        if (controller.listTemplates.isEmpty) {
          return Column(
            children: [
              Text(
                'Not Found Data',
                style: AppTextTheme.textStyleDMSanse16W700(),
              )
            ],
          );
        }
        return Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SmartRefresher(
                controller: controller.refreshController,
                footer: const CustomFooterWidget(),
                onRefresh: () {
                  controller.changeCategory(
                      categoryId: controller.selectedCategory.value,
                  isRefresh: true);
                  controller.refreshController.refreshCompleted();
                },
                enablePullUp: true,
                onLoading: () {
                  controller.loadMoreData();
                },
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 185,
                      crossAxisSpacing: 12),
                  itemCount: controller.listTemplates.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = controller.listTemplates[index];
                    return FadeIn(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.topic ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.textStyleDMSanse14W700(),
                            ),
                            Text(
                              data.task ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.textStyleDMSanse14W400(),
                            ),
                            const Gap(6),
                            CustomButton(
                                color: AppColors.primaryDefault,
                                onTap: () {
                                  Get.toNamed(Routes.askAi,
                                      arguments: {'dataPrompt': data});
                                  // BottomSheetWidget().show(
                                  //     context,
                                  //     context.translate?.usePrompt ?? '',
                                  //     ListView.separated(
                                  //         shrinkWrap: true,
                                  //         physics:
                                  //         const NeverScrollableScrollPhysics(),
                                  //         itemBuilder: (context, index) {
                                  //           return ListTile(
                                  //             selectedColor: AppColors
                                  //                 .primaryDefault,
                                  //             onTap: () {
                                  //               handleOnTapUsePrompt(
                                  //                   context: context,
                                  //                   index: index,
                                  //                   item: data);
                                  //             },
                                  //             titleTextStyle: AppTextTheme
                                  //                 .textStyleDMSanse14W500(
                                  //                 color: Theme.of(
                                  //                     context)
                                  //                     .appColors
                                  //                     .textDefault),
                                  //             trailing: Icon(
                                  //               Icons
                                  //                   .arrow_forward_ios_rounded,
                                  //               size: 18,
                                  //               color: Theme.of(context)
                                  //                   .appColors
                                  //                   .textDefault,
                                  //             ),
                                  //             title: Text(
                                  //               nameUsePrompt(
                                  //                   index, context),
                                  //               style: AppTextTheme
                                  //                   .textStyleDMSanse14W700(),
                                  //             ),
                                  //           );
                                  //         },
                                  //         separatorBuilder: (context,
                                  //             index) =>
                                  //             Container(
                                  //               height: 0.5,
                                  //               color: Theme.of(context)
                                  //                   .appColors
                                  //                   .divider,
                                  //             ),
                                  //         itemCount: 3));
                                },
                                height: 34,
                                styleText: AppTextTheme.textStyleDMSanse16W400(
                                    color: AppColors.white),
                                text: 'Try')
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _buildLoading => FadeIn(
        child: GridView(
          key: UniqueKey(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              mainAxisExtent: 185,
              crossAxisSpacing: 12),
          children: List.generate(
            10,
            (index) => const CustomShimmer(
              enable: false,
            ),
          ),
        ),
      );
}
