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

class TransactionFilterListEvent extends TransactionEvent {
  final int page;
  final int size;
  final int type;
  final String value;
  final String from;
  final String to;

  const TransactionFilterListEvent(
      {this.page = 1,
      required this.size,
      required this.type,
      this.value = '',
      required this.from,
      required this.to});

  @override
  List<Object?> get props => [page, size, type, value, from, to];
}

class TransactionGetDetailEvent extends TransactionEvent {
  final String id;

  const TransactionGetDetailEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
