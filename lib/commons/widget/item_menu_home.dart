import 'dart:async';

import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class ItemMenuHome extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool isSelect, isLogout, enableDropDownList, enableMenuCard, isFirst;
  final String? pathImage;
  final List<Widget> listItemDrop;
  final bool isDropDownItem;
  final double titleSize;
  final bool isOnlyIcon, isDefaultColor;
  final EdgeInsets paddingIcon;
  final bool bold;

  const ItemMenuHome(
      {super.key,
      required this.title,
      required this.onTap,
      this.pathImage,
      this.isSelect = false,
      this.isLogout = false,
      this.enableDropDownList = false,
      this.listItemDrop = const [],
      this.isDropDownItem = false,
      this.titleSize = 12,
      this.enableMenuCard = false,
      this.isOnlyIcon = false,
      this.isDefaultColor = false,
      this.isFirst = false,
      this.bold = false,
      this.paddingIcon = EdgeInsets.zero});

  @override
  State<ItemMenuHome> createState() => _ItemMenuHomeState();
}

class _ItemMenuHomeState extends State<ItemMenuHome>
    with TickerProviderStateMixin {
  // double heightItem = 0;
  ValueNotifier<double> heightItem = ValueNotifier<double>(45.0);
  bool openListDropDown = true;
  bool amIHovering = false;
  bool openMenuCard = true;
  Offset exitFrom = const Offset(0, 0);
  bool isOpen = false;
  late AnimationController _controller;

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

  double getHeightDropDownList() {
    if (openListDropDown) {
      return widget.listItemDrop.length * heightItem.value;
    }
    return 0;
  }

  getBgItem() {
    if (widget.isSelect) {
      return AppColor.BLUE_BGR;
    } else if (amIHovering) {
      return AppColor.GREY_BUTTON;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        if (widget.listItemDrop.isNotEmpty) {
          isOpen = true;
        }
      });
    });
  }

  // void toggleDropDown() {
  //   setState(() {
  //     isOpen = !isOpen;
  //     isOpen ? _controller.forward() : _controller.reverse();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onTap();
            setState(() {
              isOpen = !isOpen;
            });
            isOpen ? _controller.forward() : _controller.reverse();
            // if (widget.enableDropDownList) toggleDropDown();
          },
          child: Container(
            height: 45,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isSelect
                  ? AppColor.BLUE_TEXT.withOpacity(0.1)
                  : AppColor.TRANSPARENT,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.isLogout)
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: widget.titleSize,
                          color: Colors.red,
                          fontWeight: widget.bold ? FontWeight.bold : null,
                        ),
                      )
                    else
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: widget.titleSize,
                          color: AppColor.BLACK,
                          fontWeight: widget.bold ? FontWeight.bold : null,
                        ),
                      ),
                  ],
                ),
                if (widget.enableDropDownList)
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => RotationTransition(
                            turns: child.key == const ValueKey('icon1')
                                ? Tween<double>(begin: 1, end: 0.5)
                                    .animate(anim)
                                : Tween<double>(begin: 0.5, end: 1)
                                    .animate(anim),
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                      child: isOpen
                          ? const Icon(Icons.keyboard_arrow_down_rounded,
                              key: ValueKey('icon1'))
                          : const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              key: ValueKey('icon2'),
                            )),
                // Transform.rotate(
                //   angle: isOpen ? math.pi : 0,
                //   child: const Icon(Icons.keyboard_arrow_down),
                // ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isOpen ? widget.listItemDrop.length * heightItem.value : 0,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.only(left: 40, right: 40, top: 4),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: widget.listItemDrop,
          ),
        ),
      ],
    );
  }
}
