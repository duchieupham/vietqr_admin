import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/top_up_phone/top_up_phone_screen.dart';

import '../../commons/constants/configurations/theme.dart';
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
    return Column(
      children: [
        Consumer<MenuProvider>(builder: (context, provider, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              color: AppColor.BLUE_TEXT.withOpacity(0.2),
            ),
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                const Text(
                  'VNPT Epay',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemMenuTop(
                        title: 'Số dư',
                        isSelect:
                            provider.initPage == SubMenuType.SURPLUS.pageNumber,
                        onTap: () {
                          provider.selectSubMenu(SubMenuType.SURPLUS);
                          // provider.updateShowMenuLink(false);
                        },
                      ),
                      ItemMenuTop(
                        title: 'Giao dịch nạp tiền ĐT',
                        isSelect: provider.initPage ==
                            SubMenuType.TOP_UP_PHONE.pageNumber,
                        onTap: () {
                          // DialogWidget.instance.openMsgDialog(
                          //     title: 'Bảo trì',
                          //     msg:
                          //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');

                          provider.selectSubMenu(SubMenuType.TOP_UP_PHONE);
                        },
                      ),
                      const SizedBox(
                        width: 80,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        Expanded(
          child: Consumer<MenuProvider>(
            builder: (context, provider, child) {
              return pages[provider.initPage];
            },
          ),
        ),
      ],
    );
  }
}
