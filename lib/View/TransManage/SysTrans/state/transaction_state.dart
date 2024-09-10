import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

import '../../../../models/DTO/transaction_detail_dto.dart';
import '../../../../models/DTO/transaction_dto.dart';
import '../../../../models/DTO/transaction_log_dto.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionGetListLoadingState extends TransactionState {}

class TransactionGetListLoadingLoadMoreState extends TransactionState {}

class TransactionGetListSuccessState extends TransactionState {
  final List<TransactionDTO> result;
  final bool isPopLoading;
  final bool isLoadMore;
  const TransactionGetListSuccessState(
      {required this.result,
      this.isPopLoading = false,
      this.isLoadMore = false});

  @override
  List<Object?> get props => [result];
}

class TransactionFilterListSuccessState extends TransactionState {
  final TransactionDTO result;
  final MetaDataDTO meta;

  const TransactionFilterListSuccessState(
      {required this.result, required this.meta});
  @override
  List<Object?> get props => [result, meta];
}

class TransactionGetDetailSuccessState extends TransactionState {
  final TransactionDetailDTO result;
  final List<TransactionLogDTO> listLog;
  const TransactionGetDetailSuccessState({
    required this.result,
    required this.listLog,
  });
  @override
  List<Object?> get props => [result, listLog];
}
