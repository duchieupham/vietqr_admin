import 'package:equatable/equatable.dart';

class TopUpPhoneEvent extends Equatable {
  const TopUpPhoneEvent();

  @override
  List<Object?> get props => [];
}

class GetTransactionListEvent extends TopUpPhoneEvent {
  final bool initPage;
  final bool isLoadMore;
  final int status;
  final int offset;
  const GetTransactionListEvent(
      {this.initPage = false,
      this.isLoadMore = false,
      required this.status,
      required this.offset});

  @override
  List<Object?> get props => [initPage, isLoadMore];
}

class CreateQrEvent extends TopUpPhoneEvent {
  final int amount;

  const CreateQrEvent({
    required this.amount,
  });

  @override
  List<Object?> get props => [amount];
}

class GetTransactionStaticEvent extends TopUpPhoneEvent {}
