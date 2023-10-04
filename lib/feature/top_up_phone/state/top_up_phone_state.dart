import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/qr_code_dto.dart';
import 'package:vietqr_admin/models/transaction_vnpt_dto.dart';
import 'package:vietqr_admin/models/vnpt_transaction_static.dart';

class TopUpPhoneState extends Equatable {
  const TopUpPhoneState();

  @override
  List<Object?> get props => [];
}

class TopUpPhoneInitialState extends TopUpPhoneState {}

class TopUpPhoneLoadingState extends TopUpPhoneState {}

class TopUpPhoneLoadingLoadMoreState extends TopUpPhoneState {}

class TopUpPhoneLoadingGetListState extends TopUpPhoneState {}

class TopUpPhoneGetListTransactionSuccessState extends TopUpPhoneState {
  final List<TransactionVNPTDTO> result;
  final bool initPage;
  final bool isLoadMore;
  final VNPTTransactionStaticDTO transactionStaticDTO;
  const TopUpPhoneGetListTransactionSuccessState(
      {required this.result,
      this.initPage = false,
      this.isLoadMore = false,
      required this.transactionStaticDTO});

  @override
  List<Object?> get props => [result];
}

class TopUpPhoneCreateQRSuccessState extends TopUpPhoneState {
  final QRCodeTDTO qrCodeTDTO;

  const TopUpPhoneCreateQRSuccessState({required this.qrCodeTDTO});
  @override
  List<Object?> get props => [qrCodeTDTO];
}

class TopUpPhoneGetStaticSuccessState extends TopUpPhoneState {
  final VNPTTransactionStaticDTO transactionStaticDTO;

  const TopUpPhoneGetStaticSuccessState({required this.transactionStaticDTO});
  @override
  List<Object?> get props => [transactionStaticDTO];
}
