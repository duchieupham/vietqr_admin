import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

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
    pages = [const SurplusScreen()];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: AppColor.BLUE_TEXT.withOpacity(0.2),
          height: 40,
          width: width,
        ),
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
