import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MDropWidget<T> extends StatelessWidget {
  final List<T> list;
  final T filter;
  final ValueChanged<T?> callBack;
  final String? title;
  final BorderRadius? borderRadius;

  const MDropWidget({
    Key? key,
    required this.list,
    required this.filter,
    required this.callBack,
    this.title,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: borderRadius ?? BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              selectedItemBuilder: (context) {
                return list.map<Widget>(
                  (item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              items: list.map<DropdownMenuItem<T>>(
                (item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              value: filter,
              onChanged: callBack,
              buttonStyleData: ButtonStyleData(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 14,
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
