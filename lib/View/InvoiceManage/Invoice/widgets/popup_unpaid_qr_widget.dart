import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'dart:js' as js;
import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/share_utils.dart';
import '../../../../commons/constants/utils/string_utils.dart';
import '../../../../commons/widget/repaint_boundary_widget.dart';

class PopupUnpaidQrCodeInvoice extends StatefulWidget {
  final Function(String) onPop;
  final bool showButton;
  const PopupUnpaidQrCodeInvoice(
      {super.key,
      required this.onPop,
      this.showButton = true});

  @override
  State<PopupUnpaidQrCodeInvoice> createState() => _PopupUnpaidQrCodeInvoiceState();
}

class _PopupUnpaidQrCodeInvoiceState extends State<PopupUnpaidQrCodeInvoice> {
  final globalKey = GlobalKey();

  void onSaveImage(BuildContext context, String bankAccount) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance
            .saveImageToGallery(globalKey, bankAccount)
            .then(
          (value) {
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
              webBgColor: 'rgba(255, 255, 255)',
              webPosition: 'center',
            );
          },
        );
      },
    );
  }

  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    // _model.getQrDetail(widget.invoiceId);
    // _model.requestPayment(invoiceId: widget.invoiceId);
  }

  @override
  void dispose() {
    super.dispose();
    _model.clear();
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
                  if (model.unpaidDetailQrDTO == null) {
                    return const SizedBox.shrink();
                  }
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                RepaintBoundaryWidget(
                                    globalKey: globalKey,
                                    builder: (key) {
                                      return Container(
                                        width: 400,
                                        height: 400,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/bg-qr-vqr.png'),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: (_model.status ==
                                                      ViewStatus.Loading &&
                                                  _model.request ==
                                                      InvoiceType
                                                          .REQUEST_PAYMENT)
                                              ? const CircularProgressIndicator(
                                                  color: AppColor.BLUE_TEXT,
                                                )
                                              : Container(
                                                  width: 320,
                                                  height: 320,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 20, 30, 10),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 240,
                                                        height: 240,
                                                        // color: AppColor.GREY_DADADA,
                                                        child: QrImageView(
                                                          data: model
                                                                  .unpaidDetailQrDTO
                                                                  ?.qrCode ??
                                                              '',
                                                          size: 220,
                                                          version:
                                                              QrVersions.auto,
                                                          embeddedImage:
                                                              const AssetImage(
                                                                  'assets/images/ic-viet-qr-small.png'),
                                                          embeddedImageStyle:
                                                              const QrEmbeddedImageStyle(
                                                            size: Size(30, 30),
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8),
                                                              child:
                                                                  Image.asset(
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
                                      );
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'SỬ DỤNG APP NGÂN HÀNG HOẶC VÍ ĐIỆN TỬ QUÉT MÃ QR ĐỂ THANH TOÁN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                               const SizedBox(
                          height: 15,
                        ),
                        if (model.unpaidDetailQrDTO!.urlLink.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: AppColor.WHITE,
                                gradient: VietQRTheme.gradientColor.lilyLinear),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      js.context.callMethod(
                                          'open', [model.unpaidDetailQrDTO!.urlLink]);
                                    },
                                    child: Text(
                                      model.unpaidDetailQrDTO!.urlLink,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: AppColor.BLUE_TEXT,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: model.unpaidDetailQrDTO!.urlLink));
                                    Fluttertoast.showToast(
                                      msg: 'Đã sao chép',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      textColor: Theme.of(context).hintColor,
                                      fontSize: 15,
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/ic-copy-blue.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                                InkWell(
                                  onTap: () {
                                    onSaveImage(context,
                                        model.unpaidDetailQrDTO!.bankAccount);
                                  },
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
                                Text(
                                  // widget.dto.invoiceName,
                                  model.unpaidDetailQrDTO!.invoiceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: Text(
                                    StringUtils.formatNumber(
                                        model.unpaidDetailQrDTO?.totalAmountAfterVat),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: AppColor.ORANGE),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                _buildItem('Mã hoá đơn',
                                    model.unpaidDetailQrDTO!.invoiceNumber),
                                if (model.unpaidDetailQrDTO!.vso.isNotEmpty &&
                                    model.unpaidDetailQrDTO!.midName.isNotEmpty)
                                  _buildItem('Khách hàng thanh toán',
                                      '${model.unpaidDetailQrDTO!.vso} - ${model.unpaidDetailQrDTO!.midName}')
                                else
                                  _buildItem('Tài khoản ngân hàng',
                                      '${model.unpaidDetailQrDTO?.bankShortName} - ${model.unpaidDetailQrDTO?.bankAccount} - ${model.unpaidDetailQrDTO?.userBankName}'),
                                _buildItem(
                                    'Tổng tiền',
                                    StringUtils.formatNumber(
                                        model.unpaidDetailQrDTO?.totalAmount)),
                                _buildItem('Tiền thuế GTGT (VAT)',
                                    '${model.unpaidDetailQrDTO?.vat}% - ${StringUtils.formatNumber(model.unpaidDetailQrDTO?.vatAmount)}'),
                                _buildItem(
                                    'Tổng tiền thanh toán',
                                    StringUtils.formatNumber(model
                                        .unpaidDetailQrDTO?.totalAmountAfterVat)),
                                const Spacer(),
                                // if (widget.showButton)
                                //   Center(
                                //     child: MButtonWidget(
                                //       onTap: () {
                                //         // _model.onChangePage(PageInvoice.DETAIL);
                                //         // Navigator.of(context)
                                //         //     .pop(widget.invoiceId);
                                //         widget.onPop(widget.invoiceId);
                                //         Navigator.of(context).pop();
                                //       },
                                //       title: 'Chi tiết hoá đơn',
                                //       isEnable: true,
                                //       margin: const EdgeInsets.only(bottom: 50),
                                //       width: 400,
                                //       border:
                                //           Border.all(color: AppColor.BLUE_TEXT),
                                //       height: 50,
                                //     ),
                                //   ),
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
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      rightText,
                      style: leftText == 'Tổng tiền thanh toán'
                          ? boldStyle
                          : defaultStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
