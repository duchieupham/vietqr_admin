import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/widget/box_layout.dart';
import 'package:vietqr_admin/commons/widget/divider_widget.dart';
import 'package:vietqr_admin/commons/widget/textfield_widget.dart';
import 'package:vietqr_admin/feature/dashboard/bank/blocs/bank_type_bloc.dart';
import 'package:vietqr_admin/feature/dashboard/bank/events/bank_type_event.dart';
import 'package:vietqr_admin/feature/dashboard/bank/states/bank_type_state.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/bank_type_provider.dart';

import 'package:vietqr_admin/service/shared_references/provider/search_clear_provider.dart';

import '../../models/DTO/bank_type_dto.dart';

class SelectBankTypeWidget extends StatelessWidget {
  static final TextEditingController searchController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  static final SearchClearProvider _searchClearProvider =
      SearchClearProvider(false);
  static final List<BankTypeDTO> bankTypesResult = [];
  static final List<BankTypeDTO> bankTypes = [];
  static late BankTypeBloc bankTypeBloc;
  final bool authenticated;

  const SelectBankTypeWidget({super.key, this.authenticated = true});

  void initialServices(BuildContext context) {
    bankTypesResult.clear();
    bankTypes.clear();
    bankTypeBloc = BlocProvider.of(context);
    bankTypeBloc.add(const BankTypeEventGetListUnauthenticated());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Chọn ngân hàng',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        UnconstrainedBox(
          child: BoxLayout(
            width: 500 - 40,
            height: 50,
            borderRadius: 50,
            bgColor: Theme.of(context).canvasColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFieldWidget(
                      width: width,
                      hintText: 'Tìm theo tên',
                      controller: searchController,
                      keyboardAction: TextInputAction.done,
                      autoFocus: false,
                      onChange: (value) {
                        if (searchController.text.isNotEmpty) {
                          _searchClearProvider.updateClearSearch(true);
                          bankTypeBloc.add(
                            BankTypeEventSearch(
                              textSearch: searchController.text,
                              list: bankTypes,
                            ),
                          );
                        } else {
                          _searchClearProvider.updateClearSearch(false);
                        }
                      },
                      inputType: TextInputType.text,
                      isObscureText: false,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _searchClearProvider,
                  builder: (_, provider, child) {
                    return Visibility(
                      visible: provider == true,
                      child: InkWell(
                        onTap: () {
                          searchController.clear();
                          _searchClearProvider.updateClearSearch(false);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: BlocBuilder<BankTypeBloc, BankTypeState>(
            builder: (context, state) {
              if (state is BankTypeLoadingState) {
                return SizedBox(
                  width: width,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.GREEN,
                    ),
                  ),
                );
              }
              if (state is BankTypeGetListSuccessfulState) {
                if (state.list.isNotEmpty && bankTypes.isEmpty) {
                  bankTypes.addAll(state.list);
                  bankTypesResult.addAll(bankTypes);
                }
              }
              if (state is BankTypeSearchState) {
                bankTypesResult.clear();
                bankTypesResult.addAll(state.list);
              }
              return Visibility(
                visible: bankTypesResult.isNotEmpty,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: bankTypesResult.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return _buildBankTypeItem(
                        context, bankTypesResult[index], width);
                  },
                  separatorBuilder: (context, index) {
                    return DividerWidget(width: width);
                  },
                ),
              );
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
      ],
    );
  }

  Widget _buildBankTypeItem(
      BuildContext context, BankTypeDTO dto, double width) {
    return InkWell(
      onTap: () {
        _searchClearProvider.updateClearSearch(false);
        searchController.clear();
        Provider.of<BankTypeProvider>(context, listen: false)
            .updateBankType(dto);
        Navigator.pop(context);
      },
      child: BoxLayout(
        width: width,
        borderRadius: 0,
        bgColor: AppColor.TRANSPARENT,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                image: DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(
                    dto.imageId,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                (dto.bankShortName.trim().isEmpty)
                    ? '${dto.bankCode} - ${dto.bankName}'
                    : '${dto.bankShortName} - ${dto.bankName}',
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
