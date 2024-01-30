import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/account_bank_rq_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/service_fee_dto.dart';

class RQBankAccountState extends Equatable {
  const RQBankAccountState();

  @override
  List<Object?> get props => [];
}

class RQBankAccountInitialState extends RQBankAccountState {}

class RQBankAccountLoadingState extends RQBankAccountState {}

class RQBankAccountLoadingInitState extends RQBankAccountState {}

class RQBankAccountLoadingLoadMoreState extends RQBankAccountState {}

class RQBankAccountGetListSuccessState extends RQBankAccountState {
  final List<AccountBankRQDTO> result;
  final bool initPage;
  final bool isLoadMore;
  const RQBankAccountGetListSuccessState(
      {required this.result, this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [result];
}

class RemoveBankAccountSuccessState extends RQBankAccountState {
  final ResponseMessageDTO dto;

  const RemoveBankAccountSuccessState({required this.dto});
  @override
  List<Object?> get props => [dto];
}

class RemoveBankAccountFailsState extends RQBankAccountState {
  final ResponseMessageDTO dto;

  const RemoveBankAccountFailsState({required this.dto});
  @override
  List<Object?> get props => [dto];
}

class ServicePackInsertSuccessState extends RQBankAccountState {
  final String servicePackId;

  const ServicePackInsertSuccessState({required this.servicePackId});
  @override
  List<Object?> get props => [servicePackId];
}

class ServicePackInsertFailsState extends RQBankAccountState {
  final ResponseMessageDTO dto;

  const ServicePackInsertFailsState({required this.dto});
  @override
  List<Object?> get props => [dto];
}

class GetListMerchantBankAccountLoadingState extends RQBankAccountState {}

class GetListMerchantBankAccountSuccessState extends RQBankAccountState {
  final List<MerchantFee> result;

  const GetListMerchantBankAccountSuccessState({required this.result});

  @override
  List<Object?> get props => [result];
}

class InsertBankAccountFailsState extends RQBankAccountState {
  final ResponseMessageDTO dto;

  const InsertBankAccountFailsState({required this.dto});
  @override
  List<Object?> get props => [dto];
}

class InsertBankAccountSuccessState extends RQBankAccountState {}
