import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/InvoiceCreate/widgets/popup_select_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button.dart';
import 'package:vietqr_admin/commons/widget/dialog_pick_month.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';

class FilterInvoiceWidget extends StatefulWidget {
  final TextEditingController controller;
  final int filterBy;
  final int pageSize;
  final Function(int) onCall;
  const FilterInvoiceWidget(
      {super.key,
      required this.controller,
      required this.filterBy,
      required this.onCall,
      required this.pageSize});

  @override
  State<FilterInvoiceWidget> createState() => _FilterInvoiceWidgetState();
}

class _FilterInvoiceWidgetState extends State<FilterInvoiceWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Container(
          margin: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Row(
            children: [
              const Text(
                'Tìm kiếm theo',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                width: 420,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.GREY_DADADA)),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: model.subMenuType,
                        underline: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: AppColor.WHITE,
                        elevation: 4,
                        icon: const RotatedBox(
                          quarterTurns: 5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                        items: widget.filterBy == 0
                            ? model.listMenuDropInvoice()
                            : model.listMenuDropMerchant(),
                        onChanged: (value) {
                          if (value != null) {
                            // widget.controller.text = '';
                            model.changeTypeInvoice(value);
                            widget.onCall(value);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 1,
                              color: AppColor.GREY_DADADA,
                            ),
                          ),
                          if (model.subMenuType == 3)
                            InkWell(
                              onTap: () async {
                                await model.getMerchant('', isGetList: true);
                                onSelectMerchant();
                              },
                              child: SizedBox(
                                width: 234,
                                // padding: const EdgeInsets.symmetric(
                                //     horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model.selectMerchantItem != null
                                          ? model
                                              .selectMerchantItem!.merchantName
                                          : 'Chọn đại lý',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: AppColor.GREY_TEXT,
                                          fontSize: 13),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: SizedBox(
                                // width: 234,
                                child: TextField(
                                  controller: widget.controller,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    model.filterListInvoice(
                                      size: widget.pageSize,
                                      page: 1,
                                      filterType: widget.filterBy,
                                      search: value,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 2, top: 6),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 16,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Nhập mã hoá đơn',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              if (model.valueFilterTime.id == 0) ...[
                Container(
                  width: 140,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: InkWell(
                    onTap: () async {
                      await _onPickMonth(model, model.getMonth()).then(
                        (time) {
                          if (time != null) {
                            model.filterListInvoice(
                              size: widget.pageSize,
                              page: 1,
                              filterType: widget.filterBy,
                              search: widget.controller.text,
                            );
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${model.selectedDate.month}/${model.selectedDate.year}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const Icon(Icons.calendar_month_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
              ],
              VietQRButton.gradient(
                  borderRadius: 100,
                  onPressed: () {
                    model.filterListInvoice(
                      size: widget.pageSize,
                      page: 1,
                      filterType: widget.filterBy,
                      search: widget.controller.text,
                    );
                  },
                  isDisabled: false,
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.zero,
                  child: const Center(
                      child: Icon(
                    Icons.search,
                    size: 18,
                    color: AppColor.WHITE,
                  ))),
              const Spacer(),
              PopupMenuButton<DataFilter>(
                offset: const Offset(-100, 0),
                padding: const EdgeInsets.all(0),
                onSelected: (DataFilter result) {
                  model.updateFilterTime(result);
                },
                itemBuilder: (BuildContext context) => _buildMenuItems(
                    model.listFilterTime, model.valueFilterTime),
                elevation: 4,
                initialValue: model.valueFilterTime,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isHover
                          ? AppColor.GREY_TEXT.withOpacity(0.1)
                          : AppColor.TRANSPARENT),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt,
                          size: 15, color: AppColor.GREY_TEXT),
                      SizedBox(width: 4),
                      Text(
                        'Thời gian',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColor.GREY_TEXT,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _onPickMonth(
      InvoiceViewModel model, DateTime dateTime) async {
    DateTime? result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              year: 2,
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    if (result != null) {
      model.selectDateTime(result);
      return result;
      // setState(() {
      //   selectDate = result;
      // });
      // _model.filterListInvoice(time: selectDate!, page: 1);
    } else {
      // selectDate = _model.getMonth();
    }
  }

  List<PopupMenuEntry<DataFilter>> _buildMenuItems(
      List<DataFilter> value, DataFilter selected) {
    List<PopupMenuEntry<DataFilter>> items = value
        .map(
          (e) => PopupMenuItem<DataFilter>(
            value: e,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selected.id == e.id
                        ? AppColor.BLUE_TEXT.withOpacity(0.1)
                        : AppColor.TRANSPARENT),
                child: Center(
                  child: Text(
                    e.name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected.id == e.id
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                )),
          ),
        )
        .toList();

    return items;
  }

  void onSelectMerchant({String? id}) async {
    return await showDialog(
      context: context,
      builder: (context) =>
          PopupSelectTypeWidget(type: 0, merchantId: id ?? '', isGetList: true),
    );
  }
}
