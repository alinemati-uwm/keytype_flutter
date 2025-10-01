import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keytype/components/custom_loading.dart';
import 'package:keytype/components/custom_text_widget.dart';
import 'package:keytype/utils/screen_functions.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:readmore/readmore.dart';
import '../../core/helper/utils.dart';
import '../../ui_imports.dart';
import 'ask_ai_controller.dart';

class AskAiScreen extends GetView<AskAiController> {
  const AskAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.black,
              titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
              title: Text('Ask AI'),
              actions: [
                IconButton(
                    onPressed: () {
                      controller.newChat();
                    },
                    icon: CustomImage(url: 'assets/icons/ic-new-chat.svg'))
              ],
            ),
            body: Column(
              children: [
                Expanded(child: Obx(
                  () {
                    if (controller.isLoadingHistory.value) {
                      return CustomLoading();
                    }
                    return controller.listMessages.isEmpty
                        ? _buildEmptyList(context)
                        : Align(
                            alignment: Alignment.topCenter,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                      top: 12, bottom: 50) +
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shrinkWrap: true,
                              controller: controller.scrollController,
                              itemCount: controller.listMessages.length,
                              itemBuilder: (context, index) {
                                final data = controller.listMessages[index];
                                final isUser = data.role == 'user';
                                final isLoading =
                                    (data.content?.isEmpty ?? true);
                                return FadeIn(
                                  child: Align(
                                    alignment: isUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: ScreenUtils.getScreenWidth(
                                                  context) *
                                              0.8),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 12),
                                            decoration: BoxDecoration(
                                                color: isUser
                                                    ? AppColors.primaryDefault
                                                    : AppColors.grey,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft: Radius.circular(
                                                      isUser ? 16 : 0),
                                                  bottomRight: Radius.circular(
                                                      isUser ? 0 : 16),
                                                )),
                                            child: (isLoading && !isUser)
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SpinKitDualRing(
                                                        size: 25,
                                                        lineWidth: 4,
                                                        color: AppColors.white,
                                                      ),
                                                    ],
                                                  )
                                                : _buildTextMessage(
                                                    isUser: isUser,
                                                    data: data.content ?? ''),
                                          ),
                                          Gap(6),
                                          Visibility(
                                            visible: !isUser && !isLoading,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      ScreenUtils.getScreenWidth(
                                                                  context) *
                                                              0.8 -
                                                          16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  _buildIcons(
                                                    onPress: () async {
                                                      Utils.copyText(
                                                          data.content ?? '');
                                                    },
                                                    icon:
                                                        'assets/icons/ic_copy.svg',
                                                  ),
                                                  Gap(16),
                                                  _buildIcons(
                                                    onPress: () async {
                                                      Utils.shareText(
                                                          data.content ?? '');
                                                    },
                                                    icon:
                                                        'assets/icons/ic_share.svg',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 12,
                                );
                              },
                            ),
                          );
                  },
                )),
                ChatInputField(
                  controller: controller.textEditController,
                  onSend: () {
                    controller.sendMessage();
                  },
                  onMic: () {},
                ),
              ],
            ),
          );
        });
  }

  _buildEmptyList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(
          url: 'assets/images/logo-new.png',
          size: ScreenUtils.getScreenWidth(context) * 0.28,
        ),
        Gap(12),
        Text(
          'Nemati AI is here!',
          style: AppTextTheme.textStyleDMSanse24W700(),
        ),
        Gap(12),
        Text('Try out a new AI experience-fast, smart, and efficient')
      ],
    );
  }

  _buildIcons(
      {required VoidCallback onPress,
      required String icon,
      Color? color,
      double? iconSize}) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPress,
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
      ),
      icon: SvgPicture.asset(
        icon,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      ),
      iconSize: iconSize,
    );
  }

  _buildTextMessage({required bool isUser, required String data}) {
    if (isUser) {
      return ReadMoreText(
        data.trim(),
        trimMode: TrimMode.Line,
        trimLines: 3,
        lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        trimCollapsedText: ' Show more',
        trimExpandedText: ' Show less',
        moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }
    return MarkdownBlock(
        data: data,
        config: MarkdownConfig.darkConfig.copy(configs: [
          PreConfig.darkConfig.copy(
            wrapper: (child, code, language) {
              return Stack(
                children: [
                  child,
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon:
                          const Icon(Icons.copy, size: 18, color: Colors.white),
                      onPressed: () {
                        Utils.copyText(code);
                      },
                    ),
                  ),
                ],
              );
            },
          )
        ]));
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;

  ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMic,
  });

  final aiController = Get.find<AskAiController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Obx(
            () {
              if (aiController.promptModel.value.prompt == null) {
                return SizedBox.shrink();
              }
              return Container(
                decoration: BoxDecoration(
                    borderRadius: radius12, color: AppColors.dark),
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomTextWidget(
                      aiController.promptModel.value.topic ?? '',
                      style: AppTextTheme.textStyleDMSanse14W400(),
                    )),
                    IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        iconSize: 18,
                        onPressed: () {
                          aiController.editPrompt();
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        iconSize: 18,
                        onPressed: () {
                          aiController.deletePrompt();
                        },
                        icon: Icon(Icons.delete_forever))
                  ],
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 3,
                          onTapOutside: (event) {
                            Utils.closeKeyboard();
                          },
                          controller: controller,
                          onChanged: aiController.onChange,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type your message here",
                            hintStyle: AppTextTheme.textStyleDMSanse14W400(),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: onMic,
                      //   child: Icon(
                      //     CupertinoIcons.mic,
                      //     color: Color(0xFFB388FF),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => GestureDetector(
                  onTap: onSend,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: aiController.hasMessage.value ||
                              aiController.isGenerated.value
                          ? AppColors.primaryDefault
                          : const Color(0xFF888888),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      aiController.isGenerated.value
                          ? Icons.stop
                          : Icons.arrow_upward,
                      color: aiController.hasMessage.value ||
                              aiController.isGenerated.value
                          ? AppColors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
