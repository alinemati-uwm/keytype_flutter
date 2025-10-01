import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/components/custom_cache_network_image.dart';

import '../core/helper/utils.dart';
import '../ui_imports.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            )
          ]),
          child: InkResponse(
            radius: 15,
            onTap: () {
              if (BaseBrain.userModel.value.email == null) {
                return;
              }
              Get.toNamed(Routes.profile);
            },
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                child: BaseBrain.userModel.value.profileImage == null
                    ? Center(child: Text(Utils.nameOfUser))
                    : CustomCacheNetworkImage(
                        radius: 60,
                        url: BaseBrain.userModel.value.profileImage ?? '')

                // Container(
                //     height: 120,
                //     width: 120,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: AppColors.grey),
                //     child: BaseBrain.userModel.value.profileImage == null
                //         ? Center(child: Text(nameOfUser()))
                //         : CustomCacheNetworkImage(
                //         radius: 60,
                //         url: BaseBrain.userModel.value.profileImage ??'')),
                ),
          ),
        ));
  }
}
