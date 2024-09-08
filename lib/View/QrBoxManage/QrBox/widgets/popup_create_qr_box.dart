import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/item_title_widget.dart';
import 'package:vietqr_admin/ViewModel/qr_box_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';

import '../../../../models/DTO/qr_box_dto.dart';

class PopupCreateQrBoxWidget extends StatefulWidget {
  final QrBoxDTO dto;
  const PopupCreateQrBoxWidget({super.key, required this.dto});

  @override
  State<PopupCreateQrBoxWidget> createState() => _PopupCreateQrBoxWidgetState();
}

class _PopupCreateQrBoxWidgetState extends State<PopupCreateQrBoxWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int inputLength = 0;
  late QrBoxViewModel _model;

  bool? createSuccess = false;

  @override
  void initState() {
    super.initState();
    _model = Get.find<QrBoxViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          color: AppColor.WHITE,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.75,
          child: ScopedModel<QrBoxViewModel>(
              model: _model,
              child: ScopedModelDescendant<QrBoxViewModel>(
                builder: (context, child, model) {
                  bool? isInput = false;
                  if (_amountController.value.text.isNotEmpty &&
                      inputLength != 0 &&
                      _contentController.value.text.isNotEmpty) {
                    isInput = true;
                  }
                  if (createSuccess == true) {}
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tạo mã VietQR giao dịch cho QR Box',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            'Thông tin QR Box',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 45),
                          _itemTitleWidget(),
                          _buildItemWidget(widget.dto),
                          const SizedBox(height: 30),
                          const MySeparator(color: AppColor.GREY_DADADA),
                          const SizedBox(height: 30),
                          const Text(
                            'Thông tin giao dịch',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          Expanded(child: _formInputWidget()),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                                onTap: () async {
                                  if (isInput == true) {
                                    bool? result = await model.createQrBox(
                                        widget.dto,
                                        amount:
                                            int.parse(_amountController.text),
                                        content: _contentController.text,
                                        note: _noteController.text);
                                    setState(() {
                                      createSuccess = result;
                                    });
                                    if (result == true) {
                                      Navigator.of(context).pop();
                                      DialogWidget.instance
                                          .openMsgSuccessDialog(
                                              title:
                                                  'Tạo mã QR Box thành công');
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isInput == false
                                        ? AppColor.GREY_TEXT.withOpacity(0.3)
                                        : AppColor.BLUE_TEXT,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: 350,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      'Tạo mã VietQR giao dịch',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: isInput == false
                                              ? AppColor.BLACK
                                              : AppColor.WHITE),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
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

  Widget _formInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số tiền*',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: AppColor.GREY_TEXT.withOpacity(0.3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập số tiền',
                            hintStyle: TextStyle(
                                fontSize: 15, color: AppColor.GREY_TEXT),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const Text(
                        'VND',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nội dung thanh toán* (${inputLength.toString()}/19)',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: AppColor.GREY_TEXT.withOpacity(0.3))),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        inputLength = value.length;
                      });
                    },
                    maxLength: 19,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _contentController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'Nhập nội dung thanh toán',
                      hintStyle:
                          TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ghi chú giao dịch',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: 550,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: AppColor.GREY_TEXT.withOpacity(0.3))),
              child: TextField(
                maxLines: 50,
                minLines: 1,
                controller: _noteController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                  border: InputBorder.none,
                  hintText: 'Nhập ghi chú giao dịch',
                  hintStyle: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemWidget(QrBoxDTO dto) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.boxCode,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.terminalCode.isNotEmpty ? dto.terminalCode : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: dto.bankAccount.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dto.bankAccount,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.BLACK),
                        ),
                        Text(
                          dto.bankShortName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.BLACK),
                        ),
                      ],
                    )
                  : const Text(
                      '-',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                    ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.userBankName.isNotEmpty ? dto.userBankName : '-',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.feePackage.isNotEmpty ? dto.feePackage : '-',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      width: 760,
      // padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: const Row(children: [
        BuildItemlTitle(
            title: 'Mã QR Box',
            textAlign: TextAlign.left,
            width: 150,
            height: 50,
            alignment: Alignment.centerLeft),
        BuildItemlTitle(
            title: 'Mã cửa hàng',
            height: 50,
            width: 150,
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.center),
        SizedBox(width: 10),
        BuildItemlTitle(
            title: 'Số tài khoản',
            height: 50,
            width: 150,
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.center),
        BuildItemlTitle(
            title: 'Chủ tài khoản',
            height: 50,
            width: 150,
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.center),
        BuildItemlTitle(
            title: 'Luồng kết nối',
            height: 50,
            width: 150,
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.center),
      ]),
    );
  }
}
