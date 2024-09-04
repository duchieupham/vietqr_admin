import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/models/DTO/key_dto.dart';

class PopupCheckKeyDetailWidget extends StatefulWidget {
  final ResponseActiveKeyDTO dto;

  const PopupCheckKeyDetailWidget({super.key, required this.dto});

  @override
  State<PopupCheckKeyDetailWidget> createState() =>
      _PopupCheckKeyDetailWidgetState();
}

class _PopupCheckKeyDetailWidgetState extends State<PopupCheckKeyDetailWidget> {
  final TextEditingController _keyController = TextEditingController();
  // final TextEditingController _phoneNumberController = TextEditingController();
  // final TextEditingController _identityController = TextEditingController();
  // final TextEditingController _accountNameController = TextEditingController();
  // final TextEditingController _bankCodeController = TextEditingController();
  late SystemViewModel _model;
  // String? _statusMessage;
  // bool _isSuccess = false;

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
              "Thông tin Key chi tiết",
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
                          initialValue: widget.dto.userBankName,
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
                              '${widget.dto.bankShortName} - ${widget.dto.bankAccount.isNotEmpty ? widget.dto.bankAccount : ''}',
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
                        label: 'Số điện thoại',
                        textContent: widget.dto.phoneNo.isNotEmpty ? widget.dto.phoneNo : '-',
                        isDate: false),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: _buildItem(
                        label: 'Ngày kích hoạt',
                        textContent: _formatDate(widget.dto.validFeeFrom),
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
                    flex: 2,
                    child: _buildItem(
                        label: 'Người sử dụng Key',
                        textContent: widget.dto.fullName.isNotEmpty
                            ? widget.dto.fullName
                            : '-',
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
                        label: 'Thời hạn của Key',
                        textContent: '${widget.dto.duration}' != '0'
                            ? '${widget.dto.duration}'
                            : '0',
                        isDate: false),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 2,
                    child: _buildItem(
                        label: 'Key',
                        textContent:
                            widget.dto.key.isNotEmpty ? widget.dto.key : '-',
                        isDate: false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 Text(
                      widget.dto.status == 1 ? 'Đã kích hoạt' : 'Chưa kích hoạt',
                      style:  TextStyle(
                        color: widget.dto.status == 1 ? AppColor.GREEN : AppColor.RED_TEXT,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
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
      inputFormatters: [VietnameseNameInputFormatter()],
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

  String _formatDate(int date) {
    return date.toString() != '0'
        ? DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(date * 1000))
        : '-';
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
