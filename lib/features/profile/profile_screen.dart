import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/features/profile/profile_controller.dart';
import 'package:keytype/components/custom_button.dart';
import 'package:keytype/components/custom_cache_network_image.dart';
import 'package:keytype/components/custom_loading.dart';
import '../../core/helper/utils.dart';
import '../../ui_imports.dart';
import '../../components/full_screen_image.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (logic) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.black,
              titleTextStyle: AppTextTheme.textStyleDMSanse24W700(),
              title: Text('Profile'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildProfileImage()),
                  Gap(0),
                  Text(
                    'Your Information',
                    style: AppTextTheme.textStyleDMSanse20W700(),
                  ),
                  _buildTextField(
                      controller: TextEditingController(
                          text: BaseBrain.userModel.value.username),
                      title: 'Username',
                      readOnly: true),
                  _buildTextField(
                      controller: TextEditingController(
                          text: BaseBrain.userModel.value.email),
                      title: 'Email',
                      readOnly: true),
                  Divider(),
                  _buildTextField(
                      controller: controller.cntFirstName,
                      title: 'First Name',
                      hint: 'enter your first name'),
                  _buildTextField(
                      controller: controller.cntLastName,
                      title: 'Last Name',
                      hint: 'enter your last name'),
                  Gap(10),
                  Obx(
                    () => CustomButton(
                      onTap: () {
                        controller.callApiUpdateInfo();
                      },
                      isLoading: controller.isLoadingUpdateInfo.value,
                      text: 'Edit Information',
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _buildProfileImage() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 1),
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            )
          ]),
      child: Obx(
        () {
          if (controller.isLoadingUploadImage.value) {
            return CustomLoading();
          }
          return Stack(
            children: [
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    if (BaseBrain.userModel.value.profileImage == null) return;
                    Navigator.push(
                        Get.context!,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            return FullScreenImage(
                              imageUrl:
                                  BaseBrain.userModel.value.profileImage ?? '',
                            );
                          },
                        ));
                  },
                  child: BaseBrain.userModel.value.profileImage == null
                      ? Center(child: Text(Utils.nameOfUser))
                      : CustomCacheNetworkImage(
                          url: BaseBrain.userModel.value.profileImage ?? '',
                          radius: 60,
                        ),
                ),
              ),
              Positioned(
                  bottom: 3,
                  right: 3,
                  child: InkResponse(
                    onTap: () {
                      controller.uploadImage();
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: AppColors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.3),
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(
                            url: 'assets/icons/basil_edit-outline.svg',
                            color: Colors.white,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  _buildTextField({
    required TextEditingController controller,
    String hint = '',
    required String title,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(title),
        SizedBox(
          height: 45,
          child: TextField(
            readOnly: readOnly,
            controller: controller,
            style: TextStyle(color: Colors.white), // رنگ نوشته
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xff222831),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
