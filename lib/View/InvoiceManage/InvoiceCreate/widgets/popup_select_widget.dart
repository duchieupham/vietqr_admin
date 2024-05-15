import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

import '../../../../commons/constants/enum/view_status.dart';
import '../../../../models/DTO/bank_invoice_dto.dart';
import '../../../../models/DTO/invocie_merchant_dto.dart';
import '../../../../models/DTO/metadata_dto.dart';
import 'item_title_widget.dart';

class PopupSelectTypeWidget extends StatefulWidget {
  final String merchantId;
  final int type;
  const PopupSelectTypeWidget(
      {super.key, required this.type, required this.merchantId});

  @override
  State<PopupSelectTypeWidget> createState() => _PopupSelectTypeWidgetState();
}

class _PopupSelectTypeWidgetState extends State<PopupSelectTypeWidget> {
  final TextEditingController _controller = TextEditingController();
  late InvoiceViewModel _model;
  MerchantItem? selectItem;
  BankItem? selectBank;
  bool? hasSelect = false;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          color: AppColor.WHITE,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                builder: (context, child, model) {
                  List<MerchantItem>? listMerchant = [];
                  List<BankItem>? listBank = [];
                  if (widget.type == 0) {
                    if (model.merchantDTO != null) {
                      listMerchant = model.merchantDTO?.items;
                    }
                  } else {
                    if (model.bankDTO != null) {
                      listBank = model.bankDTO?.items;
                    }
                  }

                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'Chọn ${widget.type == 0 ? "đại lý thanh toán hoá đơn" : "tài khoản ngân hàng"}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColor.GREY_DADADA)),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.multiline,
                                      controller: _controller,
                                      onFieldSubmitted: (value) {
                                        if (widget.type == 0) {
                                          model.getMerchant(value);
                                        } else {
                                          model.getBanks(value,
                                              merchantId: widget.merchantId);
                                        }
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              top: 11, bottom: 10),
                                          hintText: widget.type == 1
                                              ? 'Tìm kiếm theo tài khoản ngân hàng'
                                              : 'Tìm kiếm theo tên đại lý',
                                          hintStyle: TextStyle(
                                              fontSize: 20,
                                              color: AppColor.BLACK
                                                  .withOpacity(0.5)),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            size: 20,
                                          ),
                                          prefixIconColor: AppColor.GREY_TEXT,
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 20,
                                              color: AppColor.GREY_TEXT,
                                            ),
                                            onPressed: () {
                                              // provider.filterBankList('');
                                              _controller.clear();
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    if (widget.type == 0) {
                                      model.getMerchant(
                                          _controller.text.isNotEmpty
                                              ? _controller.text
                                              : '');
                                    } else {
                                      model.getBanks(
                                          _controller.text.isNotEmpty
                                              ? _controller.text
                                              : '',
                                          merchantId: widget.merchantId);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColor.BLUE_TEXT,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.search,
                                          size: 15,
                                          color: AppColor.WHITE,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Tìm kiếm",
                                          style: TextStyle(
                                              color: AppColor.WHITE,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Expanded(
                              child: Column(
                            children: [
                              _itemTitleWidget(),
                              if (model.status == ViewStatus.Loading)
                                const Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()))
                              else if (model.status == ViewStatus.Completed)
                                Expanded(
                                  child: ((widget.type == 0 &&
                                              listMerchant!.isNotEmpty) ||
                                          (widget.type == 1 &&
                                              listBank!.isNotEmpty))
                                      ? ListView.builder(
                                          itemCount: widget.type == 0
                                              ? listMerchant?.length
                                              : listBank?.length,
                                          itemBuilder: (context, index) {
                                            if (widget.type == 0) {
                                              bool isSelect =
                                                  listMerchant?[index]
                                                          .merchantId ==
                                                      selectItem?.merchantId;
                                              return _buildItem(
                                                  merchantItem:
                                                      listMerchant![index],
                                                  isSelect: isSelect);
                                            } else {
                                              bool isSelect =
                                                  listBank?[index].bankId ==
                                                      selectBank?.bankId;
                                              return _buildItem(
                                                  bankItem: listBank![index],
                                                  isSelect: isSelect);
                                            }
                                          },
                                        )
                                      : Center(
                                          child: Text(widget.type == 0
                                              ? 'Hiện không có đại lý'
                                              : "Hiện không TK ngân hàng"),
                                        ),
                                ),
                            ],
                          )),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                if (hasSelect == true && selectItem != null) {
                                  model.selectMerchant(selectItem!);
                                  Navigator.of(context).pop();
                                }
                                if (hasSelect == true && selectBank != null) {
                                  model.bankSelect(selectBank!);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: hasSelect == true
                                        ? AppColor.BLUE_TEXT
                                        : AppColor.GREY_DADADA,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'Xác nhận',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: hasSelect == true
                                            ? AppColor.WHITE
                                            : AppColor.BLACK),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(bottom: 8, left: 20, child: _pagingWidget()),
                      Positioned(
                        top: 0,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        bool isPaging = false;

        MetaDataDTO paging = model.createMetaData!;
        if (paging == null) {
          return const SizedBox.shrink();
        }
        if (paging.page! != paging.totalPage!) {
          isPaging = true;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                "Trang ${paging.page}/${paging.totalPage}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                if (paging.page != 1) {
                  await model.getMerchant(
                      _controller.text.isNotEmpty ? _controller.text : '',
                      page: paging.page! - 1);
                  // await model.filterListSystemTransaction(
                  //   time: selectDate!,
                  //   page: paging.page! - 1,
                  // );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: paging.page != 1
                            ? AppColor.BLACK
                            : AppColor.GREY_DADADA)),
                child: Center(
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: paging.page != 1
                        ? AppColor.BLACK
                        : AppColor.GREY_DADADA,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () async {
                if (isPaging) {
                  await model.getMerchant(
                      _controller.text.isNotEmpty ? _controller.text : '',
                      page: paging.page! + 1);
                  // await model.filterListSystemTransaction(
                  //   time: selectDate!,
                  //   page: paging.page! + 1,
                  // );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color:
                            isPaging ? AppColor.BLACK : AppColor.GREY_DADADA)),
                child: Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isPaging ? AppColor.BLACK : AppColor.GREY_DADADA,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(
      {bool? isSelect, MerchantItem? merchantItem, BankItem? bankItem}) {
    return InkWell(
      onTap: () {
        if (widget.type == 0) {
          setState(() {
            selectItem = merchantItem;
          });
        } else {
          setState(() {
            selectBank = bankItem;
          });
        }
        hasSelect = true;
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: isSelect == false
                ? AppColor.WHITE
                : AppColor.BLUE_TEXT.withOpacity(0.2),
            border: const Border(
                bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
        alignment: Alignment.center,
        child: Row(
          children: widget.type == 0
              ? [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 120,
                    child: SelectionArea(
                      child: Text(
                        merchantItem!.vsoCode,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 200,
                    child: SelectionArea(
                      child: Text(
                        merchantItem.merchantName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 200,
                    child: SelectionArea(
                      child: Text(
                        merchantItem.platform,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 100,
                    child: SelectionArea(
                      child: Text(
                        merchantItem.numberOfBank.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ]
              : [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 120,
                    child: SelectionArea(
                      child: Text(
                        bankItem!.bankAccount,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 200,
                    child: SelectionArea(
                      child: Text(
                        bankItem.userBankName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 100,
                    child: SelectionArea(
                      child: Text(
                        bankItem.bankShortName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 130,
                    child: SelectionArea(
                      child: Text(
                        bankItem.connectionType,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 100,
                    child: SelectionArea(
                      child: Text(
                        bankItem.feePackage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Row(
        children: widget.type != 0
            ? const [
                BuildItemlTitle(
                    title: 'Số tài khoản',
                    textAlign: TextAlign.center,
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Chủ tài khoản',
                    height: 50,
                    width: 200,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Ngân hàng',
                    height: 50,
                    width: 100,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Luồng kết nối',
                    height: 50,
                    width: 130,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Gói dịch vụ',
                    height: 50,
                    width: 100,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
              ]
            : const [
                BuildItemlTitle(
                    title: 'VSO',
                    textAlign: TextAlign.center,
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft),
                BuildItemlTitle(
                    title: 'Đại lý',
                    height: 50,
                    width: 200,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'Nền tảng',
                    height: 50,
                    width: 200,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
                BuildItemlTitle(
                    title: 'TK đồng bộ',
                    height: 50,
                    width: 100,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.center),
              ],
      ),
    );
  }
}
