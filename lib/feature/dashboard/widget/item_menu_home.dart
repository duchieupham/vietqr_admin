import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class ItemMenu extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool isSelect, isLogout;
  final String? pathImage;
  final bool isOnlyIcon;
  final IconData? iconData;
  final double titleSize;

  const ItemMenu({
    Key? key,
    required this.title,
    required this.onTap,
    this.pathImage,
    this.isSelect = false,
    this.isLogout = false,
    this.titleSize = 13,
    this.isOnlyIcon = false,
    this.iconData,
  }) : super(key: key);

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  double heightItem = 40;
  bool amIHovering = false;
  bool openMenuLink = true;
  Offset exitFrom = const Offset(0, 0);

  getBgItem() {
    if (widget.isSelect) {
      return AppColor.BLUE_TEXT.withOpacity(0.2);
    } else if (amIHovering) {
      return AppColor.BLUE_TEXT.withOpacity(0.1);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnlyIcon) {
      return InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Tooltip(
          message: widget.title,
          child: Container(
              color: widget.isSelect
                  ? AppColor.ITEM_MENU_SELECTED
                  : Colors.transparent,
              width: 50,
              height: 46,
              child: Icon(
                widget.iconData,
                size: 20,
                color: widget.isSelect
                    ? AppColor.BLUE_TEXT
                    : AppColor.BLACK.withOpacity(0.6),
              )),
        ),
      );
    }
    return MouseRegion(
      onEnter: (PointerEvent details) => setState(() => amIHovering = true),
      onExit: (PointerEvent details) => setState(() {
        amIHovering = false;
        exitFrom = details.localPosition;
      }),
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: heightItem,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: getBgItem(),
              child: Row(
                children: [
                  if (widget.isLogout)
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize, color: AppColor.RED_TEXT),
                    )
                  else
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize,
                          color: widget.isSelect
                              ? AppColor.BLUE_TEXT
                              : AppColor.BLACK),
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
