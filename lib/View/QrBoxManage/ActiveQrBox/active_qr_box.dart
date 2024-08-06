import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';

import '../../../ViewModel/qr_box_viewModel.dart';
import '../../../commons/constants/configurations/theme.dart';

class ActiveQrBoxScreen extends StatefulWidget {
  const ActiveQrBoxScreen({super.key});

  @override
  State<ActiveQrBoxScreen> createState() => _ActiveQrBoxScreenState();
}

class _ActiveQrBoxScreenState extends State<ActiveQrBoxScreen> {
  late QrBoxViewModel _model;

  BankTypeDTO? selectBank = const BankTypeDTO(
      id: '0',
      bankCode: '',
      bankName: 'Chọn ngân hàng thụ hưởng',
      bankShortName: '',
      imageId: '',
      caiValue: '',
      status: 0);

  @override
  void initState() {
    super.initState();
    _model = Get.find<QrBoxViewModel>();
    _model.getBankList();
  }

  @override
  void dispose() {
    super.dispose();
    _model.certController.clear();
    _model.storeController.clear();
    _model.addressController.clear();
    _model.stkController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<QrBoxViewModel>(
        model: _model,
        child: Container(
          height: context.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              const Divider(
                color: AppColor.GREY_DADADA,
              ),
              Expanded(child: _bodyWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<QrBoxViewModel>(
      builder: (context, child, model) {
        bool? isCreate = false;
        if (model.addressText!.isNotEmpty &&
            model.certText!.isNotEmpty &&
            model.storeText!.isNotEmpty &&
            model.stkText!.isNotEmpty &&
            selectBank?.id != '0') {
          isCreate = true;
        }
        if (model.activeSuccess == true) {
          context.go('/qr-box');
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Thông tin QR Box',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Certificate*",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 40,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA)),
                      child: TextField(
                        onChanged: (value) {
                          model.changeCertText(value);
                        },
                        controller: model.certController,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(bottom: 8, top: 8),
                            border: InputBorder.none,
                            hintText: 'Nhập QR Box Certificate',
                            hintStyle: const TextStyle(
                                fontSize: 15, color: AppColor.GREY_TEXT),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  model.certController.clear();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: AppColor.GREY_TEXT,
                                ))),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Thông tin Cửa hàng / Điểm bán",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tên cửa hàng / điểm bán*",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 350,
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: TextField(
                                onChanged: (value) {
                                  model.changeStoreText(value);
                                },
                                controller: model.storeController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Nhập tên cửa hàng / điểm bán',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          model.storeController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColor.GREY_TEXT,
                                        ))),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Địa chỉ cửa hàng / điểm bán*",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 350,
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: TextField(
                                onChanged: (value) {
                                  model.changeAddrText(value);
                                },
                                controller: model.addressController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    border: InputBorder.none,
                                    hintText:
                                        'Nhập địa chỉ cửa hàng / điểm bán',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          model.addressController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColor.GREY_TEXT,
                                        ))),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Thông tin tài khoản ngân hàng",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ngân hàng*",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 500,
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: DropdownButton<BankTypeDTO>(
                                value: selectBank,
                                underline: const SizedBox.shrink(),
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                  ),
                                ),
                                isExpanded: true,
                                items: model.bankList?.map((e) {
                                  if (e.id == '0') {
                                    return DropdownMenuItem<BankTypeDTO>(
                                      value: e,
                                      child: Text(e.bankName),
                                    );
                                  }
                                  return DropdownMenuItem<BankTypeDTO>(
                                      value: e,
                                      child: Text(
                                          '${e.bankShortName} - ${e.bankName}'));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectBank = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Số tài khoản*",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 350,
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  model.changeStkText(value);
                                },
                                controller: model.stkController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    border: InputBorder.none,
                                    hintText: 'Nhập số tài khoản ngân hàng',
                                    hintStyle: const TextStyle(
                                        fontSize: 15,
                                        color: AppColor.GREY_TEXT),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          model.stkController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColor.GREY_TEXT,
                                        ))),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (isCreate == true) {
                    model.activeQrBox();
                  }
                },
                child: Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isCreate == true
                        ? AppColor.BLUE_TEXT
                        : AppColor.GREY_TEXT.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Kích hoạt QR Box',
                      style: TextStyle(
                          fontSize: 15,
                          color: isCreate == true
                              ? AppColor.WHITE
                              : AppColor.BLACK),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quản lý QR Box",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Kích hoạt QR Box",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
