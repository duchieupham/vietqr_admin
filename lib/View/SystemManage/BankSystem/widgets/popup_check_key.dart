import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/popup_check_key_detail.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/feature/integration_connectivity/new_connect/new_connect_screen.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/key_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

class PopupCheckKeyWidget extends StatefulWidget {
  final BankSystemItem dto;

  const PopupCheckKeyWidget({super.key, required this.dto});

  @override
  State<PopupCheckKeyWidget> createState() => _PopupCheckKeyWidgetState();
}

class _PopupCheckKeyWidgetState extends State<PopupCheckKeyWidget> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Kiểm tra Key",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close))
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      readOnly: (_model.status == ViewStatus.Updating)
                          ? true
                          : false),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (_model.status == ViewStatus.Updating)
                        ? () {}
                        : () async {
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
                              _model.checkActiveKey(keyActive: keyActive).then(
                                (value) {
                                  if (value is ResponseActiveKeyDTO) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PopupCheckKeyDetailWidget(
                                          dto: value,
                                        );
                                      },
                                    );
                                  } else if (value is ResponseMessageDTO) {
                                    setState(() {
                                      _statusMessage = value.message;
                                    });
                                  }
                                },
                              );
                            }
                          },
                    child: const Text(
                      'Kiểm tra',
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
      inputFormatters: [
        VietnameseNameInputFormatter(),
        LengthLimitingTextInputFormatter(12),
        UpperCaseTextFormatter()
      ],
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
}

class VietnameseNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(
      r'^[a-zA-ZÀ-ỹẠ-ỵ0-9\s]*$',
    );
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
