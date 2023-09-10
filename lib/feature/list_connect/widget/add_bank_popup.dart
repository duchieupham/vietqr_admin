import 'package:flutter/material.dart';

class AddBankPopup extends StatelessWidget {
  final String customerSyncId;
  final String accountCustomerId;
  const AddBankPopup(
      {Key? key, required this.customerSyncId, required this.accountCustomerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Thêm TK ngân hàng để đồng bộ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 24,
            ))
      ],
    );
  }
}
