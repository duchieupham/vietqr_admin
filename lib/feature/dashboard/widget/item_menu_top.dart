import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class ItemMenuTop extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool isSelect;
  final double titleSize;
  const ItemMenuTop({
    Key? key,
    required this.title,
    required this.onTap,
    this.isSelect = false,
    this.titleSize = 14,
  }) : super(key: key);

  @override
  State<ItemMenuTop> createState() => _ItemMenuHomeState();
}

class _ItemMenuHomeState extends State<ItemMenuTop> {
  double heightItem = 45;
  bool openListDropDown = false;
  bool amIHovering = false;
  bool openMenuCard = true;
  Offset exitFrom = const Offset(0, 0);

  onOpenDropDownList() {
    if (openListDropDown) {
      setState(() {
        openListDropDown = !openListDropDown;
      });
    } else {
      setState(() {
        openListDropDown = true;
      });
    }
  }

  getBgItem() {
    if (widget.isSelect) {
      return Colors.transparent;
    } else if (amIHovering) {
      return AppColor.GREY_BUTTON.withOpacity(0.5);
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
        child: Container(
          height: heightItem,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: getBgItem(),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: widget.titleSize,
                color: widget.isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
