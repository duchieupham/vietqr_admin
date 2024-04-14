import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuLeft extends StatelessWidget {
  const MenuLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          if (provider.showMenu)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Menu',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            )
          else
            const SizedBox(
              height: 20,
            ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: provider.showMenu
                ? _buildListItem(
                    context,
                    provider,
                    () {
                      provider.selectSubMenu(SubMenuType.OTHER);
                    },
                    (type) {
                      provider.selectMenu(type);
                    },
                  )
                : _buildListItemIcon(
                    provider,
                    () {
                      provider.selectSubMenu(SubMenuType.OTHER);
                    },
                    (type) {
                      provider.updateShowMenu(true);
                      provider.selectMenu(type);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildListItem(BuildContext context, MenuProvider provider,
      Function closeMenuLink, Function(MenuType) onTab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenu(
                title: 'VNPT Epay',
                isSelect: provider.menuHomeType == MenuType.VNPT_EPAY,
                onTap: () {
                  onTab(MenuType.VNPT_EPAY);
                },
              ),
              ItemMenu(
                title: 'Danh sách đại lý',
                isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
                onTap: () {
                  onTab(MenuType.SERVICE_CONNECT);
                },
              ),
              ItemMenu(
                title: 'Tích hợp và kết nối',
                isSelect:
                    provider.menuHomeType == MenuType.INTEGRATION_CONNECTIVITY,
                onTap: () {
                  onTab(MenuType.INTEGRATION_CONNECTIVITY);
                },
              ),
              ItemMenu(
                title: 'Cài đặt và thiết lập',
                isSelect: provider.menuHomeType == MenuType.SERVICE_PACK,
                onTap: () {
                  onTab(MenuType.SERVICE_PACK);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Phí dịch vụ',
                isSelect: provider.menuHomeType == MenuType.SERVICE_FEE,
                onTap: () {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Bảo trì',
                      msg:
                          'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                  // onTab(MenuType.SERVICE_FEE);
                  // closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Giao dịch',
                isSelect: provider.menuHomeType == MenuType.TRANSACTION,
                onTap: () {
                  // DialogWidget.instance.openMsgDialog(
                  //     title: 'Bảo trì',
                  //     msg:
                  //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                  onTab(MenuType.TRANSACTION);
                  // closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Giao dịch đại lý',
                isSelect: provider.menuHomeType == MenuType.MERCHANT_FEE,
                onTap: () {
                  // DialogWidget.instance.openMsgDialog(
                  //     title: 'Bảo trì',
                  //     msg:
                  //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                  onTab(MenuType.MERCHANT_FEE);
                  // closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Cấu hình',
                isSelect: provider.menuHomeType == MenuType.CONFIG,
                onTap: () {
                  onTab(MenuType.CONFIG);
                },
              ),
              ItemMenu(
                title: 'Tài khoản ngân hàng',
                isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
                iconData: Icons.payment_outlined,
                onTap: () {
                  onTab(MenuType.ACCOUNT_BANK);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Người dùng',
                isSelect: provider.menuHomeType == MenuType.USER,
                onTap: () {
                  onTab(MenuType.USER);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Bảng tin',
                isSelect: provider.menuHomeType == MenuType.POST,
                onTap: () {
                  onTab(MenuType.POST);
                  closeMenuLink();
                },
              ),
            ],
          ),
        ),
        ItemMenu(
          title: 'Đăng xuất',
          isLogout: true,
          isSelect: provider.menuHomeType == MenuType.LOGOUT,
          onTap: () {
            UserInformationHelper.instance.setAdminId('');
            context.go('/login');
            onTab(MenuType.LOGOUT);
          },
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8, top: 4),
          child: Text(
            'version web 1.0.1',
            style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
        )
      ],
    );
  }

  Widget _buildListItemIcon(
      MenuProvider provider, Function closeMenuLink, Function(MenuType) onTab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemMenu(
          title: 'VNPT Epay',
          isOnlyIcon: true,
          iconData: Icons.e_mobiledata,
          isSelect: provider.menuHomeType == MenuType.VNPT_EPAY,
          onTap: () {
            onTab(MenuType.VNPT_EPAY);
          },
        ),
        ItemMenu(
          title: 'Merchant',
          isOnlyIcon: true,
          iconData: Icons.home_repair_service_outlined,
          isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
          onTap: () {
            onTab(MenuType.SERVICE_CONNECT);
          },
        ),
        ItemMenu(
          title: 'Giao dịch',
          isOnlyIcon: true,
          iconData: Icons.currency_exchange,
          isSelect: provider.menuHomeType == MenuType.TRANSACTION,
          onTap: () {
            // DialogWidget.instance.openMsgDialog(
            //     title: 'Bảo trì',
            //     msg:
            //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
            onTab(MenuType.TRANSACTION);
            // closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Log',
          isSelect: provider.menuHomeType == MenuType.LOG,
          isOnlyIcon: true,
          iconData: Icons.report_gmailerrorred,
          onTap: () {
            onTab(MenuType.LOG);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Thiết lập bảng giá',
          isSelect: provider.menuHomeType == MenuType.SERVICE_PACK,
          isOnlyIcon: true,
          iconData: Icons.settings_applications_outlined,
          onTap: () {
            onTab(MenuType.SERVICE_PACK);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Cấu hình',
          isSelect: provider.menuHomeType == MenuType.CONFIG,
          isOnlyIcon: true,
          iconData: Icons.settings_suggest_sharp,
          onTap: () {
            onTab(MenuType.CONFIG);
          },
        ),
        ItemMenu(
          title: 'Tài khoản ngân hàng',
          isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
          isOnlyIcon: true,
          iconData: Icons.payment_outlined,
          onTap: () {
            onTab(MenuType.ACCOUNT_BANK);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Người dùng',
          isSelect: provider.menuHomeType == MenuType.USER,
          isOnlyIcon: true,
          iconData: Icons.supervised_user_circle_outlined,
          onTap: () {
            onTab(MenuType.USER);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Thông báo đẩy',
          isSelect: provider.menuHomeType == MenuType.PUSH_NOTIFICATION,
          isOnlyIcon: true,
          iconData: Icons.notifications_active_outlined,
          onTap: () {
            onTab(MenuType.PUSH_NOTIFICATION);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Bài Post',
          isSelect: provider.menuHomeType == MenuType.POST,
          isOnlyIcon: true,
          iconData: Icons.post_add,
          onTap: () {
            onTab(MenuType.POST);
            closeMenuLink();
          },
        ),
      ],
    );
  }
}
