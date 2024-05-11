import 'package:equatable/equatable.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionGetListEvent extends TransactionEvent {
  final Map<String, dynamic> param;
  final bool isLoadingPage;
  final bool isLoadMore;
  const TransactionGetListEvent(
      {required this.param,
      this.isLoadingPage = false,
      this.isLoadMore = false});

  @override
  List<Object?> get props => [param];
}

class TransactionGetDetailEvent extends TransactionEvent {
  final String id;

  const TransactionGetDetailEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
