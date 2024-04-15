import 'package:flutter/material.dart';

import '../constants/configurations/theme.dart';
import 'm_button_widget.dart'; // Giả sử bạn đã có widget button này

class DialogPickYear extends StatefulWidget {
  final DateTime dateTime;

  const DialogPickYear({super.key, required this.dateTime});

  @override
  State<DialogPickYear> createState() => _DialogPickYearState();
}

class _DialogPickYearState extends State<DialogPickYear> {
  List<int> listYear = [];
  int _selectedYear = 0;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.dateTime.year;
    for (int i = 0; i < 5; i++) {
      // Cho phép chọn trong vòng 100 năm trở lại
      listYear.add(widget.dateTime.year - i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 300,
      width: 300,
      child: Column(
        children: [
          Container(
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chọn năm',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                DropdownButton<int>(
                  value: _selectedYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                    });
                  },
                  dropdownColor: AppColor.GREY_979797,
                  items: listYear.map<DropdownMenuItem<int>>((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(
                        '$year',
                        style: const TextStyle(
                            fontSize: 22,
                            color: AppColor.WHITE,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Vui lòng chọn năm từ danh sách',
                  style: TextStyle(fontSize: 18, color: Colors.black54)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MButtonWidget(
                title: 'Đóng',
                isEnable: true,
                width: 80,
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                colorEnableText: Colors.black,
                colorEnableBgr: AppColor.BANK_CARD_COLOR_2,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              MButtonWidget(
                title: 'Xác nhận',
                width: 80,
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                isEnable: true,
                onTap: () {
                  Navigator.of(context).pop(DateTime(_selectedYear));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
