import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

class PopupBankDetailWidget extends StatefulWidget {
  final BankSystemItem dto;

  const PopupBankDetailWidget({super.key, required this.dto});

  @override
  State<PopupBankDetailWidget> createState() => _PopupBankDetailWidgetState();
}

class _PopupBankDetailWidgetState extends State<PopupBankDetailWidget> {
  final TextEditingController _keyController = TextEditingController();
  // final TextEditingController _phoneNumberController = TextEditingController();
  // final TextEditingController _identityController = TextEditingController();
  // final TextEditingController _accountNameController = TextEditingController();
  // final TextEditingController _bankCodeController = TextEditingController();
  late SystemViewModel _model;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị của các controller từ widget.dto
    _model = Get.find<SystemViewModel>();
    // _accountNameController.text = widget.dto.bankAccountName;
    // _accountNameController.text = widget.dto.bankAccountName;
    // _bankCodeController.text = widget.dto.bankCode;
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SystemViewModel>(
      model: _model,
      child: AlertDialog(
        title: const Text(
          "Thông tin TK ngân hàng",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                      // color: Colors.red,
                      child: _buildTextFormFiledCustom(
                          initialValue: widget.dto.bankAccountName,
                          label: 'Chủ tài khoản'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                      // color: Colors.red,
                      child: _buildTextFormFiledCustom(
                          initialValue:
                              '${widget.dto.bankShortName} - ${widget.dto.bankAccount.isNotEmpty ? widget.dto.bankAccount : '-'}',
                          label: 'Tài khoản'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'TK VietQR',
                        textContent: widget.dto.phoneNo,
                        isDate: false),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'Ngày kích hoạt',
                        textContent: _formatDate(widget.dto.validFrom),
                        isDate: true),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'Ngày hết hạn',
                        textContent: _formatDate(widget.dto.validFeeTo),
                        isDate: true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'Luồng',
                        textContent: widget.dto.mmsActive ? 'TF' : 'MF',
                        isDate: false),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 2,
                    child: _buildItem(
                        label: 'Email',
                        textContent: widget.dto.email.isNotEmpty
                            ? widget.dto.email
                            : '-',
                        isDate: false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'CCCD/CMND',
                        textContent: widget.dto.nationalId.isNotEmpty
                            ? widget.dto.nationalId
                            : '-',
                        isDate: false),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'VSO',
                        textContent:
                            widget.dto.vso.isNotEmpty ? widget.dto.vso : '-',
                        isDate: false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 40,
                  // color: Colors.red,
                  child: _buildTextFormFiledCustom(
                      label: 'Mã Key',
                      hint: 'Nhập mã key',
                      controller: _keyController,
                      readOnly: false),
                ),
              ),
              if (_statusMessage != null) ...[
                Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.dto.validService ? () {} : null,
                    style: ButtonStyle(
                      backgroundColor: widget.dto.validService
                          ? WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Colors.white;
                              },
                            )
                          : WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return AppColor.GREY_DADADA;
                              },
                            ),
                      foregroundColor: widget.dto.validService
                          ? WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Colors.black;
                              },
                            )
                          : WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return AppColor.GREY_TEXT;
                              },
                            ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0)),
                    ),
                    child: const Text(
                      'Tắt kích hoạt',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //checkSum: hashMD5 từ: “VietQRAccesskey” + bankId + keyActive
                      String keyActive = _keyController.text;
                      if (keyActive == '') {
                        setState(() {
                          _statusMessage = 'Key không được bỏ trống.';
                        });
                      } else if (keyActive.length > 12) {
                        setState(() {
                          _statusMessage = 'Key không quá 12 ký tự.';
                        });
                      } else {
                        final String checkSum = _generateMd5(
                            'VietQRAccesskey${widget.dto.bankId}$keyActive');
                        final resultRequest = await _model.requestActiveKey(
                            bankId: widget.dto.bankId,
                            checkSum: checkSum,
                            keyActive: keyActive);
                        if (resultRequest is ResponseDataDTO) {
                          final String otp = resultRequest.data.otp;
                          //checkSum: hashMD5 từ: “VietQRAccesskey” + otp + keyActive
                          final String checkSumOTP =
                              _generateMd5('VietQRAccesskey$otp$keyActive');
                          final resultConfirm = await _model.confirmActiveKey(
                              bankId: widget.dto.bankId,
                              checkSum: checkSumOTP,
                              keyActive: keyActive,
                              otp: otp);
                          if (resultConfirm.status == 'SUCCESS') {
                            Navigator.pop(context);
                            toastification.show(
                              context: context,
                              type: ToastificationType.success,
                              style: ToastificationStyle.flat,
                              title: const Text(
                                'Kích hoạt Key thành công',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              showProgressBar: false,
                              alignment: Alignment.topRight,
                              autoCloseDuration: const Duration(seconds: 5),
                              boxShadow: highModeShadow,
                              dragToClose: true,
                              pauseOnHover: true,
                            );
                          } else {
                            final String errorMessage = (resultConfirm).message;
                            setErrorKey(errorMessage);
                          }
                        }
                        if (resultRequest is ResponseMessageDTO) {
                          final String errorMessage = (resultRequest).message;
                          setErrorKey(errorMessage);
                        }
                      }
                    },
                    child: Text(
                      widget.dto.validService ? 'Gia hạn Key' : 'Kích hoạt Key',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void setErrorKey(String errorMessage) {
    setState(() {
      switch (errorMessage) {
        case 'E25':
          setState(() {
            _statusMessage =
                'Không tìm thấy tài khoản ngân hàng trong hệ thống.';
          });
          break;
        case 'E101':
          setState(() {
            _statusMessage = 'Tài khoản ngân hàng chưa được liên kết.';
          });
          break;
        case 'E127':
          setState(() {
            _statusMessage = 'Key không chích xác, vui lòng thử lại.';
          });
          break;
        case 'E128':
          setState(() {
            _statusMessage =
                'Không tìm thấy tài khoản ngân hàng trong hệ thống.';
          });
          break;
        case '129':
          setState(() {
            _statusMessage = 'Quá thời gian thực hiện, vui lòng thử lại.';
          });
          break;
        case '130':
          setState(() {
            _statusMessage = 'Key đã được sử dụng, vui lòng thử lại.';
          });
          break;
        case '131':
          setState(() {
            _statusMessage = 'Key không hợp lệ, vui lòng thử lại.';
          });
          break;
        default:
          setState(() {
            _statusMessage = 'Đã xảy ra lỗi, vui lòng thử lại.';
          });
      }
    });
  }

  Widget _buildItem(
      {required String label,
      required String textContent,
      required bool isDate}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              5,
            ),
            border: Border.all(color: AppColor.GREY_DADADA),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textContent,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.GREY_TEXT),
                ),
              ),
              isDate
                  ? const Icon(
                      Icons.calendar_month_outlined,
                      size: 15,
                      color: AppColor.GREY_TEXT,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  TextFormField _buildTextFormFiledCustom({
    String? hint,
    required String label,
    String? initialValue,
    TextEditingController? controller,
    bool readOnly = true,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue != null
          ? initialValue == ''
              ? '-'
              : initialValue
          : null,
      readOnly: readOnly,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          overflow: TextOverflow.ellipsis,
          color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            overflow: TextOverflow.ellipsis,
            color: AppColor.GREY_TEXT),
        floatingLabelStyle: const TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        labelStyle: const TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: const BorderSide(color: Colors.black),
            gapPadding: 5),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: const BorderSide(color: Colors.black),
            gapPadding: 5),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: const BorderSide(color: Colors.black),
            gapPadding: 5),
      ),
    );
  }

  // Widget _buildTextField(String label, TextEditingController controller,
  //     {bool readOnly = false}) {
  //   return TextFormField(
  //     controller: controller,
  //     readOnly: readOnly,
  //     keyboardType: readOnly ? TextInputType.text : TextInputType.number,
  //     inputFormatters: readOnly ? [] : [FilteringTextInputFormatter.digitsOnly],
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //     ),
  //   );
  // }
  String _formatDate(int date) {
    return date.toString() != '0'
        ? DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(date * 1000))
        : '-';
  }
}
