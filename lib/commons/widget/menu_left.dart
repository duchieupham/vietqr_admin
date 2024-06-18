import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import 'item_menu_home.dart';

class MenuLeft extends StatelessWidget {
  final MenuType currentType;
  final List<Widget> subMenuVas;
  final List<Widget> subMenuMerchantManage;
  final List<Widget> subMenuTransManage;
  final List<Widget> subMenuTransStatistics;
  final List<Widget> subMenuTransFee;
  final List<Widget> subMenuInvoice;
  final List<Widget> subMenuQrBox;
  final List<Widget> subMenuSys;

  final List<Widget> subMenuSetting;

  const MenuLeft({
    super.key,
    required this.currentType,
    this.subMenuVas = const [],
    this.subMenuMerchantManage = const [],
    this.subMenuTransManage = const [],
    this.subMenuTransStatistics = const [],
    this.subMenuTransFee = const [],
    this.subMenuInvoice = const [],
    this.subMenuQrBox = const [],
    this.subMenuSetting = const [],
    this.subMenuSys = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColor.BLUE_BGR,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 40),
        Expanded(
          child: _buildListItem(context),
        )
      ]),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenuHome(
                title: 'Dịch vụ GTGT',
                enableDropDownList: true,
                listItemDrop: subMenuVas,
                isSelect: currentType == MenuType.VAS,
                bold: true,
                onTap: () {
                  context.go('/vnpt-epay');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý hệ thống',
                enableDropDownList: true,
                listItemDrop: subMenuSys,
                isSelect: currentType == MenuType.SYS_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/system-user');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý đại lý',
                enableDropDownList: true,
                listItemDrop: subMenuMerchantManage,
                isSelect: currentType == MenuType.MERCHANT_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/merchant-list');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý giao dịch',
                enableDropDownList: true,
                listItemDrop: subMenuTransManage,
                isSelect: currentType == MenuType.TRANS_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/sys-trans');
                },
              ),
              ItemMenuHome(
                title: 'Thống kê giao dịch',
                enableDropDownList: true,
                listItemDrop: subMenuTransStatistics,
                isSelect: currentType == MenuType.TRANS_STATISTICS,
                bold: true,
                onTap: () {
                  context.go('/sys-trans-statistics');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý thu phí',
                enableDropDownList: true,
                listItemDrop: subMenuTransFee,
                isSelect: currentType == MenuType.TRANS_FEE,
                bold: true,
                onTap: () {
                  context.go('/trans-fee');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý hóa đơn',
                enableDropDownList: true,
                listItemDrop: subMenuInvoice,
                isSelect: currentType == MenuType.INVOICE,
                bold: true,
                onTap: () {
                  context.go('/invoice-list');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý QR Box',
                enableDropDownList: true,
                listItemDrop: subMenuQrBox,
                isSelect: currentType == MenuType.QR_BOX,
                bold: true,
                onTap: () {
                  context.go('/qr-box');
                },
              ),
              ItemMenuHome(
                title: 'Thiết lập và cài đặt',
                enableDropDownList: true,
                listItemDrop: subMenuSetting,
                isSelect: currentType == MenuType.SETTING,
                bold: true,
                onTap: () {
                  context.go('/setting-fee');
                },
              ),
            ],
          ),
        ),
        ItemMenuHome(
          title: 'Đăng xuất',
          isLogout: true,
          // isSelect: currentType == MenuType.LOG_OUT,
          bold: true,
          onTap: () {
            UserInformationHelper.instance.setAdminId('');
            context.go('/login');
          },
        ),
      ],
    );
  }

  // Widget _buildListItem(BuildContext context, MenuProvider provider,
  //     Function closeMenuLink, Function(MenuType) onTab) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: ListView(
  //           padding: EdgeInsets.zero,
  //           children: [
  //             ItemMenu(
  //               title: 'VNPT Epay',
  //               isSelect: provider.menuHomeType == MenuType.VNPT_EPAY,
  //               onTap: () {
  //                 onTab(MenuType.VNPT_EPAY);
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Danh sách đại lý',
  //               isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
  //               onTap: () {
  //                 onTab(MenuType.SERVICE_CONNECT);
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Tích hợp và kết nối',
  //               isSelect:
  //                   provider.menuHomeType == MenuType.INTEGRATION_CONNECTIVITY,
  //               onTap: () {
  //                 onTab(MenuType.INTEGRATION_CONNECTIVITY);
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Cài đặt và thiết lập',
  //               isSelect: provider.menuHomeType == MenuType.SERVICE_PACK,
  //               onTap: () {
  //                 onTab(MenuType.SERVICE_PACK);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Cài đặt môi trường',
  //               isSelect: provider.menuHomeType == MenuType.ENVIRONMENT_SETTING,
  //               onTap: () {
  //                 onTab(MenuType.ENVIRONMENT_SETTING);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Phí dịch vụ',
  //               isSelect: provider.menuHomeType == MenuType.SERVICE_FEE,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.SERVICE_FEE);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Phí thường niên',
  //               isSelect: provider.menuHomeType == MenuType.ANNUAL_FEE_AFTER,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.ANNUAL_FEE_AFTER);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Giao dịch VQR',
  //               isSelect: provider.menuHomeType == MenuType.USER_RECHARGE,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.USER_RECHARGE);
  //                 // closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Giao dịch',
  //               isSelect: provider.menuHomeType == MenuType.TRANSACTION,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.TRANSACTION);
  //                 // closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Giao dịch đại lý',
  //               isSelect: provider.menuHomeType == MenuType.MERCHANT_FEE,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.MERCHANT_FEE);
  //                 // closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Giao dịch hệ thống',
  //               isSelect: provider.menuHomeType == MenuType.SYSTEM_TRANSACTION,
  //               onTap: () {
  //                 // DialogWidget.instance.openMsgDialog(
  //                 //     title: 'Bảo trì',
  //                 //     msg:
  //                 //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
  //                 onTab(MenuType.SYSTEM_TRANSACTION);
  //                 // closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Cấu hình',
  //               isSelect: provider.menuHomeType == MenuType.CONFIG,
  //               onTap: () {
  //                 onTab(MenuType.CONFIG);
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Tài khoản ngân hàng',
  //               isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
  //               iconData: Icons.payment_outlined,
  //               onTap: () {
  //                 onTab(MenuType.ACCOUNT_BANK);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Người dùng',
  //               isSelect: provider.menuHomeType == MenuType.USER,
  //               onTap: () {
  //                 onTab(MenuType.USER);
  //                 closeMenuLink();
  //               },
  //             ),
  //             ItemMenu(
  //               title: 'Bảng tin',
  //               isSelect: provider.menuHomeType == MenuType.POST,
  //               onTap: () {
  //                 onTab(MenuType.POST);
  //                 closeMenuLink();
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //       ItemMenu(
  //         title: 'Đăng xuất',
  //         isLogout: true,
  //         isSelect: provider.menuHomeType == MenuType.LOGOUT,
  //         onTap: () {
  //           UserInformationHelper.instance.setAdminId('');
  //           context.go('/login');
  //           onTab(MenuType.LOGOUT);
  //         },
  //       ),
  //       const Padding(
  //         padding: EdgeInsets.only(left: 16, bottom: 8, top: 4),
  //         child: Text(
  //           'version web 1.0.1',
  //           style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
