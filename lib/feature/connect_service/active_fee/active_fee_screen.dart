import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class ActiveFeeScreen extends StatefulWidget {
  const ActiveFeeScreen({Key? key}) : super(key: key);

  @override
  State<ActiveFeeScreen> createState() => _ActiveFeeScreenState();
}

class _ActiveFeeScreenState extends State<ActiveFeeScreen> {
  final PageController pageViewController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Row(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phí dịch vụ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
