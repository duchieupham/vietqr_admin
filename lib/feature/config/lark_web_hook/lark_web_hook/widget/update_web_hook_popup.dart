import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';

import '../../../../../models/DTO/web_hook_dto.dart';

class UpdateWebhookPopup extends StatefulWidget {
  final WebHookDTO dto;
  final Function(Map<String, dynamic> param) update;

  const UpdateWebhookPopup({Key? key, required this.dto, required this.update})
      : super(key: key);

  @override
  State<UpdateWebhookPopup> createState() => _UpdateWebhookPopupState();
}

class _UpdateWebhookPopupState extends State<UpdateWebhookPopup> {
  TextEditingController desEditingCtl = TextEditingController();
  TextEditingController webhookEditingCtl = TextEditingController();
  TextEditingController nameEditingCtl = TextEditingController();
  @override
  void initState() {
    desEditingCtl = TextEditingController(text: widget.dto.description);
    nameEditingCtl = TextEditingController(text: widget.dto.partnerName);
    webhookEditingCtl = TextEditingController(text: widget.dto.webhook);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTitle(context),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildTemplateInfo('Tên',
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: nameEditingCtl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
              const SizedBox(
                height: 8,
              ),
              _buildTemplateInfo('Webhook',
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: webhookEditingCtl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
              const SizedBox(
                height: 8,
              ),
              _buildTemplateInfo('Mô tả',
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: desEditingCtl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
            ],
          )),
          ButtonWidget(
            height: 40,
            text: 'Cập nhật',
            borderRadius: 5,
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              if (nameEditingCtl.text.isEmpty ||
                  webhookEditingCtl.text.isEmpty ||
                  desEditingCtl.text.isEmpty) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Thông tin không chính xác',
                    msg: 'Vui lòng nập đủ thông tin');
              } else {
                Map<String, dynamic> param = {};
                param['partnerName'] = nameEditingCtl.text;
                param['webhook'] = webhookEditingCtl.text;
                param['description'] = desEditingCtl.text;
                param['id'] = widget.dto.id;
                widget.update(param);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateInfo(String title, {required Widget child}) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColor.GREY_LIGHT)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(flex: 4, child: child),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Cập nhật thông tin merchant',
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
