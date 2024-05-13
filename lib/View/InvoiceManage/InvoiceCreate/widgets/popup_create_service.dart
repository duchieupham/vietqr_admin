import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class PopupCreateServiceWidget extends StatefulWidget {
  const PopupCreateServiceWidget({super.key});

  @override
  State<PopupCreateServiceWidget> createState() =>
      _PopupCreateServiceWidgetState();
}

class _PopupCreateServiceWidgetState extends State<PopupCreateServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          color: AppColor.WHITE,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Stack(
            children: [
              Column(),
              Positioned(
                top: 0,
                right: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
