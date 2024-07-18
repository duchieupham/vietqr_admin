import 'package:flutter/material.dart';

class ChangeFlowDialog extends StatefulWidget {
  final String bankAccount;
  final String bankCode;
  final String customerBankName;
  final String address;
  final Function(String address) onConfirm;

  ChangeFlowDialog({
    required this.bankAccount,
    required this.bankCode,
    required this.customerBankName,
    required this.address,
    required this.onConfirm,
  });

  @override
  _ChangeFlowDialogState createState() => _ChangeFlowDialogState();
}

class _ChangeFlowDialogState extends State<ChangeFlowDialog> {
  late TextEditingController _addressController;
  bool _isAddressValid = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address);
    _isAddressValid = _addressController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chuyển luồng'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: widget.bankAccount),
            readOnly: true,
            decoration: InputDecoration(labelText: 'Số tài khoản'),
          ),
          TextField(
            controller: TextEditingController(text: widget.bankCode),
            readOnly: true,
            decoration: InputDecoration(labelText: 'Ngân hàng'),
          ),
          TextField(
            controller: TextEditingController(text: widget.customerBankName),
            readOnly: true,
            decoration: InputDecoration(labelText: 'Chủ tài khoản'),
          ),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Địa chỉ đại lý'),
            onChanged: (value) {
              setState(() {
                _isAddressValid = value.isNotEmpty;
              });
            },
          ),
          SizedBox(height: 4),
          if (!_isAddressValid)
            Align(
              alignment: Alignment.centerRight,
              child: const Text(
                'Địa chỉ đại lý là bắt buộc',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.3),
            // foregroundColor: Colors.grey,
            side: BorderSide(color: Colors.grey),
          ),
          child: Text(
            'Hủy',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: _isAddressValid
              ? () {
                  widget.onConfirm(_addressController.text);
                  Navigator.pop(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: _isAddressValid ? Colors.white : Colors.black,
            backgroundColor: _isAddressValid ? Colors.blue : Colors.grey,
            side:
                BorderSide(color: _isAddressValid ? Colors.blue : Colors.grey),
          ),
          child: Text(
            'Xác nhận',
            style:
                TextStyle(color: _isAddressValid ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
