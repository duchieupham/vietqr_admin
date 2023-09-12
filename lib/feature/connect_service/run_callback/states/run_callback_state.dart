import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/callback_dto.dart';
import 'package:vietqr_admin/models/customer_dto.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';

class RunCallbackState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final CallBackType request;
  final List<CallBackDTO> listTrans;
  final List<CustomerDTO> listCustomers;
  final List<BankAccountDTO> listBankAccount;
  final ApiServiceDTO? apiServiceDTO;
  final EcomerceDTO? ecomerceDTO;

  const RunCallbackState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = CallBackType.NONE,
    required this.listTrans,
    required this.listCustomers,
    required this.listBankAccount,
    this.apiServiceDTO,
    this.ecomerceDTO,
  });

  RunCallbackState copyWith({
    BlocStatus? status,
    CallBackType? request,
    String? msg,
    List<CallBackDTO>? listTrans,
    List<CustomerDTO>? listCustomers,
    List<BankAccountDTO>? listBankAccount,
    ApiServiceDTO? apiServiceDTO,
    EcomerceDTO? ecomerceDTO,
  }) {
    return RunCallbackState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      listTrans: listTrans ?? this.listTrans,
      listCustomers: listCustomers ?? this.listCustomers,
      listBankAccount: listBankAccount ?? this.listBankAccount,
      apiServiceDTO: apiServiceDTO ?? this.apiServiceDTO,
      ecomerceDTO: ecomerceDTO ?? this.ecomerceDTO,
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