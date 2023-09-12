import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/header.dart';
import 'package:vietqr_admin/commons/widget/web_mobile_blank_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

class DashboardFrame extends StatelessWidget {
  final Widget page;
  final Widget menu;
  final Widget menuLink;

  const DashboardFrame(
      {Key? key,
      required this.page,
      required this.menu,
      required this.menuLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: (PlatformUtils.instance.resizeWhen(width, 600))
          ? Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      const Header(),
                      Expanded(
                        child: Row(
                          children: [
                            Consumer<MenuProvider>(
                              builder: (context, provider, child) {
                                double width = 0;

                                if (provider.showMenuLink) {
                                  width = 440;
                                } else {
                                  width = 220;
                                }
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  width: width,
                                  child: SizedBox(
                                    height: height,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        BoxLayout(
                                          width: 220,
                                          height: height,
                                          borderRadius: 0,
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.centerLeft,
                                          bgColor: AppColor.BLUE_TEXT
                                              .withOpacity(0.3),
                                          child: menu,
                                        ),
                                        Container(
                                          width: 220,
                                          height: height,
                                          decoration: BoxDecoration(
                                            color: AppColor.BLUE_TEXT
                                                .withOpacity(0.2),
                                          ),
                                          padding: EdgeInsets.zero,
                                          child: menuLink,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Expanded(child: page),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : const WebMobileBlankWidget(),
    );
  }
}