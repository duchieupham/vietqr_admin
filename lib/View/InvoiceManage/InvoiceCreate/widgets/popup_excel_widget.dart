import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import 'item_title_widget.dart';

class PopupExcelInvoice extends StatefulWidget {
  const PopupExcelInvoice({super.key});

  @override
  State<PopupExcelInvoice> createState() => _PopupExcelInvoiceState();
}

class _PopupExcelInvoiceState extends State<PopupExcelInvoice> {
  late InvoiceViewModel _model;
  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          color: AppColor.WHITE,
          width: 1200,
          height: 750,
          child: ScopedModel<InvoiceViewModel>(
              model: _model,
              child: ScopedModelDescendant<InvoiceViewModel>(
                  builder: (context, child, model) {
                return Column(
                  children: [
                    Container(
                      width: 1200,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Xuất Excel dữ liệu giao dịch',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1160,
                      height: 690,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const SizedBox(
                            width: double.infinity,
                            height: 18,
                            child: Text(
                              'Thông tin khách hàng thanh toán',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 1160,
                            child: Column(
                              children: [
                                _itemTitleWidget(),
                                _buildItem(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const MySeparator(
                            color: AppColor.GREY_DADADA,
                          ),
                          const SizedBox(height: 30),
                          const SizedBox(
                            width: double.infinity,
                            height: 18,
                            child: Text(
                              'Thông tin giao dịch',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 350,
                            width: 1000,
                            child: Column(
                              children: [
                                Container(
                                  child: _itemTitleInfoTransactionWidget(),
                                ),
                                Container(
                                  height: 250,
                                  width: 1000,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                        _buildItemInfoTransaction(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
              top: BorderSide(color: AppColor.GREY_DADADA, width: 1))),
      child: Row(
        children: const [
          BuildItemlTitle(
              title: 'Số tài khoản',
              textAlign: TextAlign.center,
              width: 150,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Chủ tài khoản',
              height: 50,
              width: 220,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Luồng kết nối',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Gói dịch vụ',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí/GD (VND)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Phí/GD (%)',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Ghi nhận GD',
              height: 50,
              width: 190,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '0541103612005\nMBBank',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 220,
            child: SelectionArea(
              child: Text(
                'Cong Ty Co Phan Dau Tu... ajsdnkas saskdn askndas sndasdnkasd asdasd asd asd heha ahsd axnz',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                'VietQR Pro',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                'VQR5_PT',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                '0',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                '0,8',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                '8',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 190,
            child: SelectionArea(
              child: Text(
                'Chỉ GD đối soát',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleInfoTransactionWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
      )),
      child: Row(
        children: const [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Thời gian',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng GD (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đến (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đi (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'GD đối soát (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thao tác',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemInfoTransaction() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '1',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '03/2024',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12,540 GD',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '2,046,300,000',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12,000 GD',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '2,000,000,000',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '540 GD',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '46,300,000',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12,000 GD',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '2,000,000,000',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'Xuất Excel',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.green,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}