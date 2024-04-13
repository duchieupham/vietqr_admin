import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';

import '../../../../models/DTO/api_service_dto.dart';
import '../../../../models/DTO/bank_account_dto.dart';
import '../../../../models/DTO/callback_dto.dart';
import '../../../../models/DTO/customer_dto.dart';

class RunCallbackState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final CallBackType request;
  final List<CallBackDTO> listTrans;
  final List<CustomerDTO> listCustomers;
  final List<BankAccountDTO> listBankAccount;
  final ApiServiceDTO? apiServiceDTO;
  final bool isLoadMore;
  final int runCallBackSuccess;
  final String msgRunCallBack;

  final int offset;

  const RunCallbackState(
      {this.status = BlocStatus.NONE,
      this.msg,
      this.request = CallBackType.NONE,
      required this.listTrans,
      required this.listCustomers,
      required this.listBankAccount,
      this.apiServiceDTO,
      this.isLoadMore = false,
      this.offset = 0,
      this.runCallBackSuccess = 2,
      this.msgRunCallBack = ''});

  RunCallbackState copyWith({
    BlocStatus? status,
    CallBackType? request,
    String? msg,
    List<CallBackDTO>? listTrans,
    List<CustomerDTO>? listCustomers,
    List<BankAccountDTO>? listBankAccount,
    ApiServiceDTO? apiServiceDTO,
    bool? isLoadMore,
    int? runCallBackSuccess,
    String? msgRunCallBack,
    int? offset,
  }) {
    return RunCallbackState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listTrans: listTrans ?? this.listTrans,
      listCustomers: listCustomers ?? this.listCustomers,
      listBankAccount: listBankAccount ?? this.listBankAccount,
      apiServiceDTO: apiServiceDTO ?? this.apiServiceDTO,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      runCallBackSuccess: runCallBackSuccess ?? this.runCallBackSuccess,
      msgRunCallBack: msgRunCallBack ?? this.msgRunCallBack,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        listTrans,
      ];
}
