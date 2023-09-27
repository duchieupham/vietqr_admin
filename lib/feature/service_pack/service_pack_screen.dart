import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/service_pack/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/provider/form_create_provider.dart';
import 'package:vietqr_admin/feature/service_pack/provider/service_pack_provider.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';
import 'package:vietqr_admin/feature/service_pack/widget/create_service_pack_popup.dart';
import 'package:vietqr_admin/models/service_pack_dto.dart';

class ServicePackScreen extends StatefulWidget {
  const ServicePackScreen({Key? key}) : super(key: key);

  @override
  State<ServicePackScreen> createState() => _ServicePackScreenState();
}

class _ServicePackScreenState extends State<ServicePackScreen> {
  late ServicePackBloc _bloc;
  StreamSubscription? _subscription;
  List<ServicePackDTO> listServicePack = [];

  @override
  void initState() {
    _bloc = ServicePackBloc()
      ..add(const ServicePackGetListEvent(initPage: true));
    _subscription = eventBus.on<RefreshServicePackList>().listen((data) {
      _bloc.add(const ServicePackGetListEvent(initPage: true));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicePackBloc>(
        create: (context) => _bloc,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(child: _buildListServicePack()),
          ],
        ));
  }

  Widget _buildListServicePack() {
    return LayoutBuilder(builder: (context, constraints) {
      return ChangeNotifierProvider<ServicePackProvider>(
        create: (context) => ServicePackProvider(),
        child:
            Consumer<ServicePackProvider>(builder: (context, provider, child) {
          return BlocConsumer<ServicePackBloc, ServicePackState>(
            listener: (context, state) {
              if (state is ServicePackLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is ServicePackInsertSuccessState) {
                Navigator.pop(context);

                provider.showFromInsert(state.servicePackId);
                _bloc.add(const ServicePackGetListEvent());
                DialogWidget.instance.openMsgDialog(
                    title: 'Thành công',
                    msg: 'Tạo gói nhỏ thành công',
                    isSuccess: true);
              }
              if (state is ServicePackInsertFailsState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Không thể thêm',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is ServicePackGetListSuccessState) {
                listServicePack = state.result;
                if (state.initPage) {
                  provider.init(listServicePack);
                } else {
                  provider.updateListServicePack(listServicePack);
                }
              }
            },
            builder: (context, state) {
              if (listServicePack.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text('Không có dữ liệu'),
                );
              }
              return SingleChildScrollView(
                  child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        width: constraints.maxWidth > 1350
                            ? constraints.maxWidth
                            : 1350,
                        child: Column(
                          children: [
                            _buildTitleItem(),
                            ...listServicePack.map((e) {
                              return _buildItem(e, provider);
                            }).toList(),
                          ],
                        ))),
              ));
            },
          );
        }),
      );
    });
  }

  Widget _buildTitleItem() {
    return Row(
      children: const [
        SizedBox(
          width: 40,
        ),
        SizedBox(
          width: 90,
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Gói',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 130,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Tên gói',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Phí kích hoạt',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Phí thuê bao',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Thời hạn',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Phí/GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Phần trăm phí/Tổng tiền',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Thuế(VAT)',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 135,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Ghi nhận GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Mô tả',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20, right: 20),
            child: Text(
              'Action',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(ServicePackDTO dto, ServicePackProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (dto.subItems?.isNotEmpty ?? false)
              InkWell(
                onTap: () {
                  provider.expandListSubItem(dto.item!);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                      color: AppColor.GREY_TEXT.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30)),
                  child: RotatedBox(
                    quarterTurns: provider.showListSubItem(dto.item!) ? 3 : 5,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(
                width: 40,
              ),
            Expanded(
                child: _buildInfoServicePack(dto.item!, provider: provider)),
          ],
        ),
        if (provider.checkShowFromInsert(dto.item!))
          _buildFormInsert(dto.item!),
        if (provider.showListSubItem(dto.item!))
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            margin: const EdgeInsets.only(left: 40),
            color: AppColor.GREY_TEXT.withOpacity(0.1),
            child: Column(
              children: dto.subItems!
                  .map((e) => _buildInfoServicePack(e, isSubItem: true))
                  .toList(),
            ),
          )
      ],
    );
  }

  Widget _buildFormInsert(SubServicePackDTO dto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      margin: const EdgeInsets.only(left: 40),
      decoration: BoxDecoration(
        color: AppColor.GREY_TEXT.withOpacity(0.1),
      ),
      child: ChangeNotifierProvider<FormCreateProvider>(
          create: (context) => FormCreateProvider(),
          child: Consumer<FormCreateProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: _buildTemplateInput(
                      hintText: 'Nhập mã gói',
                      controller: provider.packCodeCtrl,
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                        hintText: 'Nhập tên gói',
                        controller: provider.packNameCtrl,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                          hintText: 'Nhập phí',
                          controller: provider.activeFeeCtrl,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                          hintText: 'Nhập phí',
                          controller: provider.annualFeeCtrl,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                          hintText: 'Nhập thời hạn',
                          controller: provider.monthlyCycleCtrl,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                          hintText: 'Nhập phí',
                          controller: provider.transFeeCtrl,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                        hintText: 'Nhập phí',
                        controller: provider.percentFeeCtrl,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                        hintText: 'Nhập thuế',
                        controller: provider.vatCtrl,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 135,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Container(
                        height: 36,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.GREY_BG),
                        child: DropdownButton<GDItem>(
                          value: provider.typeGD,
                          style: const TextStyle(fontSize: 10),
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
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildTemplateInput(
                        hintText: 'Nhập mô tả',
                        controller: provider.desCtrl,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 20),
                      child: ButtonWidget(
                        height: 36,
                        text: 'Lưu',
                        sizeTitle: 12,
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
                            param['sub'] = true;
                            param['refId'] = dto.id;
                            param['countingTransType'] =
                                provider.typeGD.id.toString();

                            String percentFee = provider.percentFeeCtrl.text;
                            if (percentFee.contains(',')) {
                              param['percentFee'] =
                                  percentFee.replaceAll(',', '.');
                            } else {
                              param['percentFee'] = percentFee;
                            }

                            String vat = provider.vatCtrl.text;
                            if (percentFee.contains(',')) {
                              param['vat'] = vat.replaceAll(',', '.');
                            } else {
                              param['vat'] = vat.isEmpty ? '0' : vat;
                            }
                            _bloc.add(InsertServicePackEvent(param: param));
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
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget _buildInfoServicePack(SubServicePackDTO dto,
      {bool isSubItem = false, ServicePackProvider? provider}) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SelectableText(
                dto.shortName.isNotEmpty ? dto.shortName : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: SelectableText(
                dto.name.isNotEmpty ? dto.name : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                StringUtils.formatNumber(dto.activeFee.toString()),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                StringUtils.formatNumber(dto.annualFee.toString()),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                dto.monthlyCycle.toString() ?? '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                StringUtils.formatNumber(dto.transFee.toString() ?? '0'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                '${dto.percentFee}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                '${dto.percentFee}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 135,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectableText(
                dto.countingTransType == 0 ? 'Tất cả' : 'Chỉ GD có đối soát',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: SelectableText(
                dto.description.isNotEmpty ? dto.description : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 11, left: 20, right: 20),
              child: isSubItem
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        provider.showFromInsert(dto.id);
                      },
                      child: Text(
                        provider!.checkShowFromInsert(dto)
                            ? 'Đóng'
                            : 'Tạo gói nhỏ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: AppColor.BLUE_TEXT),
                      ),
                    ),
            ),
          ),
        ],
      ),
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
              'Gói dịch vụ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          InkWell(
            onTap: () {
              DialogWidget.instance.openPopupCenter(
                  child: CreateServicePackPopup(
                servicePackBloc: _bloc,
              ));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Tạo gói mới',
                style: TextStyle(fontSize: 12, color: AppColor.WHITE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateInput({
    String hintText = '',
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
  }) {
    return Container(
      height: 36,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: AppColor.GREY_BG),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 11),
        textAlign: TextAlign.center,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 11, color: AppColor.GREY_TEXT)),
      ),
    );
  }
}
