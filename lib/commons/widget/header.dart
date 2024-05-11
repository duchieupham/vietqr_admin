import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/View/EnvironmentSetting/widgets/environment_setting_screen.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

import '../constants/enum/type_menu_home.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColor.BLUE_BGR,
      width: width,
      child: Row(
        children: [
          Tooltip(
            message: 'Menu',
            child: Consumer<MenuProvider>(
              builder: (context, provider, child) {
                return InkWell(
                  onTap: () {
                    provider.updateShowMenu(!provider.showMenu);
                  },
                  child: BoxLayout(
                    width: 40,
                    height: 40,
                    borderRadius: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    bgColor: AppColor.WHITE,
                    border: Border.all(color: AppColor.BLACK, width: 1),
                    child: Icon(
                      Icons.menu_rounded,
                      size: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            height: 40,
            width: 100,
            child: Image.asset(
              AppImages.icVietQrAdmin,
              height: 40,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(width: 120),
          // Consumer<MenuProvider>(
          //   builder: (context, provider, child) {
          //     return SizedBox(
          //       height: 40,
          //       child: Row(
          //         children: [
          //           const SizedBox(width: 20),
          //           const Text('Môi trường'),
          //           const SizedBox(width: 24),
          //           InkWell(
          //             onTap: () {
          //               int initPage =
          //                   Provider.of<MenuProvider>(context, listen: false)
          //                       .initPage;
          //               MenuType menuType =
          //                   Provider.of<MenuProvider>(context, listen: false)
          //                       .menuHomeType;

          //               EnvConfig.instance.updateEnv(EnvType.DEV);
          //               provider.updateENV(0);

          //               if (menuType == MenuType.VNPT_EPAY) {
          //                 if (initPage == SubMenuType.TOP_UP_PHONE.pageNumber) {
          //                   eventBus.fire(RefreshTransactionVNPTPage());
          //                 }
          //               }

          //               if (initPage == SubMenuType.LIST_CONNECT.pageNumber) {
          //                 eventBus.fire(GetListConnect());
          //               }
          //               if (initPage == SubMenuType.ANNUAL_FEE.pageNumber) {
          //                 eventBus.fire(RefreshListAnnualFee());
          //               }

          //               if (initPage == 0) {
          //                 eventBus.fire(RefreshListActiveFee());
          //               }

          //               if (menuType == MenuType.LOG) {
          //                 eventBus.fire(RefreshLog(envGoLive: false));
          //                 eventBus.fire(ResetDateLog());
          //               }
          //               if (menuType == MenuType.TRANSACTION) {
          //                 eventBus.fire(RefreshTransaction());
          //               }
          //               if (menuType == MenuType.SERVICE_PACK) {
          //                 eventBus.fire(RefreshServicePackList());
          //               }
          //             },
          //             child: Container(
          //               height: 30,
          //               width: 100,
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 color: provider.environment == 0
          //                     ? AppColor.BLUE_TEXT.withOpacity(0.1)
          //                     : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(5),
          //               ),
          //               child: Text(
          //                 'Test',
          //                 style: TextStyle(
          //                     fontSize: 12,
          //                     color: provider.environment == 0
          //                         ? AppColor.BLUE_TEXT
          //                         : AppColor.BLACK),
          //               ),
          //             ),
          //           ),
          //           InkWell(
          //             onTap: () async {
          //               int initPage =
          //                   Provider.of<MenuProvider>(context, listen: false)
          //                       .initPage;
          //               MenuType type =
          //                   Provider.of<MenuProvider>(context, listen: false)
          //                       .menuHomeType;

          //               if (initPage == SubMenuType.RUN_CALLBACK.pageNumber) {
          //                 EnvConfig.instance.updateEnv(EnvType.DEV);
          //                 provider.updateENV(0);
          //                 await DialogWidget.instance.openMsgDialog(
          //                     title: 'Thông báo',
          //                     msg: 'Chức năng ko khả dụng cho môi trường Live');
          //                 return;
          //               }
          //               EnvConfig.instance.updateEnv(EnvType.GOLIVE);
          //               provider.updateENV(1);
          //               if (type == MenuType.SERVICE_CONNECT) {
          //                 if (initPage == SubMenuType.LIST_CONNECT.pageNumber) {
          //                   eventBus.fire(GetListConnect());
          //                 }
          //                 if (initPage == SubMenuType.ANNUAL_FEE.pageNumber) {
          //                   eventBus.fire(RefreshListAnnualFee());
          //                 }
          //                 if (initPage == 0) {
          //                   eventBus.fire(RefreshListActiveFee());
          //                 }
          //               }
          //               if (type == MenuType.VNPT_EPAY) {
          //                 if (initPage == SubMenuType.TOP_UP_PHONE.pageNumber) {
          //                   eventBus.fire(RefreshTransactionVNPTPage());
          //                 }
          //               }

          //               if (type == MenuType.TRANSACTION) {
          //                 eventBus.fire(RefreshTransaction());
          //               }
          //               if (type == MenuType.LOG) {
          //                 eventBus.fire(RefreshLog(envGoLive: true));
          //                 // eventBus.fire(ResetDateLog());
          //               }
          //               if (type == MenuType.SERVICE_PACK) {
          //                 eventBus.fire(RefreshServicePackList());
          //               }
          //             },
          //             child: Container(
          //               height: 30,
          //               width: 100,
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 color: provider.environment == 1
          //                     ? AppColor.BLUE_TEXT.withOpacity(0.1)
          //                     : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(5),
          //               ),
          //               child: Text(
          //                 'GoLive',
          //                 style: TextStyle(
          //                     fontSize: 12,
          //                     color: provider.environment == 1
          //                         ? AppColor.BLUE_TEXT
          //                         : AppColor.BLACK),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          const Spacer(),
          SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Môi trường', style: TextStyle(fontSize: 10)),
                Consumer<MenuProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      provider.environment == 0 ? 'Test' : 'Live',
                      style: const TextStyle(
                          color: AppColor.BLUE_TEXT,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Tooltip(
            message: 'Cài đặt môi trường',
            child: Consumer<MenuProvider>(
              builder: (context, provider, child) {
                return InkWell(
                  onTap: () {
                    // provider.selectMenu(MenuType.ENVIRONMENT_SETTING);
                  },
                  child: BoxLayout(
                    width: 40,
                    height: 40,
                    borderRadius: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    bgColor: AppColor.WHITE,
                    border: Border.all(color: AppColor.BLACK, width: 1),
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppImages.icAvatarDefault,
              width: 40,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
