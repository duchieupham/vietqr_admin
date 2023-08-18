import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class WebMobileBlankWidget extends StatelessWidget {
  const WebMobileBlankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/logo-vietqr-vn.png',
                            width: 150,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      'Quét mã QR để tải ứng dụng VietQR',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Padding(padding: EdgeInsets.only(top: 50)),
                    const Text(
                      'Tải ứng dụng trên cửa hàng',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      'VietQR chỉ hỗ trợ trình duyệt web cho PC.',
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          // BottomWeb(
          //   bgColor: Theme.of(context).cardColor,
          // ),
        ],
      ),
    );
  }
}
