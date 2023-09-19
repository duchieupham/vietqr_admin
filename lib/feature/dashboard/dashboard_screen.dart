import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/feature/connect_service/service_screen.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_connect.dart';
import 'package:vietqr_admin/feature/dashboard/widget/menu_left.dart';
import 'package:vietqr_admin/feature/log/log_screen.dart';
import 'package:vietqr_admin/feature/surplus/epay_screen.dart';

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
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const MenuEPay(),
    ];

    pages = [
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const ServiceScreen(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const LogScreen(),
      const EPayScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MenuProvider(),
        child: Consumer<MenuProvider>(
          builder: (context, provider, child) {
            return DashboardFrame(
              page: pages[provider.initMenuPage],
              menu: const MenuLeft(),
              menuLink: menus[provider.initMenuPage],
            );
          },
        ),
      ),
    );
  }
}
