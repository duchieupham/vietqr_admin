import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:get/get.dart';

import '../../../../models/DTO/invoice_dto.dart';

class PopupCheckEmailWidget extends StatefulWidget {
  final ItemMerchant dto;

  const PopupCheckEmailWidget({super.key, required this.dto});

  @override
  State<PopupCheckEmailWidget> createState() => _PopupCheckEmailWidgetState();
}

class _PopupCheckEmailWidgetState extends State<PopupCheckEmailWidget> {
  final TextEditingController _emailController = TextEditingController();

  late InvoiceViewModel _model;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị của các controller từ widget.dto
    _model = Get.find<InvoiceViewModel>();
    _emailController.text = widget.dto.email;
  }

  @override
  Widget build(BuildContext context) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return ScopedModel<InvoiceViewModel>(
      model: _model,
      child: AlertDialog(
           title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Thông tin kiểm tra",
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
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Email", _emailController, readOnly: false),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      String email = _emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() {
                          _statusMessage = 'Email không được bỏ trống.';
                        });
                      } else if (!emailRegex.hasMatch(email)) {
                        setState(() {
                          _statusMessage = 'Email không hợp lệ.';
                        });
                      }
                    },
                    child: const Text("Cập nhật"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() {
                          _statusMessage = 'Email không được bỏ trống.';
                        });
                      } else if (!emailRegex.hasMatch(email)) {
                        setState(() {
                          _statusMessage = 'Email không hợp lệ.';
                        });
                      }
                      // Map<String, dynamic> param = {
                      //   "nationalId": _identityController.text,
                      //   "accountNumber": _accountNumberController.text,
                      //   "accountName": _accountNameController.text,
                      //   "phoneNumber": _phoneNumberController.text,
                      //   "applicationType": "MOBILE",
                      //   "bankCode": _bankCodeController.text,
                      // };

                      // ResponseMessageDTO? result = await _model.checkLog(param);

                      // setState(() {
                      //   if (result != null) {
                      //     _statusMessage = result.status == "SUCCESS"
                      //         ? "Thành công: ${result.message}"
                      //         : "Thất bại: ${result.message}";
                      //     _isSuccess = result.status == "SUCCESS";
                      //   } else {
                      //     _statusMessage = "Đã có lỗi xảy ra";
                      //     _isSuccess = false;
                      //   }
                      // });
                    },
                    child: const Text("Gửi"),
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
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [EmailInputFormatter()],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
