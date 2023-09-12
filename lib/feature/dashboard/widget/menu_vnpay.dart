import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuEPay extends StatelessWidget {
  const MenuEPay({super.key});

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
            'VNPT Epay',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(child: _buildListItem())
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
              title: 'Số dư',
              isSelect: provider.initPage == SubMenuType.SURPLUS.pageNumber,
              onTap: () {
                provider.selectSubMenu(SubMenuType.SURPLUS);
                // provider.updateShowMenuLink(false);
              },
            ),
          ],
        );
      },
    );
  }
}
