import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/text_field_custom.dart';
import 'package:vietqr_admin/commons/widget/textfield_widget.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';

class DropdownWidget extends StatelessWidget {
  final List<DataFilter> list;
  final DataFilter filter;
  final Function(DataFilter?) callBack;
  final String? title;

  const DropdownWidget({
    super.key,
    required this.list,
    required this.filter,
    required this.callBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
              color: AppColor.GREY_TEXT.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<DataFilter>(
              isExpanded: true,
              selectedItemBuilder: (context) {
                return list.map(
                  (item) {
                    return DropdownMenuItem<DataFilter>(
                      value: item,
                      alignment: AlignmentDirectional.topStart,
                      child: MTextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        enable: false,
                        fillColor: AppColor.WHITE,
                        value: item.name,
                        title: '',
                        styles: const TextStyle(fontSize: 10),
                        textFieldType: TextfieldType.DEFAULT,
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        hintText: '',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {},
                      ),
                    );
                  },
                ).toList();
              },
              items: list.map((item) {
                return DropdownMenuItem<DataFilter>(
                  value: item,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              value: filter,
              onChanged: (value) {
                callBack.call(value);
              },
              buttonStyleData: ButtonStyleData(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 18,
                iconEnabledColor: AppColor.BLACK,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
