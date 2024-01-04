import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/account_is_merchant.dart';
import 'package:vietqr_admin/models/bank_account_sync_dto.dart';
import 'package:vietqr_admin/models/service_charge_dto.dart';
import 'package:vietqr_admin/models/synthesis_report_dto.dart';
import 'package:vietqr_admin/models/transaction_merchant_dto.dart';

class MerchantState extends Equatable {
  const MerchantState();

  @override
  List<Object?> get props => [];
}

class MerchantInitialState extends MerchantState {}

class MerchantLoadingState extends MerchantState {}

class MerchantLoadingActiveFeeState extends MerchantState {}

class MerchantLoadingInitState extends MerchantState {}

class MerchantCheckAccountIsMerchantSuccessfulState extends MerchantState {
  final AccountIsMerchantDTO dto;

  const MerchantCheckAccountIsMerchantSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class MerchantGetMerchantFeeSuccessfulState extends MerchantState {
  final List<ServiceChargeDTO> list;
  final bool isLoadingPage;

  const MerchantGetMerchantFeeSuccessfulState(
      {required this.list, this.isLoadingPage = false});

  @override
  List<Object?> get props => [list];
}

class MerchantLoadingListState extends MerchantState {}

class MerchantLoadMoreListState extends MerchantState {}

class MerchantGetListByUserSuccessfulState extends MerchantState {
  final List<TransactionMerchantDTO> list;
  final bool isLoadingPage;

  const MerchantGetListByUserSuccessfulState(
      {required this.list, this.isLoadingPage = false});

  @override
  List<Object?> get props => [list];
}

class MerchantGetListByMerchantSuccessfulState extends MerchantState {
  final List<TransactionMerchantDTO> list;
  final bool isLoadingPage;

  final bool isLoadMore;

  const MerchantGetListByMerchantSuccessfulState(
      {required this.list,
      this.isLoadingPage = false,
      this.isLoadMore = false});

  @override
  List<Object?> get props => [list];
}

class MerchantGetSynthesisReportSuccessfulState extends MerchantState {
  final List<SynthesisReportDTO> list;
  final bool isLoadingPage;

  const MerchantGetSynthesisReportSuccessfulState({
    required this.list,
    this.isLoadingPage = false,
  });

  @override
  List<Object?> get props => [list];
}

class UpdateNoteState extends MerchantState {}

class UpdateNoteMerchantFailedState extends MerchantState {
  final String msg;

  const UpdateNoteMerchantFailedState(this.msg);

  @override
  List<Object?> get props => [msg];
}

class MerchantGetSyncBankLoadingState extends MerchantState {}

class MerchantGetSyncBankSuccessfulState extends MerchantState {
  final List<BankAccountSync> list;
  const MerchantGetSyncBankSuccessfulState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class MerchantGetSyncBankFailedState extends MerchantState {}
