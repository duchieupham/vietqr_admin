import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_left.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_link.dart';
import 'package:vietqr_admin/feature/list_connect/list_connect_screen.dart';

import 'frames/dashboard_frame.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashBroadScreenState();
}

class _DashBroadScreenState extends State<DashboardScreen> {
  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    pages = [
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      ListConnectScreen(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
    ];
  }

  handleOnTabMenu(MenuType type, MenuProvider provider) {
    switch (type) {
      case MenuType.SERVICE_CONNECT:
        bool showMenuLink = provider.showMenuLink;
        provider.updateShowMenuLink(!showMenuLink);
        break;
      case MenuType.LOGOUT:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MenuProvider(),
        child: Consumer<MenuProvider>(builder: (context, provider, child) {
          return DashboardFrame(
            page: pages[provider.initPage],
            menu: MenuLeft(
              menuProvider: provider,
              onTab: (type) {
                handleOnTabMenu(type, provider);
              },
            ),
            menuLink: MenuLink(
              onTab: (subMenuType) {},
              menuProvider: provider,
            ),
          );
        }),
      ),
    );
  }
}
