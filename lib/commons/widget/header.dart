import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColor.WHITE,
      width: width,
      child: Row(
        children: [
          Image.asset(
            AppImages.icVietQrAdmin,
            height: 40,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(width: 120),
          Consumer<MenuProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text('Môi trường'),
                    const SizedBox(width: 24),
                    InkWell(
                      onTap: () {
                        int initPage =
                            Provider.of<MenuProvider>(context, listen: false)
                                .initPage;

                        EnvConfig.instance.updateEnv(EnvType.DEV);
                        provider.updateENV(0);

                        if (initPage == SubMenuType.LIST_CONNECT.pageNumber) {
                          eventBus.fire(GetListConnect());
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: provider.environment == 0
                              ? AppColor.BLUE_TEXT.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Test',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.environment == 0
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        int initPage =
                            Provider.of<MenuProvider>(context, listen: false)
                                .initPage;
                        MenuType type =
                            Provider.of<MenuProvider>(context, listen: false)
                                .menuHomeType;

                        if (initPage == SubMenuType.RUN_CALLBACK.pageNumber) {
                          EnvConfig.instance.updateEnv(EnvType.DEV);
                          provider.updateENV(0);
                          await DialogWidget.instance.openMsgDialog(
                              title: 'Thông báo',
                              msg: 'Chức năng ko khả dụng cho môi trường Live');
                          return;
                        }
                        EnvConfig.instance.updateEnv(EnvType.GOLIVE);
                        provider.updateENV(1);
                        if (type == MenuType.SERVICE_CONNECT) {
                          if (initPage == SubMenuType.LIST_CONNECT.pageNumber) {
                            eventBus.fire(GetListConnect());
                          }
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: provider.environment == 1
                              ? AppColor.BLUE_TEXT.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'GoLive',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.environment == 1
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
