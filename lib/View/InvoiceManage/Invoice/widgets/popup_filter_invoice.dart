import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/bank_system_screen.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';

class PopupFilterInvoice extends StatefulWidget {
  final int choiceChipSelected;
  final Function(int) onSelectChips;
  final Function(int) onSelectTime;

  const PopupFilterInvoice(
      {super.key,
      required this.onSelectChips,
      required this.onSelectTime,
      required this.choiceChipSelected});

  @override
  State<PopupFilterInvoice> createState() => _PopupFilterInvoiceState();
}

class _PopupFilterInvoiceState extends State<PopupFilterInvoice> {
  late InvoiceViewModel _model;
  List<ChoiceChipItem> listChoiceChips = [
    ChoiceChipItem(title: 'Tất cả', value: 9),
    ChoiceChipItem(title: 'Phí kích hoạt DV', value: 0),
    ChoiceChipItem(title: 'Phí GD', value: 1),
    ChoiceChipItem(title: 'Nạp tiền ĐT', value: 2),
  ];

  int _choiceChipSelected = 9;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _choiceChipSelected = widget.choiceChipSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loại hóa đơn",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4.0,
              children: List<Widget>.generate(
                4,
                (int index) {
                  return ChoiceChip(
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    selectedColor: Colors.transparent,
                    side: const BorderSide(color: Colors.transparent),
                    backgroundColor: Colors.transparent,
                    showCheckmark: false,
                    label: Container(
                      decoration: BoxDecoration(
                        gradient:
                            _choiceChipSelected == listChoiceChips[index].value
                                ? VietQRTheme.gradientColor.brightBlueLinear
                                : null,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          _choiceChipSelected == listChoiceChips[index].value
                              ? Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.check,
                                    color: AppColor.BLUE_TEXT,
                                    size: 15,
                                  )),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            listChoiceChips[index].title,
                            style: TextStyle(
                              color: _choiceChipSelected ==
                                      listChoiceChips[index].value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    selected:
                        _choiceChipSelected == listChoiceChips[index].value,
                    onSelected: (bool selected) {
                      setState(() {
                        _choiceChipSelected =
                            (selected ? listChoiceChips[index].value : null)!;
                      });
                      widget.onSelectChips(_choiceChipSelected);
                    },
                  );
                },
              ).toList(),
            ),
          ],
        ),
        ScopedModel<InvoiceViewModel>(
            model: _model,
            child: ScopedModelDescendant<InvoiceViewModel>(
              builder: (context, child, model) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Thời gian",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      // width: 120,
                      child: Row(
                        children: model.listFilterTime
                            .map(
                              (e) => _buildButton(
                                  isSelect: model.valueFilterTime.id == e.id,
                                  filter: e),
                            )
                            .toList(),
                      ),
                    )
                  ],
                );
              },
            ))
      ],
    );
  }

  Widget _buildButton({
    required bool isSelect,
    required DataFilter filter,
  }) {
    return InkWell(
      onTap: () async {
        _model.updateFilterTime(filter);
        _model.selectDateTime(_model.getMonth());
        widget.onSelectTime(_choiceChipSelected);
        // await _model.filterListInvoice(
        //   invoiceType: _choiceChipSelected,
        //   size: pageSize,
        //   page: 1,
        //   filterType: filterSelect.type,
        //   search: textEditingController.text,
        // );
      },
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: isSelect
                  ? VietQRTheme.gradientColor.brightBlueLinear
                  : VietQRTheme.gradientColor.disableButtonLinear,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              height: 20,
              width: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isSelect
                      ? VietQRTheme.gradientColor.brightBlueLinear
                      : VietQRTheme.gradientColor.disableButtonLinear,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            filter.name,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
