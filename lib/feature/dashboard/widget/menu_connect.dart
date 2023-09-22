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
          height: 45,
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
          child: _buildListItem(),
        )
      ],
    );
  }

  Widget _buildListItem() {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemMenu(
              title: 'Danh sách kết nối',
              isSelect:
                  provider.initPage == SubMenuType.LIST_CONNECT.pageNumber,
              onTap: () {
                provider.selectSubMenu(SubMenuType.LIST_CONNECT);
                // provider.updateShowMenuLink(false);
              },
            ),
            ItemMenu(
              title: 'Kết nối mới',
              isSelect: provider.initPage == SubMenuType.NEW_CONNECT.pageNumber,
              onTap: () {
                provider.selectSubMenu(SubMenuType.NEW_CONNECT);
                // provider.updateShowMenuLink(false);
              },
            ),
            ItemMenu(
              title: 'Chạy callback',
              isSelect:
                  provider.initPage == SubMenuType.RUN_CALLBACK.pageNumber,
              onTap: () {
                provider.selectSubMenu(SubMenuType.RUN_CALLBACK);
                // provider.updateShowMenuLink(false);
              },
            ),
          ],
        );
      },
    );
  }
}
