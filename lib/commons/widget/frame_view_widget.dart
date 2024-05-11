import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/widget/header.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/platform_utils.dart';
import '../../../commons/widget/web_mobile_blank_widget.dart';

class FrameViewWidget extends StatelessWidget {
  final Widget title;
  final Widget menu;
  final Widget child;
  const FrameViewWidget({
    super.key,
    required this.title,
    required this.menu,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        width: width,
        height: height - 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.WHITE,
              AppColor.BLUE_LIGHT,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: (PlatformUtils.instance.resizeWhen(width, 650))
            ? Column(
                children: [
                  const Header(),
                  Expanded(
                    child: Row(
                      children: [
                        menu,
                        Expanded(child: child),
                      ],
                    ),
                  ),
                  // const FooterWeb(),
                ],
              )
            : const WebMobileBlankWidget(),
      ),
    );
  }
}
