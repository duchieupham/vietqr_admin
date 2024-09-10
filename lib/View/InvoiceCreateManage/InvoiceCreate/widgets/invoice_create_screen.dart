import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/bank_account_item.dart';

import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/item_title_widget.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/widgets/popup_create_service.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/widgets/popup_select_widget.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../models/DTO/service_item_dto.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final Function(String, String, String, Uint8List?) onCreate;
  const CreateInvoiceScreen({super.key, required this.onCreate});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final TextEditingController _invoiceTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  bool? isErrorInvoiceName = false;
  bool? isErrorDescription = false;
  bool? isCreateSuccess = false;
  // final GlobalKey<_CreateInvoiceScreenState> myWidgetKey = GlobalKey();
  final _horizontal = ScrollController();

  late InvoiceViewModel _model;
  String? _fileName = '';
  Uint8List? byte;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    _model.getListRequestPayment();
    _model.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _invoiceTextController.clear();
    _descriptionTextController.clear();
    _model.clear();
  }

  void onShowPopup(int type, {String? id}) async {
    return await showDialog(
      context: context,
      builder: (context) => PopupSelectTypeWidget(
          type: type, merchantId: id ?? '', isGetList: false),
    );
  }

  void onShowCreatePopup({required bool isEdit, ServiceItemDTO? dto}) async {
    await showDialog(
      context: context,
      builder: (context) => PopupCreateServiceWidget(
        isPageUpdate: false,
        isEdit: isEdit,
        dto: isEdit == true ? dto : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel(
          model: _model,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: AppColor.GREY_DADADA,
                      ),
                      Expanded(
                        child: ListView(
                          children: [_bodyWidget()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomWidget(router),
            ],
          )),
    );
  }

  Widget bottomWidget(GoRouter router) {
    // final GlobalKey<> myWidgetKey = GlobalKey();
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        return Container(
          height: 120,
          // margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              color: AppColor.WHITE,
              border: Border(
                  top: BorderSide(
                color: AppColor.GREY_BORDER,
                width: 1,
              ))),
          child: Row(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tổng tiền hàng",
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            StringUtils.formatNumber(model.totalAmount),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 110),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VAT",
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            StringUtils.formatNumber(model.totalVat),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 110),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tổng tiền thanh toán (bao gồm VAT)",
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            StringUtils.formatNumber(model.totalAmountVat),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.BLUE_TEXT),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              MButtonWidget(
                title: 'Tạo hoá đơn',
                colorDisableBgr: AppColor.GREY_DADADA,
                isEnable: (model.totalAmountVat != 0 &&
                        model.listService!.isNotEmpty &&
                        _invoiceTextController.text.isNotEmpty)
                    ? true
                    : false,
                width: 350,
                height: 50,
                onTap: () async {
                  setState(() {
                    isErrorInvoiceName =
                        _invoiceTextController.text.isEmpty ? true : false;
                    // isErrorDescription =
                    //     _descriptionTextController.text.isEmpty ? true : false;
                  });

                  if (isErrorDescription == false &&
                      isErrorInvoiceName == false &&
                      model.listService!.isNotEmpty) {
                    widget.onCreate(_invoiceTextController.text,
                        _descriptionTextController.text, _fileName ?? '', byte);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonAddIvoiceItem() {
    return InkWell(
      onTap: () {
        onShowCreatePopup(isEdit: false);
      },
      child: MButtonWidget(
        title: 'Thêm mới danh mục hàng hoá / dịch vụ',
        border: Border.all(color: AppColor.BLUE_TEXT),
        isEnable: true,
        colorEnableBgr: AppColor.WHITE,
        colorEnableText: AppColor.BLUE_TEXT,
        width: 350,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        height: 50,
      ),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        String displayText = '';
        if (model.type == 0) {
          displayText =
              '${model.selectMerchantItem != null ? model.selectMerchantItem?.merchantName : "Chọn đại lý"}';
        } else {
          displayText = model.selectBank != null
              ? "${model.selectBank?.bankShortName} - ${model.selectBank?.bankAccount}"
              : 'Chọn TK ngân hàng';
        }
        List<Widget> buildItemList(List<ServiceItemDTO>? list) {
          if (list == null || list.isEmpty) {
            return [];
          }

          return list
              .asMap()
              .map((index, e) {
                return MapEntry(index, _buildItem(e, index + 1));
              })
              .values
              .toList();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 250,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Tạo mới hoá đơn',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 20,
                width: 250,
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  'Thông tin khởi tạo hoá đơn',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 100,
                            height: 20,
                            child: Text(
                              'Tên hoá đơn*',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _invoiceTextController,
                              onChanged: (value) {
                                _invoiceTextController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.collapsed(
                                        offset: value.length));
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                border: InputBorder.none,
                                hintText: isErrorInvoiceName == true
                                    ? 'Vui lòng nhập tên hóa đơn'
                                    : 'Nhập tên hoá đơn tại đây',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: isErrorInvoiceName == true
                                        ? AppColor.RED_TEXT
                                        : AppColor.GREY_TEXT),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 100,
                            height: 20,
                            child: Text(
                              'Mô tả hoá đơn',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _descriptionTextController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                border: InputBorder.none,
                                hintText: isErrorDescription == true
                                    ? 'Vui lòng nhập mô tả hóa đơn'
                                    : 'Nhập thông tin mô tả hoá đơn ở đây',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: isErrorDescription == true
                                        ? AppColor.RED_TEXT
                                        : AppColor.GREY_TEXT),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Container(
                height: 30,
                width: 250,
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Thông tin khách hàng thanh toán',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Đối tượng*',
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: model.selectMerchantItem != null
                                    ? () async {
                                        await FlutterClipboard.copy(model
                                                .selectMerchantItem!
                                                .merchantName)
                                            .then(
                                          (value) => Fluttertoast.showToast(
                                            msg: 'Đã sao chép',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: AppColor.WHITE,
                                            textColor: AppColor.BLACK,
                                            fontSize: 15,
                                            webBgColor: 'rgba(255, 255, 255)',
                                            webPosition: 'center',
                                          ),
                                        );
                                      }
                                    : null,
                                child: const Icon(
                                  Icons.copy,
                                  size: 15,
                                  color: AppColor.BLUE_TEXT,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: model.type == 1 ? 500 : 400,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: model.type == 1 ? 200 : 150,
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    value: model.type,
                                    underline: const SizedBox.shrink(),
                                    icon: const RotatedBox(
                                      quarterTurns: 5,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem<int>(
                                          value: 0,
                                          child: Text(
                                            "Đại lý",
                                          )),
                                      DropdownMenuItem<int>(
                                          value: 1,
                                          child: Text(
                                            "Tài khoản ngân hàng",
                                          )),
                                    ],
                                    onChanged: (value) {
                                      model.changeType(value!);
                                      // DialogWidget.instance.openMsgDialog(
                                      //     title: 'Bảo trì',
                                      //     msg:
                                      //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: AppColor.GREY_DADADA,
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      // DialogWidget.instance.openMsgDialog(
                                      //     title: 'Bảo trì',
                                      //     msg:
                                      //         'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                      if (model.type == 0) {
                                        await model.getMerchant('',
                                            isGetList: false);
                                      } else {
                                        await model.getBanks('');
                                      }
                                      onShowPopup(
                                        model.type,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            displayText,
                                            style: TextStyle(
                                                color: model.type == 0
                                                    ? (model.selectMerchantItem !=
                                                            null
                                                        ? AppColor.BLACK
                                                        : AppColor.GREY_TEXT)
                                                    : (model.selectBank != null
                                                        ? AppColor.BLACK
                                                        : AppColor.GREY_TEXT),
                                                fontSize: 13),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 15,
                                            color: AppColor.GREY_TEXT,
                                          ),
                                        ],
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
                    if (model.type == 0 &&
                        model.selectMerchantItem != null) ...[
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 350,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Tài khoản ngân hàng*',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: model.selectBank != null
                                      ? () async {
                                          await FlutterClipboard.copy(
                                                  '${model.selectBank?.bankShortName} - ${model.selectBank?.bankAccount}')
                                              .then(
                                            (value) => Fluttertoast.showToast(
                                              msg: 'Đã sao chép',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: AppColor.WHITE,
                                              textColor: AppColor.BLACK,
                                              fontSize: 15,
                                              webBgColor: 'rgba(255, 255, 255)',
                                              webPosition: 'center',
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Icon(
                                    Icons.copy,
                                    size: 15,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                if (model.selectMerchantItem != null) {
                                  await model.getBanks('',
                                      merchantId:
                                          model.selectMerchantItem?.merchantId);
                                  onShowPopup(1,
                                      id: model.selectMerchantItem?.merchantId);
                                }
                              },
                              child: Container(
                                width: 350,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(model.selectBank != null
                                        ? '${model.selectBank?.bankShortName} - ${model.selectBank?.bankAccount}'
                                        : 'Chọn tài khoản ngân hàng'),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (model.bankDetail != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Chủ tài khoản',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    await FlutterClipboard.copy(
                                            model.bankDetail!.userBankName)
                                        .then(
                                      (value) => Fluttertoast.showToast(
                                        msg: 'Đã sao chép',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: AppColor.WHITE,
                                        textColor: AppColor.BLACK,
                                        fontSize: 15,
                                        webBgColor: 'rgba(255, 255, 255)',
                                        webPosition: 'center',
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 15,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_DADADA,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.bankDetail!.userBankName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Tài khoản VietQR-ID',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    await FlutterClipboard.copy(
                                            model.bankDetail!.phoneNo)
                                        .then(
                                      (value) => Fluttertoast.showToast(
                                        msg: 'Đã sao chép',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: AppColor.WHITE,
                                        textColor: AppColor.BLACK,
                                        fontSize: 15,
                                        webBgColor: 'rgba(255, 255, 255)',
                                        webPosition: 'center',
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 15,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_DADADA,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.bankDetail!.phoneNo,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 250,
                              height: 20,
                              child: Text(
                                'Email',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_DADADA,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.bankDetail!.email.isNotEmpty
                                        ? model.bankDetail!.email
                                        : '-',
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 20,
                              child: Text(
                                'Luồng kết nối',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_DADADA,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.bankDetail!.connectionType,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 250,
                              height: 20,
                              child: Text(
                                'Gói dịch vụ',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_DADADA,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.bankDetail!.feePackage,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 250,
                              height: 20,
                              child: Text(
                                'VAT (%)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 250,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // Changed to white background
                                border: Border.all(
                                  color: Colors.grey, // Gray border
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TextField(
                                      controller: model.vatTextController,
                                      onChanged: (value) {
                                        model.onChangeVat(value);
                                      },
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            model.bankDetail?.vat.toString(),
                                        hintStyle: const TextStyle(
                                            color: AppColor.GREY_TEXT,
                                            fontSize: 13),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                    ),
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
              ] else
                const SizedBox.shrink(),
              const SizedBox(height: 20),
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Chọn tệp đính kèm',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _pickFile();
                    },
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey)),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Đính kèm tệp',
                                  style: TextStyle(
                                    color: AppColor.BLUE_TEXT,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.attach_file,
                                color: AppColor.BLUE_TEXT,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_fileName ?? '')
                ],
              ),
              const SizedBox(height: 20),
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              const SizedBox(height: 10),
              Container(
                height: 30,
                width: 250,
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Danh mục hàng hoá / dịch vụ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // decoration: const BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(color: AppColor.GREY_TEXT, width: 0.5))),
                width: 1360,
                child: Scrollbar(
                  controller: _horizontal,
                  child: SingleChildScrollView(
                    controller: _horizontal,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        _itemTitleWidget(),
                        ...buildItemList(model.listService),
                      ],
                    ),
                  ),
                ),
              ),
              model.bankDetail != null
                  ? _buttonAddIvoiceItem()
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              const MySeparator(color: AppColor.GREY_DADADA),
              const SizedBox(height: 30),
              const SizedBox(
                width: double.infinity,
                height: 20,
                child: Text(
                  'Tài khoản nhận tiền',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              if (model.listPaymentRequest.isNotEmpty)
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final listPaymentBank = model.listPaymentRequest;

                        return SelectBankRecieveItem(
                          dto: listPaymentBank[index],
                          onChange: (value) {
                            model.selectPaymentRequest(index);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemCount: model.listPaymentRequest.length),
                ),
              const SizedBox(height: 200),
            ],
          ),
        );
      },
    );
  }

  

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Nội dung hoá đơn thanh toán',
              height: 50,
              width: 300,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn vị tính',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Số lượng',
              height: 50,
              width: 80,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn giá (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thành tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VAT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thao tác',
              height: 50,
              width: 90,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        _fileName = file.name;
        byte = file.bytes;
        // print('file name: ${result.files.single.bytes}');
        setState(() {});
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildItem(ServiceItemDTO item, int index) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
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
                index.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                item.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                item.unit,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 80,
            child: SelectionArea(
              child: Text(
                item.quantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(item.amount),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(item.totalAmount),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                item.vat.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(item.vatAmount.round()),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(item.amountAfterVat),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 90,
            child: SelectionArea(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      onShowCreatePopup(isEdit: true, dto: item);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      _model.deleteService(item);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.RED_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        size: 12,
                        color: AppColor.RED_TEXT,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}