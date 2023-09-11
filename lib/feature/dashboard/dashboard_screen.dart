import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/list_connect_screen.dart';
import 'package:vietqr_admin/feature/connect_service/service_screen.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_connect.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_left.dart';
import 'package:vietqr_admin/feature/new_connect/new_connect_screen.dart';
import 'package:vietqr_admin/feature/run_callback/run_callback_screen.dart';
import 'package:vietqr_admin/feature/surplus/surplus_screen.dart';

import 'frames/dashboard_frame.dart';
import 'widget/menu_vnpay.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashBroadScreenState();
}

class _DashBroadScreenState extends State<DashboardScreen> {
  List<Widget> pages = [];
  List<Widget> menus = [];

  @override
  void initState() {
    super.initState();
    menus = [
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const MenuConnect(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const MenuEPay(),
    ];

    pages = [
      const ListConnectScreen(),
      const NewConnectScreen(),
      const RunCallBackScreen(),
      const SurplusScreen(),
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
        child: Consumer<MenuProvider>(
          builder: (context, provider, child) {
            return DashboardFrame(
              page: ServiceScreen(
                page: pages[provider.initPage],
                isShowHeader: (provider.initPage != 0 ||
                    provider.initPage != 1 ||
                    provider.initPage != 2),
              ),
              menu: MenuLeft(
                menuProvider: provider,
                onTab: (type) {
                  bool showMenuLink = provider.showMenuLink;
                  provider.updateShowMenuLink(!showMenuLink);
                  provider.selectMenu(type);
                },
              ),
              menuLink: menus[provider.initMenuPage],
            );
          },
        ),
      ),
    );
  }
}
