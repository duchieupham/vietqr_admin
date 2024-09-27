import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/widgets/popup_select_widget.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button.dart';
import 'package:vietqr_admin/commons/widget/dialog_pick_month.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';

class FilterInvoiceWidget extends StatefulWidget {
  final TextEditingController controller;
  final int filterBy;
  final int pageSize;
  final int invoiceType;

  final Function(int) onCall;
  const FilterInvoiceWidget(
      {super.key,
      required this.controller,
      required this.filterBy,
      required this.invoiceType,
      required this.onCall,
      required this.pageSize});

  @override
  State<FilterInvoiceWidget> createState() => _FilterInvoiceWidgetState();
}

class _FilterInvoiceWidgetState extends State<FilterInvoiceWidget> {
  bool isHover = false;

  int statusSelect = 0;

  @override
  Widget build(BuildContext context) {
    final List<ItemSearch> listHintSearch = [
      ItemSearch(id: 0, title: 'mã hóa đơn'),
      ItemSearch(id: 1, title: 'TK ngân hàng'),
      ItemSearch(id: 2, title: 'Tk VietQR'),
    ];
    final List<ItemSearch> listHintMerchantSearch = [
      ItemSearch(id: 0, title: 'tên đại lý'),
      ItemSearch(id: 1, title: 'mã VSO'),
    ];

    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        // ignore: unused_local_variable
        String inputText = '';
        if (widget.filterBy == 0) {
          switch (model.subMenuType) {
            case 0:
              inputText = 'mã hóa đơn';
              break;
            case 1:
              inputText = 'TK ngân hàng';
              break;
            case 2:
              inputText = 'TK VietQR';
              break;
            case 3:
              inputText = 'đại lý';
              break;
            default:
          }
        } else {
          switch (model.subMenuType) {
            case 0:
              inputText = 'tên đại lý';
              break;
            case 1:
              inputText = 'mã vso';
              break;
            default:
          }
        }
        return Container(
          // margin: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Row(
            children: [
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
                            model.clearSelectMerchant();
                            model.changeTypeInvoice(value);
                            widget.onCall(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        thickness: 1,
                        color: AppColor.GREY_DADADA,
                      ),
                    ),
                    if (model.subMenuType == 4)
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: statusSelect,
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
                          items: model.listMenuDropStatus(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.controller.clear();
                              setState(() {
                                statusSelect = value;
                              });
                              model.filterListInvoice(
                                invoiceType: widget.invoiceType,
                                size: widget.pageSize,
                                page: 1,
                                filterType: widget.filterBy,
                                search: value.toString(),
                              );
                            }
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: (model.subMenuType == 3)
                            ? InkWell(
                                onTap: () async {
                                  await model.getMerchant('', isGetList: true);
                                  onSelectMerchant(
                                      filterBy: widget.filterBy,
                                      pageSize: widget.pageSize);
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
                                            ? model.selectMerchantItem!
                                                .merchantName
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
                            : SizedBox(
                                // width: 234,
                                child: TextField(
                                  controller: widget.controller,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    model.filterListInvoice(
                                      invoiceType: widget.invoiceType,
                                      size: widget.pageSize,
                                      page: 1,
                                      filterType: widget.filterBy,
                                      search: value,
                                    );
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 2, top: 6),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 16,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                    border: InputBorder.none,
                                    hintText: widget.filterBy == 0
                                        ? 'Nhập ${listHintSearch[model.subMenuType].title}'
                                        : 'Nhập ${listHintMerchantSearch[model.subMenuType].title}',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                ),
                              ),
                      ),
                  ],
                ),
              ),

              if (model.valueFilterTime.id == 0) ...[
                const SizedBox(width: 8),
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
                              invoiceType: widget.invoiceType,
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
              ],
              const SizedBox(width: 8),
              VietQRButton.gradient(
                  borderRadius: 100,
                  onPressed: () {
                    model.filterListInvoice(
                      invoiceType: widget.invoiceType,
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

              // const Spacer(),
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

  void onSelectMerchant(
      {String? id, required int pageSize, required int filterBy}) async {
    return await showDialog(
      context: context,
      builder: (context) => PopupSelectTypeWidget(
        invoiceType: widget.invoiceType,
        type: 0,
        merchantId: id ?? '',
        isGetList: true,
        pageSize: pageSize,
        filterBy: filterBy,
      ),
    );
  }
}

class ItemSearch {
  final int id;
  final String title;

  ItemSearch({required this.id, required this.title});
}
