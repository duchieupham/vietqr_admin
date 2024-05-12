import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class ItemDropDownMenu extends StatefulWidget {
  final String title;
  final Function onTap;

  final List<Widget> listItemDrop;
  final double titleSize;
  final bool isSelect;

  const ItemDropDownMenu({
    super.key,
    required this.title,
    required this.onTap,
    this.listItemDrop = const [],
    this.titleSize = 12,
    this.isSelect = false,
  });

  @override
  State<ItemDropDownMenu> createState() => _ItemDropDownMenuState();
}

class _ItemDropDownMenuState extends State<ItemDropDownMenu> {
  double heightItem = 40;
  bool isSelectItem = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        if (widget.isSelect) {
          setState(() {
            isSelectItem = !isSelectItem;
          });
        }
      },
      child: Container(
        height: heightItem,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 15, right: 10),
        decoration: BoxDecoration(
          color: widget.isSelect
              ? AppColor.BLUE_CARD.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: widget.titleSize,
            // color: widget.isSelect
            //     ? AppColor.BLUE_TEXT
            //     : AppColor.BLACK,
            color: AppColor.BLACK,
          ),
        ),
      ),
    );
  }
}
