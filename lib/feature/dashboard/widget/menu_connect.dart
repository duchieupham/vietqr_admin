import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuConnect extends StatelessWidget {
  const MenuConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Dịch vụ kết nối API',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(
          child: _buildListItem(
            context.read<MenuProvider>(),
            () {
              context.read<MenuProvider>().updateShowMenuLink(false);
            },
          ),
        )
      ],
    );
  }

  Widget _buildListItem(MenuProvider provider, Function closeMenuLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemMenu(
          title: 'Danh sách kết nối',
          isSelect: provider.subMenuType == SubMenuType.LIST_CONNECT,
          onTap: () {
            provider.selectSubMenu(SubMenuType.LIST_CONNECT);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Kết nối mới',
          isSelect: provider.subMenuType == SubMenuType.NEW_CONNECT,
          onTap: () {
            provider.selectSubMenu(SubMenuType.NEW_CONNECT);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Chạy callback',
          isSelect: provider.subMenuType == SubMenuType.RUN_CALLBACK,
          onTap: () {
            provider.selectSubMenu(SubMenuType.RUN_CALLBACK);
            closeMenuLink();
          },
        ),
      ],
    );
  }
}
