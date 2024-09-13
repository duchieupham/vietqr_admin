import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/response_message_dto.dart';

class PopupCheckLogWidget extends StatefulWidget {
  final String bankAccount;
  final BankSystemItem dto;

  const PopupCheckLogWidget(
      {super.key, required this.bankAccount, required this.dto});

  @override
  State<PopupCheckLogWidget> createState() => _PopupCheckLogWidgetState();
}

class _PopupCheckLogWidgetState extends State<PopupCheckLogWidget> {
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  late SystemViewModel _model;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị của các controller từ widget.dto
    _model = Get.find<SystemViewModel>();
    _accountNumberController.text = widget.bankAccount;
    _accountNameController.text = widget.dto.bankAccountName;
    _bankCodeController.text = widget.dto.bankCode;
    _phoneNumberController.text = widget.dto.phoneNo;
    _identityController.text = widget.dto.nationalId;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SystemViewModel>(
      model: _model,
      child: AlertDialog(
        title: const Text("Thông tin kiểm tra"),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Số tài khoản", _accountNumberController,
                  readOnly: true),
              const SizedBox(height: 16),
              _buildTextField("Tên chủ tài khoản", _accountNameController,
                  readOnly: true),
              const SizedBox(height: 16),
              _buildTextField("Ngân hàng", _bankCodeController, readOnly: true),
              const SizedBox(height: 16),
              _buildTextField("Số điện thoại", _phoneNumberController),
              const SizedBox(height: 16),
              _buildTextField("CCCD/MST", _identityController),
              const SizedBox(height: 16),
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Hủy"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> param = {
                        "nationalId": _identityController.text,
                        "accountNumber": _accountNumberController.text,
                        "accountName": _accountNameController.text,
                        "phoneNumber": _phoneNumberController.text,
                        "applicationType": "MOBILE",
                        "bankCode": _bankCodeController.text,
                      };

                      ResponseMessageDTO? result = await _model.checkLog(param);

                      setState(() {
                        if (result != null) {
                          _statusMessage = result.status == "SUCCESS"
                              ? "Thành công: ${result.message}"
                              : "Thất bại: ${result.message}";
                          _isSuccess = result.status == "SUCCESS";
                        } else {
                          _statusMessage = "Đã có lỗi xảy ra";
                          _isSuccess = false;
                        }
                      });
                    },
                    child: const Text("Xác nhận"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: readOnly ? TextInputType.text : TextInputType.number,
      inputFormatters: readOnly ? [] : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
