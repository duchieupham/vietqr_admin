import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../feature/dashboard/provider/menu_provider.dart';
import '../constants/configurations/theme.dart';

class TableWidget extends StatefulWidget {
  final Widget columnWidget;
  final Widget expandedTable;
  final bool hasData;
  final Widget header;
  const TableWidget(
      {super.key,
      required this.header,
      required this.columnWidget,
      required this.hasData,
      required this.expandedTable});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    double widthTable = 1652;
    double withEmpty = 0;
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        double width = MediaQuery.of(context).size.width;
        if (value.showMenu) {
          width = width - 220;
        } else {
          width = width - 50;
        }

        withEmpty = width - widthTable;
        return SizedBox(
          height: 600,
          // width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.header,
              widget.hasData
                  ? Row(
                      children: [
                        widget.columnWidget,
                        Expanded(child: widget.expandedTable),
                      ],
                    )
                  : Expanded(
                      child: Container(
                        width: 1400,
                        color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        child: const Center(
                          child: Text(
                            'Trống',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
