import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/callback_dto.dart';
import 'package:vietqr_admin/models/customer_dto.dart';

import 'blocs/callback_provider.dart';
import 'blocs/run_callback_bloc.dart';
import 'events/run_callback_event.dart';
import 'states/run_callback_state.dart';
import 'views/dialog_select_bank.dart';

class RunCallBackScreen extends StatelessWidget {
  const RunCallBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunCallbackBloc>(
      create: (_) => RunCallbackBloc(),
      child: ChangeNotifierProvider<CallbackProvider>(
        create: (context) => CallbackProvider(),
        child: _RunCallBackScreen(),
      ),
    );
  }
}

class _RunCallBackScreen extends StatefulWidget {
  @override
  State<_RunCallBackScreen> createState() => _RunCallBackScreenState();
}

class _RunCallBackScreenState extends State<_RunCallBackScreen> {
  late RunCallbackBloc _bloc;

  final controller = ScrollController();

  final List<DataModel> list = [
    DataModel(title: 'No.'),
    DataModel(title: 'Thời gian tạo'),
    DataModel(title: 'Số tài khoản'),
    DataModel(title: 'Giao dịch'),
    DataModel(title: 'Trạng thái'),
    DataModel(title: 'Nội dung'),
    DataModel(title: 'Action'),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetListCustomerEvent());
    });

    controller.addListener(_loadMore);
  }

  void _loadMore() async {
    String customerId =
        Provider.of<CallbackProvider>(context, listen: false).customerDTO.id;
    String bankId = Provider.of<CallbackProvider>(context, listen: false)
        .bankAccountDTO
        .bankId;

    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _bloc.add(GetTransLoadMoreEvent(
          customerId: customerId, bankId: bankId, isLoading: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallbackProvider>(
      builder: (context, provider, child) {
        return BlocConsumer<RunCallbackBloc, RunCallbackState>(
          listener: (context, state) {
            if (state.status == BlocStatus.LOADING) {
              DialogWidget.instance.openLoadingDialog();
            }

            if (state.status == BlocStatus.UNLOADING) {
              Navigator.pop(context);
            }

            if (state.request == CallBackType.CUSTOMERS) {
              if (state.listCustomers.isNotEmpty) {
                _bloc.add(
                    GetListBankEvent(customerId: state.listCustomers.first.id));
                provider.updateCustomer(state.listCustomers.first);
              }
            }

            if (state.request == CallBackType.BANKS) {
              if (state.listBankAccount.isNotEmpty) {
                String customerId = provider.customerDTO.id;

                _bloc.add(GetTransEvent(
                    customerId: customerId,
                    bankId: state.listBankAccount.first.bankId));
                provider.updateBankAccount(state.listBankAccount.first);
              } else {
                _bloc.add(GetTransEvent(customerId: '', bankId: ''));
              }
            }

            if (state.request == CallBackType.INFO_CONNECT) {
              if (state.apiServiceDTO != null &&
                  state.apiServiceDTO!.id.isNotEmpty) {
                _bloc.add(
                  GetTokenEvent(
                    systemUsername: state.apiServiceDTO!.systemUsername,
                    systemPassword: state.apiServiceDTO!.systemPassword,
                  ),
                );
              }
            }

            if (state.request == CallBackType.FREE_TOKEN) {
              final data = provider.callBackDTO;

              final Map<String, dynamic> body = {
                'bankAccount': data.bankAccount,
                'content': data.content,
                'amount': data.amount,
                'transType': data.transType,
              };

              _bloc.add(RunCallbackEvent(body));
            }

            if (state.request == CallBackType.RUN_CALLBACK ||
                state.request == CallBackType.RUN_ERROR) {
              String customerId = provider.customerDTO.id;
              String bankId = provider.bankAccountDTO.bankId;

              _bloc.add(GetTransEvent(customerId: customerId, bankId: bankId));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  _buildListConnect(state.listCustomers),
                  Expanded(
                    child: _buildContent(
                        context,
                        state.listTrans,
                        state.listBankAccount,
                        provider.bankAccountDTO,
                        state.isLoadMore),
                  ),
                  _buildLogRunCallback(
                      state.msg, provider.callBackDTO, state.request),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListConnect(List<CustomerDTO> list) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Danh sách kết nối',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          if (list.isNotEmpty)
            ...List.generate(list.length, (index) {
              final CustomerDTO data = list[index];
              final dataSelect =
                  Provider.of<CallbackProvider>(context, listen: false)
                      .customerDTO;
              return GestureDetector(
                onTap: () {
                  Provider.of<CallbackProvider>(context, listen: false)
                      .updateCustomer(data);

                  _bloc.add(GetListBankEvent(customerId: data.id));
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: dataSelect.id == data.id
                      ? AppColor.BLUE_TEXT.withOpacity(0.3)
                      : AppColor.TRANSPARENT,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.merchant,
                    style: TextStyle(
                      color: dataSelect.id == data.id
                          ? AppColor.BLUE_TEXT
                          : AppColor.BLACK,
                    ),
                  ),
                ),
              );
            }).toList()
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<CallBackDTO> listCallBack,
    List<BankAccountDTO> listBanks,
    BankAccountDTO bankAccountDTO,
    bool isLoadMore,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
            if (listBanks.isEmpty)
              const Text(
                'Không có dữ liệu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            else ...[
              Row(
                children: [
                  const Text(
                    'Tài khoản ngân hàng đã kết nối',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () async {
                      final data = await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return DialogSelectBank(
                            list: listBanks,
                          );
                        },
                      );

                      if (data != null && data is BankAccountDTO) {
                        if (!mounted) return;
                        Provider.of<CallbackProvider>(context, listen: false)
                            .updateBankAccount(data);
                      }
                    },
                    child: const Text(
                      'Chọn TK ngân hàng khác',
                      style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bankAccountDTO.imgId.isNotEmpty)
                      Image(
                        height: 24,
                        fit: BoxFit.fitHeight,
                        image: ImageUtils.instance
                            .getImageNetWork(bankAccountDTO.imgId),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bankAccountDTO.bankShortName} - ${bankAccountDTO.bankAccount}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(bankAccountDTO.customerBankName),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Danh sách giao dịch',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            String customerId = Provider.of<CallbackProvider>(
                                    context,
                                    listen: false)
                                .customerDTO
                                .id;
                            String bankId = Provider.of<CallbackProvider>(
                                    context,
                                    listen: false)
                                .bankAccountDTO
                                .bankId;

                            _bloc.add(GetTransEvent(
                                customerId: customerId, bankId: bankId));
                          },
                          child: const Text(
                            'Refresh Danh sách',
                            style: TextStyle(
                              color: AppColor.BLUE_TEXT,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(list.length, (index) {
                              return _buildTableTitle(list[index].title, index);
                            }).toList(),
                          ),
                          Expanded(
                            child: ListView(controller: controller, children: [
                              Column(
                                children:
                                    List.generate(listCallBack.length, (index) {
                                  CallBackDTO model = listCallBack[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildTableContent('${index + 1}',
                                          index: 0),
                                      _buildTableContent(model.createdTime,
                                          index: 1),
                                      _buildTableContent(
                                          model.bankAccount ?? '',
                                          index: 2),
                                      _buildTableContent(
                                          model.transType == 'D'
                                              ? '- ${StringUtils.formatNumber(model.amount)}'
                                              : '+ ${StringUtils.formatNumber(model.amount)}',
                                          index: 3),
                                      _buildTableContent(model.getStatus,
                                          index: 4),
                                      _buildTableContent(model.content ?? '',
                                          index: 5),
                                      _buildTableContent(
                                        model.status == 0
                                            ? 'Chạy callback'
                                            : '-',
                                        index: 6,
                                        isRunCallback: model.status == 0,
                                        onTap: () {
                                          if (model.status == 0) {
                                            Provider.of<CallbackProvider>(
                                                    context,
                                                    listen: false)
                                                .updateCallbackDTO(model);

                                            final customerDTO =
                                                Provider.of<CallbackProvider>(
                                                        context,
                                                        listen: false)
                                                    .customerDTO;
                                            _bloc.add(
                                              GetInfoConnectEvent(
                                                  platform: 'API service',
                                                  id: customerDTO.id),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              if (!isLoadMore)
                                const UnconstrainedBox(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColor.BLUE_TEXT,
                                    ),
                                  ),
                                )
                            ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]
          ]
        ],
      ),
    );
  }

  Widget _buildTableTitle(String title, int index) {
    return Expanded(
      flex: (index == 0)
          ? 1
          : (index == 3)
              ? 2
              : 3,
      child: Container(
        alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
        margin: const EdgeInsets.only(bottom: 12),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildTableContent(
    String title, {
    bool isRunCallback = false,
    int index = 2,
    GestureTapCallback? onTap,
  }) {
    return Expanded(
      flex: (index == 0)
          ? 1
          : (index == 3)
              ? 2
              : 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SelectableText(
            title,
            style: TextStyle(
              color: isRunCallback ? AppColor.BLUE_TEXT : AppColor.BLACK,
              fontSize: 13,
              decoration: isRunCallback
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogRunCallback(
    String? msg,
    CallBackDTO dto,
    CallBackType type,
  ) {
    return Container(
      padding: const EdgeInsets.only(right: 16.0),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
            child: Text(
              'Log chạy callback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ID giao dịch:'),
                const SizedBox(height: 4),
                Text(
                  dto.id ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trạng thái:'),
                const SizedBox(height: 4),
                if (type == CallBackType.RUN_CALLBACK)
                  const Text(
                    'SUCCESS',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                else if (type == CallBackType.RUN_ERROR)
                  const Text(
                    'FAILED',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                else
                  const Text(''),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lỗi :'),
                const SizedBox(height: 4),
                Text(
                  msg ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataModel {
  final String title;
  final String? content;
  final String? index;

  DataModel({required this.title, this.content, this.index});
}
