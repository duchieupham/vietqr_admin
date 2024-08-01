import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng FilteringTextInputFormatter
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class PopupCheckLogWidget extends StatefulWidget {
  final String bankAccount;
  PopupCheckLogWidget({super.key, required this.bankAccount});

  @override
  State<PopupCheckLogWidget> createState() => _PopupCheckLogWidgetState();
}

class _PopupCheckLogWidgetState extends State<PopupCheckLogWidget> {
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị của _accountNumberController từ widget.bankAccount
    _accountNumberController.text = widget.bankAccount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Thông tin kiểm tra"),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Số tài khoản", _accountNumberController),
            const SizedBox(height: 16),
            _buildTextField("Số điện thoại", _phoneNumberController),
            const SizedBox(height: 16),
            _buildTextField("CCCD/MST", _identityController),
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
                  onPressed: () {
                    String accountNumber = _accountNumberController.text;
                    String phoneNumber = _phoneNumberController.text;
                    String identity = _identityController.text;

                    print("Số tài khoản: $accountNumber");
                    print("Số điện thoại: $phoneNumber");
                    print("CCCD/MST: $identity");

                    // Bạn có thể xử lý thêm ở đây nếu cần
                    Navigator.of(context).pop(); // Đóng hộp thoại khi xác nhận
                  },
                  child: const Text("Xác nhận"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
