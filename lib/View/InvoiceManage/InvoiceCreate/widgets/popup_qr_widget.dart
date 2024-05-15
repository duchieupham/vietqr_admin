import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';

class PopupQrCodeInvoice extends StatefulWidget {
  final InvoiceItem dto;
  const PopupQrCodeInvoice({super.key, required this.dto});

  @override
  State<PopupQrCodeInvoice> createState() => _PopupQrCodeInvoiceState();
}

class _PopupQrCodeInvoiceState extends State<PopupQrCodeInvoice> {
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
                              'Mã VietQR hoá đơn thanh toán',
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
                      Row(
                        children: [
                          Container(
                            width: 500,
                            height: 690,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 50),
                            decoration: const BoxDecoration(
                                color: AppColor.WHITE,
                                border: Border(
                                    right: BorderSide(
                                        color: AppColor.GREY_DADADA,
                                        width: 1))),
                            child: Column(
                              children: [
                                Container(
                                  width: 400,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bg-qr-vqr.png'),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 320,
                                      height: 320,
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 10),
                                      decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 240,
                                            height: 240,
                                            // color: AppColor.GREY_DADADA,
                                            child: QrImage(
                                              data: widget.dto.qrCode ?? '',
                                              size: 220,
                                              version: QrVersions.auto,
                                              embeddedImage: const AssetImage(
                                                  'assets/images/ic-viet-qr-small.png'),
                                              embeddedImageStyle:
                                                  QrEmbeddedImageStyle(
                                                size: const Size(30, 30),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Image.asset(
                                                    "assets/images/ic-viet-qr.png",
                                                    height: 20,
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/images/ic-napas247.png",
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 140,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: MButtonWidget(
                                    title: 'Lưu ảnh QR',
                                    isEnable: true,
                                    margin: EdgeInsets.zero,
                                    width: 400,
                                    colorEnableBgr: AppColor.WHITE,
                                    colorEnableText: AppColor.BLUE_TEXT,
                                    border:
                                        Border.all(color: AppColor.BLUE_TEXT),
                                    radius: 100,
                                    height: 50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 660,
                            height: 690,
                            color: AppColor.WHITE,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: Text(
                                    widget.dto.invoiceName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: Text(
                                    StringUtils.formatNumber(
                                        widget.dto.amount.toString()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: AppColor.ORANGE),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                _buildItem('Mã hoá đơn', widget.dto.billNumber),
                                _buildItem('Tài khoản ngân hàng',
                                    '${widget.dto.bankShortName} - ${widget.dto.bankAccount}'),
                                _buildItem('Chủ TK', widget.dto.fullName),
                                _buildItem(
                                    'Tổng tiền',
                                    StringUtils.formatNumber(
                                        widget.dto.amountNoVat.toString())),
                                _buildItem('Tiền thuế GTGT (VAT)',
                                    '${widget.dto.vat}% - ${StringUtils.formatNumber(widget.dto.vatAmount.toString())}'),
                                _buildItem(
                                    'Tổng tiền thanh toán',
                                    StringUtils.formatNumber(
                                        widget.dto.amount.toString())),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

  Widget _buildItem(String leftText, String rightText) {
    TextStyle defaultStyle = const TextStyle(fontSize: 15);
    TextStyle boldStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return SizedBox(
      width: 660,
      height: 60,
      child: Column(
        children: [
          SizedBox(
            width: 660,
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftText,
                  style: defaultStyle,
                ),
                Text(
                  rightText,
                  style: leftText == 'Tổng tiền thanh toán'
                      ? boldStyle
                      : defaultStyle,
                ),
              ],
            ),
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
        ],
      ),
    );
  }
}