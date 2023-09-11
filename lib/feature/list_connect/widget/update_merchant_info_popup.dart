import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_connect/provider/connect_info_provider.dart';
import 'package:vietqr_admin/feature/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/connect.dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';

class UpdateMerchantPopup extends StatefulWidget {
  final ConnectDTO dto;
  final VoidCallback uploadSuccess;
  const UpdateMerchantPopup(
      {Key? key, required this.dto, required this.uploadSuccess})
      : super(key: key);

  @override
  State<UpdateMerchantPopup> createState() => _UpdateMerchantPopupState();
}

class _UpdateMerchantPopupState extends State<UpdateMerchantPopup> {
  InfoConnectBloc infoConnectBloc = InfoConnectBloc();

  ApiServiceDTO apiServiceDTO = const ApiServiceDTO();

  EcomerceDTO ecomerceDTO = const EcomerceDTO();

  TextEditingController urlEditingCtl = TextEditingController();
  TextEditingController ipEditingCtl = TextEditingController();
  TextEditingController portEditingCtl = TextEditingController();
  TextEditingController suffixEditingCtl = TextEditingController();
  TextEditingController userNameEditingCtl = TextEditingController();
  TextEditingController passEditingCtl = TextEditingController();

  @override
  void initState() {
    infoConnectBloc = InfoConnectBloc()
      ..add(GetInfoConnectEvent(
          id: widget.dto.id, platform: widget.dto.platform));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<InfoConnectBloc>(
      create: (BuildContext context) => infoConnectBloc,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTitle(context),
            BlocConsumer<InfoConnectBloc, InfoConnectState>(
                listener: (context, state) {
              if (state is UpdateMerchantLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is UpdateMerchantConnectSuccessState) {
                Navigator.pop(context);
                widget.uploadSuccess();
                Navigator.pop(context);
              }
              if (state is UpdateFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Đã có lỗi xảy ra',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is InfoApiServiceConnectSuccessfulState) {
                apiServiceDTO = state.dto;
                urlEditingCtl.text = apiServiceDTO.url;
                ipEditingCtl.text = apiServiceDTO.ip;
                portEditingCtl.text = apiServiceDTO.port;
                suffixEditingCtl.text = apiServiceDTO.suffix;
                userNameEditingCtl.text = apiServiceDTO.customerUsername;
                passEditingCtl.text = apiServiceDTO.customerPassword;
              }
              if (state is InfoEcomerceDTOConnectSuccessfulState) {
                // ecomerceDTO = state.dto;
                // urlEditingCtl.text = ecomerceDTO.url;
                // ipEditingCtl.text = ecomerceDTO.ip;
                // portEditingCtl.text = ecomerceDTO.port;
                // suffixEditingCtl.text = ecomerceDTO.suffix;
                // userNameEditingCtl.text = ecomerceDTO.customerUsername;
                // passEditingCtl.text = ecomerceDTO.customerPassword;
              }
            }, builder: (context, state) {
              return ChangeNotifierProvider<ConnectInfoProvider>(
                create: (context) => ConnectInfoProvider(),
                child: Expanded(
                    child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildTemplateInfo('URL',
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: urlEditingCtl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildTemplateInfo('IP',
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: ipEditingCtl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildTemplateInfo('PORT',
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: portEditingCtl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildTemplateInfo('Suffix',
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: suffixEditingCtl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Basic Authentication',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildTemplateInfo('Username*',
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: userNameEditingCtl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Consumer<ConnectInfoProvider>(
                        builder: (context, provider, child) {
                      return _buildTemplateInfoPass(
                          'Password',
                          passEditingCtl.text,
                          provider.showPassUser, onShow: () {
                        provider.updateShowPassUser(!provider.showPassUser);
                      });
                    }),
                  ],
                )),
              );
            }),
            ButtonWidget(
              height: 40,
              text: 'Thêm',
              borderRadius: 5,
              textColor: DefaultTheme.WHITE,
              bgColor: DefaultTheme.BLUE_TEXT,
              function: () {
                Map<String, dynamic> param = {};
                param['url'] = urlEditingCtl.text;
                param['ip'] = ipEditingCtl.text;
                param['port'] = portEditingCtl.text;
                param['suffix'] = suffixEditingCtl.text;
                param['username'] = userNameEditingCtl.text;
                param['customerSyncId'] = widget.dto.id;
                infoConnectBloc.add(UpdateMerchantEvent(param: param));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateInfoPass(String title, String value, bool showPass,
      {required VoidCallback onShow}) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: DefaultTheme.GREY_LIGHT)),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              flex: 4,
              child: Text(
                showPass ? value : '***********',
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: onShow,
              child: showPass
                  ? Image.asset(
                      'assets/images/ic-hide.png',
                      height: 16,
                    )
                  : Image.asset(
                      'assets/images/ic-unhide.png',
                      height: 16,
                    ),
            ),
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
          border: Border.all(color: DefaultTheme.GREY_LIGHT)),
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
