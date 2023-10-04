import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/top_up_phone/top_up_phone_screen.dart';

import 'surplus_screen.dart';

class EPayScreen extends StatefulWidget {
  const EPayScreen({super.key});

  @override
  State<EPayScreen> createState() => _EPayScreenState();
}

class _EPayScreenState extends State<EPayScreen> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [const SurplusScreen(), const TopUpPhoneScreen()];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return pages[provider.initPage];
      },
    );
  }
}
