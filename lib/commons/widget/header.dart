import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: DefaultTheme.WHITE,
      width: width,
      child: Row(
        children: [
          Image.asset(
            AppImages.icVietQrAdmin,
            height: 40,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            width: 120,
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: DefaultTheme.GREY_BUTTON,
                borderRadius: BorderRadius.circular(5)),
            child: const Text(
              'Tìm kiếm người dùng',
              style: TextStyle(fontSize: 11),
            ),
          ),
          const Spacer(),
          Text(
            UserInformationHelper.instance.getAccountInformation().name,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            width: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppImages.icAvatarDefault,
              width: 30,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
