import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/active_fee_screen.dart';
import 'package:vietqr_admin/feature/connect_service/annual_fee/annual_fee_screen.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

import 'list_connect/list_connect_screen.dart';
import 'new_connect/new_connect_screen.dart';
import 'run_callback/run_callback_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const ListConnectScreen(),
      const NewConnectScreen(),
      const RunCallBackScreen(),
      const ActiveFeeScreen(),
      const AnnualFeeScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<MenuProvider>(
          builder: (context, provider, child) {
            return Expanded(
              child: pages[provider.initPage],
            );
          },
        ),
      ],
    );
  }
}
