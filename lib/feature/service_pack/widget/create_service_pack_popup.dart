import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/service_pack/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/provider/form_create_provider.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';

class CreateServicePackPopup extends StatefulWidget {
  final ServicePackBloc servicePackBloc;
  const CreateServicePackPopup({Key? key, required this.servicePackBloc})
      : super(key: key);

  @override
  State<CreateServicePackPopup> createState() => _CreateServicePackPopupState();
}

class _CreateServicePackPopupState extends State<CreateServicePackPopup> {
  late ServicePackBloc bloc;

  @override
  void initState() {
    bloc = ServicePackBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicePackBloc>(
      create: (context) => bloc,
      child: ChangeNotifierProvider<FormCreateProvider>(
        create: (context) => FormCreateProvider(),
        child: BlocConsumer<ServicePackBloc, ServicePackState>(
            listener: (context, state) {
          if (state is ServicePackLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is ServicePackInsertSuccessState) {
            Navigator.pop(context);
            widget.servicePackBloc.add(const ServicePackGetListEvent());
            Navigator.pop(context);
          }
          if (state is ServicePackInsertFailsState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
                title: 'Không thể thêm',
                msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Consumer<FormCreateProvider>(
                builder: (context, provider, child) {
              return Column(
                children: [
                  _buildTitle(context),
                  Expanded(child: _buildForm(provider)),
                  ButtonWidget(
                    height: 40,
                    text: 'Thêm',
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      if (provider.isValidForm()) {
                        Map<String, dynamic> param = {};
                        param['shortName'] = provider.packCodeCtrl.text;
                        param['name'] = provider.packNameCtrl.text;
                        param['description'] = provider.desCtrl.text;
                        param['activeFee'] =
                            int.parse(provider.activeFeeCtrl.text);
                        param['annualFee'] =
                            int.parse(provider.annualFeeCtrl.text);
                        param['monthlyCycle'] =
                            int.parse(provider.monthlyCycleCtrl.text);
                        param['transFee'] =
                            int.parse(provider.transFeeCtrl.text);
                        param['sub'] = false;
                        param['refId'] = '';
                        param['countingTransType'] =
                            provider.typeGD.id.toString();

                        String percentFee = provider.percentFeeCtrl.text;
                        if (percentFee.contains(',')) {
                          param['percentFee'] = percentFee.replaceAll(',', '.');
                        } else {
                          param['percentFee'] = percentFee;
                        }

                        bloc.add(InsertServicePackEvent(param: param));
                      } else {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Không thể thêm',
                            msg: 'Vui lòng nhập đầy đủ dữ liệu trên form');
                      }

                      // provider.checkErrorAccountNumber();
                      // if (!provider.errorAccountNumber &&
                      //     !provider.errorAccountNumber) {

                      // }
                    },
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildForm(FormCreateProvider provider) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTemplateInput('Gói',
                  controller: provider.packCodeCtrl,
                  hintText: 'Ví dụ VIETQR_1',
                  onChange: (value) {}),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 2,
              child: _buildTemplateInput('Tên gói',
                  controller: provider.packNameCtrl,
                  hintText: 'Nhập tên gói',
                  onChange: (value) {}),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        _buildTemplateInput('Phí kích hoạt',
            controller: provider.activeFeeCtrl,
            onChange: (value) {},
            until: 'VND',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTemplateInput('Phí thường niên',
                  onChange: (value) {},
                  controller: provider.annualFeeCtrl,
                  until: 'VND',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 2,
              child: _buildTemplateInput('Thời hạn',
                  onChange: (value) {},
                  controller: provider.monthlyCycleCtrl,
                  until: 'Tháng',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        _buildTemplateInput('Phí/GD',
            onChange: (value) {},
            controller: provider.transFeeCtrl,
            until: 'VND',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        const SizedBox(
          height: 12,
        ),
        _buildTemplateInput(
          'Phần trăm phí/Tổng tiền GD',
          onChange: (value) {},
          controller: provider.percentFeeCtrl,
          until: '%',
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColor.GREY_LIGHT)),
          child: Row(
            children: [
              const Text(
                'Ghi nhận giao dịch',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                width: 28,
              ),
              const Spacer(),
              DropdownButton<GDItem>(
                value: provider.typeGD,
                icon: const RotatedBox(
                  quarterTurns: 5,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                ),
                underline: const SizedBox.shrink(),
                onChanged: (GDItem? value) {
                  provider.updateTypeGd(value!);
                },
                items: provider.listTypeGD
                    .map<DropdownMenuItem<GDItem>>((GDItem value) {
                  return DropdownMenuItem<GDItem>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        value.title,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        _buildTemplateInput(
          'Mô tả',
          onChange: (value) {},
          controller: provider.desCtrl,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Tạo gói mới',
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

  Widget _buildTemplateInput(
    String title, {
    String hintText = '',
    String until = '',
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    required Function(String) onChange,
  }) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColor.GREY_LIGHT)),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            width: 28,
          ),
          Expanded(
              child: TextField(
            onChanged: onChange,
            controller: controller,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle:
                    const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT)),
          )),
          const SizedBox(
            width: 14,
          ),
          Text(
            until,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
