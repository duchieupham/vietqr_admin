import 'package:equatable/equatable.dart';

class RQBankAccountEvent extends Equatable {
  const RQBankAccountEvent();

  @override
  List<Object?> get props => [];
}

class RQBankAccountListEvent extends RQBankAccountEvent {
  final bool initPage;
  final bool isLoadMore;
  final int offset;

  const RQBankAccountListEvent(
      {this.initPage = false, this.isLoadMore = false, this.offset = 0});

  @override
  List<Object?> get props => [initPage, isLoadMore];
}

class RemoveRQBankAccountEvent extends RQBankAccountEvent {
  final String id;

  const RemoveRQBankAccountEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class InsertServicePackEvent extends RQBankAccountEvent {
  final Map<String, dynamic> param;

  const InsertServicePackEvent({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}

class GetListMerchantBankAccountEvent extends RQBankAccountEvent {}

class InsertBankAccountFeeEvent extends RQBankAccountEvent {
  final Map<String, dynamic> param;

  const InsertBankAccountFeeEvent({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}
