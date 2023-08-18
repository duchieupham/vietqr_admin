import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class ItemMenu extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool isSelect, isLogout;
  final String? pathImage;
  final List<Widget> listItemDrop;
  final bool isDropDownItem;
  final double titleSize;

  const ItemMenu({
    Key? key,
    required this.title,
    required this.onTap,
    this.pathImage,
    this.isSelect = false,
    this.isLogout = false,
    this.listItemDrop = const [],
    this.isDropDownItem = false,
    this.titleSize = 13,
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
      return DefaultTheme.BLUE_TEXT.withOpacity(0.2);
    } else if (amIHovering) {
      return DefaultTheme.BLUE_TEXT.withOpacity(0.1);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
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
                          fontSize: widget.titleSize,
                          color: DefaultTheme.RED_TEXT),
                    )
                  else
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.titleSize,
                          color: widget.isSelect
                              ? DefaultTheme.BLUE_TEXT
                              : DefaultTheme.BLACK),
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
