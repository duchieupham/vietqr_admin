import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import '../../feature/surplus/epay_screen.dart';

// ignore: constant_identifier_names
enum VasType { VNPT_EPAY }

//Dịch vụ GTGT
class VasScreen extends StatefulWidget {
  final VasType type;

  const VasScreen({super.key, required this.type});

  @override
  State<VasScreen> createState() => _VasScreenState();
}

class _VasScreenState extends State<VasScreen> {
  VasType type = VasType.VNPT_EPAY;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FrameViewWidget(
        title: const SizedBox(),
        menu: MenuLeft(
          currentType: MenuType.VAS,
          subMenuVas: [
            ItemDropDownMenu(
              title: 'VNPT Epay',
              isSelect: type == VasType.VNPT_EPAY,
              onTap: () => onTapMenu(VasType.VNPT_EPAY),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(VasType value) {
    if (value == VasType.VNPT_EPAY) {
      html.window.history.pushState(null, '/vas', '/vnpt-epay');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == VasType.VNPT_EPAY) {
      return const EPayScreen();
    }
    return const SizedBox();
  }
}
