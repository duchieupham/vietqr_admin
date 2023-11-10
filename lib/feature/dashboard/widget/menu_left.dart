import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
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
                title: 'Merchant',
                isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
                onTap: () {
                  onTab(MenuType.SERVICE_CONNECT);
                },
              ),
              ItemMenu(
                title: 'Giao dịch',
                isSelect: provider.menuHomeType == MenuType.TRANSACTION,
                onTap: () {
                  onTab(MenuType.TRANSACTION);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Log',
                isSelect: provider.menuHomeType == MenuType.LOG,
                onTap: () {
                  onTab(MenuType.LOG);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Thiết lập bảng giá',
                isSelect: provider.menuHomeType == MenuType.SERVICE_PACK,
                onTap: () {
                  onTab(MenuType.SERVICE_PACK);
                  closeMenuLink();
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
                title: 'Người dùng',
                isSelect: provider.menuHomeType == MenuType.USER,
                onTap: () {
                  onTab(MenuType.USER);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Tài khoản ngân hàng',
                isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
                onTap: () {
                  onTab(MenuType.ACCOUNT_BANK);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Thông báo đẩy',
                isSelect: provider.menuHomeType == MenuType.PUSH_NOTIFICATION,
                onTap: () {
                  onTab(MenuType.PUSH_NOTIFICATION);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Bài Post',
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
            onTab(MenuType.TRANSACTION);
            closeMenuLink();
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
